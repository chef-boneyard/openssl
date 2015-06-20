require_relative '../../spec_helper'
require_relative '../../../libraries/helpers'

describe OpenSSLCookbook::Helpers do
  let(:instance) do
    Class.new { include OpenSSLCookbook::Helpers }.new
  end

  describe '.included' do
    it 'requires openssl' do
      instance
      expect(defined?(OpenSSL)).to_not be(false)
    end
  end

  describe '#key_file_valid?' do
    require 'tempfile'

    cipher =  OpenSSL::Cipher::Cipher.new('des3')

    before(:each) do
      @keyfile = Tempfile.new('keyfile')
    end

    context 'When the key file does not exist' do
      it 'returns false' do
        expect(instance.key_file_valid?('/tmp/bad_filename')).to be_falsey
      end
    end

    context 'When the key file does exist, but does not contain a valid rsa private key' do
      it 'Throws an OpenSSL::PKey::RSAError exception' do
        expect do
          @keyfile.puts('I_am_not_a_key_I_am_a_free_man')
          @keyfile.close
          instance.key_file_valid?(@keyfile.path)
        end.to raise_error(OpenSSL::PKey::RSAError)
      end
    end

    context 'When the key file does exist, and does contain a vaild rsa private key' do
      it 'returns true' do
        @keyfile.puts(OpenSSL::PKey::RSA.new(2048).to_pem)
        @keyfile.close
        expect(instance.key_file_valid?(@keyfile.path)).to be_truthy
      end
    end

    context 'When a valid keyfile requires a passphrase, and an invalid passphrase is supplied' do
      it 'Throws an OpenSSL::PKey::RSAError exception' do
        expect do
          @keyfile.puts(OpenSSL::PKey::RSA.new(2048).to_pem(cipher, 'oink'))
          @keyfile.close
          instance.key_file_valid?(@keyfile.path, 'poml')
        end.to raise_error(OpenSSL::PKey::RSAError)
      end
    end

    context 'When a valid keyfile requires a passphrase, and a valid passphrase is supplied' do
      it 'returns true' do
        @keyfile.puts(OpenSSL::PKey::RSA.new(2048).to_pem(cipher, 'oink'))
        @keyfile.close
        expect(instance.key_file_valid?(@keyfile.path, 'oink')).to be_truthy
      end
    end

    after(:each) do
      @keyfile.unlink
    end
  end
end
