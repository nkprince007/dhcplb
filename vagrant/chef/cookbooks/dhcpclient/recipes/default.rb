# Copyright (c) Facebook, Inc. and its affiliates.
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

apt_repository 'kea-repo' do
  uri 'https://dl.cloudsmith.io/public/isc/kea-2-2/deb/debian'
  distribution 'bullseye'
  components ['main']
  deb_src true
  trusted true
end

# this contains perfdhcp utility
package 'isc-kea-admin' do
  action :install
end
