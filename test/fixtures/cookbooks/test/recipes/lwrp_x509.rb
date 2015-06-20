#
# Cookbook Name:: test
# Recipe:: lwrp_x509
#
# Copyright:: Copyright (c) 2015, Chef Software, Inc. <legal@chef.io>
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Ensure files are not present, so the lwrp makes new keys every time
file '/etc/ssl_test/mycert.crt' do
  action :delete
end

file '/etc/ssl_test/mycert.key' do
  action :delete
end

file '/etc/ssl_test/mycert2.crt' do
  action :delete
end

# Create directory if not already present
directory '/etc/ssl_test' do
  recursive true
end

# Generate new key and certificate
openssl_x509 '/etc/ssl_test/mycert.crt' do
  common_name 'mycert.example.com'
  org 'Test Kitchen Example'
  org_unit 'Kitchens'
  country 'UK'
end

# Generate a new key from an existing certificate
openssl_x509 '/etc/ssl_test/mycert2.crt' do
  common_name 'mycert2.example.com'
  org 'Test Kitchen Example'
  org_unit 'Kitchens'
  country 'UK'
  key_file '/etc/ssl_test/mycert.key'
end
