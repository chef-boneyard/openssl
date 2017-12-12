# This Chefspec test was created by Chef generate
#
# Cookbook:: openssl
# Spec:: upgrade_spec
#
# Author:: Joshua Timberman (<jtimberman@chef.io>)
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

require 'spec_helper'

describe 'openssl::upgrade' do
  context 'When all attributes are default, on Ubuntu 16.04 the recipe:' do
    cached(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04')
      runner.converge(described_recipe)
    end

    it 'installs the correct packages' do
      expect(chef_run).to upgrade_package(['libssl1.0.0', 'openssl'])
    end
  end

  context 'When all attributes are default, on Debian 8 the recipe:' do
    cached(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'debian', version: '8.9')
      runner.converge(described_recipe)
    end

    it 'installs the correct packages' do
      expect(chef_run).to upgrade_package(['libssl1.0.0', 'openssl'])
    end
  end

  context 'When all attributes are default, on Debian 9 the recipe:' do
    cached(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'debian', version: '9.1')
      runner.converge(described_recipe)
    end

    it 'installs the correct packages' do
      expect(chef_run).to upgrade_package(['libssl1.0.2', 'openssl'])
    end
  end

  context 'When all attributes are default, on CentOS, the recipe:' do
    cached(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '6.9')
      runner.converge(described_recipe)
    end

    it 'installs the correct packages' do
      expect(chef_run).to upgrade_package(['openssl'])
    end
  end

  context 'When all attributes are default, on openSUSE, the recipe:' do
    cached(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'opensuse', version: '42.3')
      runner.converge(described_recipe)
    end

    it 'installs the correct packages' do
      expect(chef_run).to upgrade_package('openssl')
    end
  end

  context 'When the [\'openssl\'][\'restart_services\'] array is set to [\'httpd\'], the recipe:' do
    cached(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '6.9')
      runner.node.normal['openssl']['restart_services'] = ['httpd']
      runner.converge('test::httpd', described_recipe)
    end

    it 'The created package resource to upgrade openssl notifies the httpd service resource to restart' do
      expect(chef_run.package('openssl')).to notify('service[httpd]').to(:restart)
    end
  end
end
