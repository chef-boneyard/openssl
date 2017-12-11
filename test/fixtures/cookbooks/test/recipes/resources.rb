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
# RSA KEYS HERE
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

# we need to do this with a file resource so that chefspec stepping
# into openssl_rsa_public_key can function. It's :(
file '/etc/ssl_test/private_key.pem' do
  content '-----BEGIN RSA PRIVATE KEY----- Proc-Type: 4,ENCRYPTED DEK-Info: DES-EDE3-CBC,1F2FDA436115C4EE W24gBmtq/Eik2FkSdBh3hF3th3gFq2lMZqSLbho/JVbHFpAQynDbcS9qH5x1fRkt Y7o4A/Sh7noy9kzC1eVIPaQpKFJu5da+uf3t1KxpVMqibzeIE33P9WI+5PzzOm5W xs9shvv/0anU6UMsqBqI+0cmQQ8lw3myTTpO9yWKav2FdTnx7svd+P6BmFknGQaM DYomD0qiB/JzjXbYHLgFspPQXHdyQGhe/YFMlvmjKE0Nut18XJsNwUTWjBA4nRj4 JdlE8XOkWrzIsWKfrBhuhx9bTD0ZVvgssYl2QEh26mv0P0nxx4V/zYx+9U5j0L7q tV4FXfQTgFyctKySuBNi8IT1HFqG9LQps14p8q0XeRigFsRUOVuR0S3eHqg7xiiW QVdF+LgYPpdVNX2mHOSFnHMpFdKLHs8VCNjcGwMNK7avKbne/TJ2NRcL4uhgpsX/ 4tg1kQlwIwtp8MlMqkcinHJ3fjIhWGgjNBVe85NJPVogRDy+c80SqBenaJSavwVA ytmiQOCeon4zhZdscESki+KmsyOWkPB9/zQK76E4ni2IVOL6ZYBMJNTkP47WmA9d Etv7UMxQMI6EYMEH43czvbe4bNCC+hlYotJUM2B52Al7I79W9sSy8cmYi3YZEl0G xtKgY7XwstUBD2XjMuaNyUT0EDjcoa0GhLJSCQkvgn8//BGKaLEyb+Lr+dmHGvxM phCnUKLkfZn9hAFempSJuW4iSaeBKIU3KgYOkBooTuYhXqbN2McoxH6Ec/gnAM5e TIaLiDaHY8IPI4Et5l0sr7v+YF3ZGKC1fL6k4eInNRlhy8oWsFMe79jKkh5wRflt WifTbEdy3D53pVH5lbXyJwpBIOjKJ0OqGWGegu02P5JTsAsniKD+jxNUS8iSOAXL gtpMe4jtqj38hb9D7pBir85Hm+uDqeEuwUqSXAiI+P2F/Jf4ep3h+ek8dcgZtkJQ 3iz92ic2g3M7HW+EE0JcBX+KBwU7yI+UJbWvNQmTXUAYbpoQOLIVm/TrFdGzZ6e9 t0T5wmkE2cS9C3QYiEc7D81nTcTadZChZJDURzUk2REwRGjnunQggHUsj/JKVWqO EPZbpgyDhCaIAkkloWK/SgKny4irMZClhVdeq+v55vDf9nbKR9bgHUb2ZNwp6DQc CPs1BteYthiLtILYzzasMKhlfdoUjEaYziYLGkAQca5XwvwEp0qWg0sMCUUL9pbW 9WzFELBvqNQ1WyIcjb4clcvM0fJdGZ2nKbCAw6zbeSQcGd50NzvTra0xE/J2q6Jo 0V6AGr1Zmu4bJ+tGZCdAIteEO2TosNfS6nrFy15DAe4M4+77ZUGJ8rcwOBopa9qI w7aAyPlfAhrtdSrbOLLp0kRP9EwzSIjSoqc/YJINaNMN8WM7JgnfklmPToT2AqPc 6MOX/Uktag6AXzjcQDtIZSQox326emX1o/huw+7z3/lSXgTdxm3brew/is+9iaQh 5katqPtbec+K/4qydINZSRRFPaoVkg27+6OXvd1AbVS7jmUGHL20xyzA0A9c1csN dm460w4eqbjJEUtDucyIhLPhtYJwPODoRitRmIrzF5DSPrgmSiG93TPiDpRfVPPU -----END RSA PRIVATE KEY-----'
end

openssl_rsa_public_key '/etc/ssl_test/rsakey_des3.pub' do
  private_key_path '/etc/ssl_test/rsakey_des3.pem'
  private_key_pass 'something'
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
