# This Chefspec test was created by Chef generate
#
# Cookbook:: openssl
# Spec:: resource-dhparam
#
# Author:: Charles Johnson (<charles@chef.io>)
#
# Copyright:: 2015-2017, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Chefspec examples can be found at
# https://github.com/sethvargo/chefspec/tree/master/examples

require 'spec_helper'

describe 'test::resources' do
  context 'the openssl_dhparam resource:' do
    cached(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04', step_into: ['openssl_dhparam'])
      runner.converge(described_recipe)
    end

    it 'adds a directory resource \'/etc/ssl_test\' with action create' do
      expect(chef_run).to create_directory('/etc/ssl_test')
    end

    it 'The resource adds a file resource \'/etc/ssl_test/dhparam.pem\' with action create' do
      expect(chef_run).to create_file('/etc/ssl_test/dhparam.pem')
    end
  end

  context 'the openssl_x509_certificate resource:' do
    cached(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04', step_into: ['openssl_x509'])
      runner.converge(described_recipe)
    end

    it 'adds a directory resource \'/etc/ssl_test\' with action create' do
      expect(chef_run).to create_directory('/etc/ssl_test')
    end

    it 'The resource adds a file resource \'/etc/ssl_test/mycert.crt\' with action create_if_missing' do
      expect(chef_run).to create_file_if_missing('/etc/ssl_test/mycert.crt')
    end

    it 'The resource adds a file resource \'/etc/ssl_test/mycert.key\' with action create_if_missing' do
      expect(chef_run).to create_file_if_missing('/etc/ssl_test/mycert.key')
    end

    it 'The resource adds a file resource \'/etc/ssl_test/mycert2.crt\' with action create_if_missing' do
      expect(chef_run).to create_file_if_missing('/etc/ssl_test/mycert2.crt')
    end

    it 'The resource adds a file resource \'/etc/ssl_test/my_ca.crt\' with action create_if_missing' do
      expect(chef_run).to create_file_if_missing('/etc/ssl_test/my_ca.crt')
    end

    it 'The resource adds a file resource \'/etc/ssl_test/my_ca.key\' with action create_if_missing' do
      expect(chef_run).to create_file_if_missing('/etc/ssl_test/my_ca.crt')
    end
  end

  context 'the openssl_x509_request resource:' do
    cached(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04', step_into: ['openssl_x509_request'])
      runner.converge(described_recipe)
    end

    it 'adds a directory resource \'/etc/ssl_test\' with action create' do
      expect(chef_run).to create_directory('/etc/ssl_test')
    end

    it 'The resource adds a file resource \'/etc/ssl_test/my_ec_request.csr\' with action create' do
      expect(chef_run).to create_file('/etc/ssl_test/my_ec_request.csr')
    end

    it 'The resource adds a file resource \'/etc/ssl_test/my_ec_request.key\' with action create' do
      expect(chef_run).to create_file_if_missing('/etc/ssl_test/my_ec_request.key')
    end

    it 'The resource adds a file resource \'/etc/ssl_test/my_ec_request2.csr\' with action create' do
      expect(chef_run).to create_file('/etc/ssl_test/my_ec_request2.csr')
    end

    it 'The resource adds a file resource \'/etc/ssl_test/my_rsa_request.csr\' with action create' do
      expect(chef_run).to create_file('/etc/ssl_test/my_rsa_request.csr')
    end

    it 'The resource adds a file resource \'/etc/ssl_test/my_rsa_request.key\' with action create' do
      expect(chef_run).to create_file_if_missing('/etc/ssl_test/my_rsa_request.key')
    end

    it 'The resource adds a file resource \'/etc/ssl_test/my_rsa_request2.csr\' with action create' do
      expect(chef_run).to create_file('/etc/ssl_test/my_rsa_request2.csr')
    end
  end

  context 'the openssl_rsa_private_key resource:' do
    cached(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04', step_into: ['openssl_rsa_private_key'])
      runner.converge(described_recipe)
    end

    it 'adds a directory resource \'/etc/ssl_test\' with action create' do
      expect(chef_run).to create_directory('/etc/ssl_test')
    end

    it 'The resource adds a file resource \'/etc/ssl_test/rsakey_des3.pem\' with action create' do
      expect(chef_run).to create_file('/etc/ssl_test/rsakey_des3.pem')
    end
  end

  # This does not work at the moment due to the private key not existing
  # context 'the openssl_rsa_public_key resource:' do
  #   cached(:chef_run) do
  #     runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04', step_into: ['openssl_rsa_public_key'])
  #     runner.converge(described_recipe)
  #   end
  #
  #   it 'The resource adds a file resource \'/etc/ssl_test/rsakey_des3.pub\' with action create' do
  #     expect(chef_run).to create_file('/etc/ssl_test/rsakey_des3.pub')
  #   end
  # end

  context 'the openssl_ec_private_key resource:' do
    cached(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04', step_into: ['openssl_ec_private_key'])
      runner.converge(described_recipe)
    end

    it 'adds a directory resource \'/etc/ssl_test\' with action create' do
      expect(chef_run).to create_directory('/etc/ssl_test')
    end

    it 'The resource adds a file resource \'/etc/ssl_test/eckey_prime256v1_des3.pem\' with action create' do
      expect(chef_run).to create_file('/etc/ssl_test/eckey_prime256v1_des3.pem')
    end
  end
end
