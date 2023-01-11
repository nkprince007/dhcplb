# Copyright (c) Facebook, Inc. and its affiliates.
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

node.default['golang']['version'] = '1.19.1'

include_recipe 'golang'

apt_package %w(isc-dhcp-relay gcc vim zsh git)

%w( /home/vagrant/go /opt/go /opt/go/bin ).each do |path|
  directory path do
    owner 'vagrant'
    group 'vagrant'
    mode '0755'
    recursive true
  end
end

# template '/etc/default/isc-dhcp-relay' do
#   source 'etc_default_isc-dhcp-relay.erb'
#   owner 'root'
#   group 'root'
#   mode '0644'
#   notifies :restart, 'service[isc-dhcp-relay]'
# end

service 'isc-dhcp-relay' do
  action [:disable, :stop]
end
