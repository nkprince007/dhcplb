# Copyright (c) Facebook, Inc. and its affiliates.
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

node.default['golang']['version'] = '1.19.1'

include_recipe 'golang'

apt_package %w(gcc vim zsh git isc-dhcp-server)

node.default['dhcpserver']['subnets'] = [
  {'subnet' => '192.168.50.0', 'range' => []},
  {'subnet' => '192.168.51.0', 'range' => ['192.168.51.150', '192.168.51.250']}
]

template '/etc/dhcp/dhcpd.conf' do
  source 'dhcpd.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  # notifies :restart, 'service[isc-dhcp-server]'
end

cookbook_file '/etc/default/isc-dhcp-server' do
  source 'etc_default_isc-dhcp-server'
  owner 'root'
  group 'root'
  mode '0644'
  # notifies :restart, 'service[isc-dhcp-server]'
end

# service 'isc-dhcp-server' do
#     action [:enable, :start]
# end

%w( /home/vagrant/go /opt/go /opt/go/bin ).each do |path|
  directory path do
    owner 'vagrant'
    group 'vagrant'
    mode '0755'
    recursive true
  end
end