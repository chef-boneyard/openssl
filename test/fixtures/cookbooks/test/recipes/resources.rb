#
# Cookbook:: test
# Recipe:: resource_dhparam
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

%w(
  /etc/ssl_test/rsakey_des3.pem
  /etc/ssl_test/rsakey_aes128cbc.pem
  /etc/ssl_test/dhparam.pem
  /etc/ssl_test/mycert.crt
  /etc/ssl_test/mycert.key
  /etc/ssl_test/mycert2.crt
).each do |f|
  file "delete existing test file #{f}" do
    path f
    action :delete
  end
end

# Create directory if not already present
directory '/etc/ssl_test' do
  recursive true
end

#
# DHPARAM HERE
#

# Generate new key and certificate
openssl_dhparam '/etc/ssl_test/dhparam.pem' do
  key_length 1024
  action :create
end

#
# RSA KEY HERE
#

# Generate new key with des3 cipher using the new resource name
openssl_rsa_private_key '/etc/ssl_test/rsakey_des3.pem' do
  key_length 2048
  action :create
end

# Generate new key with aes-128-cbc cipher with the old resource name
openssl_rsa_key '/etc/ssl_test/rsakey_aes128cbc.pem' do
  key_length 1024
  key_cipher 'aes-128-cbc'
  action :create
end

#
# X509 HERE
#

# Generate new key and certificate
openssl_x509 '/etc/ssl_test/mycert.crt' do
  common_name 'mycert.example.com'
  org 'Test Kitchen Example'
  org_unit 'Kitchens'
  country 'UK'
  subject_alt_name ['IP:127.0.0.1', 'DNS:localhost.localdomain']
end

# Generate a new certificate from an existing key
openssl_x509 '/etc/ssl_test/mycert2.crt' do
  common_name 'mycert2.example.com'
  org 'Test Kitchen Example'
  org_unit 'Kitchens'
  country 'UK'
  key_file '/etc/ssl_test/mycert.key'
end
