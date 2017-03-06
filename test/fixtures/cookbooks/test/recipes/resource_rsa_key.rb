#
# Cookbook:: test
# Recipe:: resource_rsa_key
#
# Copyright:: 2015-2017, Chef Software, Inc. <legal@chef.io>
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

apt_update 'update'

# Ensure files are not present, so the resource makes new keys every time
file 'any potential existing unsecured key' do
  path '/etc/ssl_test/rsakey.pem'
  action :delete
end

file 'any potential existing passworded key' do
  path '/etc/ssl_test/rsakeypass.pem'
  action :delete
end

# Create directory if not already present
directory '/etc/ssl_test' do
  recursive true
end

# Generate new key
openssl_rsa_key '/etc/ssl_test/rsakey.pem' do
  key_length 1024
  action :create
end

# Generate new key with password
openssl_rsa_key '/etc/ssl_test/rsakeypass.pem' do
  key_length 1024
  key_pass 'oink'
  action :create
end
