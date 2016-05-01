# This Chefspec test was created by Chef generate
#
# Cookbook Name:: openssl
# Spec:: resource-rsa-key
#
# Author:: Charles Johnson (<charles@chef.io>)
#
# Copyright 2015-2016, Chef Software, Inc.
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

describe 'test::resource_rsa_key' do
  context 'When all attributes are default, on an unspecified platform:' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(step_into: ['openssl_rsa_key'])
      runner.converge(described_recipe)
    end

    it 'adds a file resource \'/etc/ssl_test/rsakey.pem\' with action delete' do
      expect(chef_run).to delete_file('any potential existing unsecured key')
        .with(path: '/etc/ssl_test/rsakey.pem')
    end

    it 'adds a file resource \'/etc/ssl_test/rsakey.pem\' with action delete' do
      expect(chef_run).to delete_file('any potential existing passworded key')
        .with(path: '/etc/ssl_test/rsakeypass.pem')
    end

    it 'adds a directory resource \'/etc/ssl_test\' with action create' do
      expect(chef_run).to create_directory('/etc/ssl_test')
    end

    it 'adds an openssl_rsa_key resource \'/etc/ssl_test/rsakey.pem\' with action create' do
      expect(chef_run).to create_rsa_key('/etc/ssl_test/rsakey.pem')
    end

    it 'The LWRP adds a file resource \'/etc/ssl_test/rsakey.pem\' with action create' do
      expect(chef_run).to create_file('/etc/ssl_test/rsakey.pem')
    end

    it 'adds an openssl_rsa_key resource \'/etc/ssl_test/rsakeypass.pem\' with action create' do
      expect(chef_run).to create_rsa_key('/etc/ssl_test/rsakeypass.pem')
        .with(key_pass: 'oink')
    end

    it 'The LWRP adds a file resource \'/etc/ssl_test/rsakeypass.pem\' with action create' do
      expect(chef_run).to create_file('/etc/ssl_test/rsakeypass.pem')
    end
  end
end
