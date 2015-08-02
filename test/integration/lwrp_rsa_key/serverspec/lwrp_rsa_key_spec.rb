require 'spec_helper'

describe 'test::lwrp_x509' do
  # Serverspec examples can be found at
  # http://serverspec.org/resource_types.html
  describe command('openssl rsa -in /etc/ssl_test/rsakey.pem -check -noout') do
    it 'generates a valid unsecured private key' do
      expect(subject.exit_status).to eq 0
    end
  end

  describe command('echo oink | openssl rsa -in /etc/ssl_test/rsakeypass.pem -check -noout -passin stdin') do
    it 'generates a valid passworded private key' do
      expect(subject.exit_status).to eq 0
    end
  end
end
