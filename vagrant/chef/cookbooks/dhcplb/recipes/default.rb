# Copyright (c) Facebook, Inc. and its affiliates.
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

node.default['golang']['version'] = '1.19.1'

include_recipe 'golang'

apt_package %w(gcc vim zsh git)

%w( /home/vagrant/conf /home/vagrant/go /opt/go /opt/go/bin ).each do |path|
  directory path do
    owner 'vagrant'
    group 'vagrant'
    mode '0755'
    recursive true
  end
end

execute "install dhcplb" do
  command "go install -trimpath -ldflags='-w -s -extldflags=-static'"
  cwd "/home/vagrant/go/src/github.com/nkprince007/dhcplb"
  user 'vagrant'
  group 'vagrant'
  environment({
    PATH: "#{node['golang']['install_dir']}/go/bin:#{node['golang']['gobin']}:" \
          '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    GOPATH: node['golang']['gopath'],
    GOBIN: node['golang']['gobin'],
    GOCACHE: '/tmp/go',
    CGO_ENABLED: '0',
  })
end

cookbook_file '/home/vagrant/conf/dhcplb.config.json' do
  source 'dhcplb.config.json'
  notifies :reload, 'systemd_unit[dhcplb.service]', :immediately
end

template '/home/vagrant/conf/dhcp-servers-v4.cfg' do
  source 'dhcp-servers-v4.cfg.erb'
  # dhcplb will auto load files that change. no need to notify.
end

systemd_unit 'dhcplb.service' do
  content <<~EOU
  [Unit]
  Description=Run dhcplb
  After=network.target

  [Service]
  Type=simple
  ExecStart=/opt/go/bin/dhcplb -version 4 -config /home/vagrant/conf/dhcplb.config.json
  ExecReload=/bin/kill -HUP $MAINPID
  KillMode=process
  Restart=always
  User=root
  Group=root

  [Install]
  WantedBy=multiuser.target
  EOU

  action [:create, :enable, :restart]
end
