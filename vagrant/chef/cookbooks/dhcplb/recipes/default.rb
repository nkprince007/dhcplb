# Copyright (c) Facebook, Inc. and its affiliates.
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

node.default['golang']['packages'] = ['github.com/nkprince007/dhcplb']
node.default['golang']['version'] = '1.17.13'

include_recipe 'golang'

directory '/home/vagrant/go' do
  owner 'vagrant'
  group 'vagrant'
  recursive true
end

cookbook_file '/home/vagrant/dhcplb.config.json' do
  source 'dhcplb.config.json'
  notifies :restart, 'service[dhcplb]'
end

template '/home/vagrant/dhcp-servers-v4.cfg' do
  source 'dhcp-servers-v4.cfg.erb'
  # dhcplb will auto load files that change. no need to notify.
end

# Configure service via https://github.com/poise/poise-service
# poise_service 'dhcplb' do
#   command '/opt/go/bin/dhcplb -version 4 -config /home/vagrant/dhcplb.config.json'
# end

service 'dhcplb' do
  start_command '/opt/go/bin/dhcplb -version 4 -config /home/vagrant/dhcplb.config.json'
end