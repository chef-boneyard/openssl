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

  describe '#dhparam_pem_valid?' do
    require 'tempfile'

    before(:each) do
      @dhparam_file = Tempfile.new('dhparam')
    end

    context 'When the dhparam.pem file does not exist' do
      it 'returns false' do
        expect(instance.dhparam_pem_valid?('/tmp/bad_filename')).to be_falsey
      end
    end

    context 'When the dhparam.pem file does exist, but does not contain a valid dhparam key' do
      it 'Throws an OpenSSL::PKey::RSAError exception' do
        expect do
          @dhparam_file.puts('I_am_not_a_key_I_am_a_free_man')
          @dhparam_file.close
          instance.dhparam_pem_valid?(@dhparam_file.path)
        end.to raise_error(OpenSSL::PKey::DHError)
      end
    end

    context 'When the dhparam.pem file does exist, and does contain a vaild dhparam key' do
      it 'returns true' do
        @dhparam_file.puts(OpenSSL::PKey::DH.new(1024).to_pem)
        @dhparam_file.close
        expect(instance.dhparam_pem_valid?(@dhparam_file.path)).to be_truthy
      end
    end

    after(:each) do
      @dhparam_file.unlink
    end
  end

  describe '#gen_dhparam' do
    context 'When a non-Integer key length is given' do
      it 'Throws a TypeError' do
        expect do
          instance.gen_dhparam('string')
        end.to raise_error(OpenSSL::PKey::DHError)
      end
    end

    context 'When a proper key length is given' do
      it 'Generates a dhparam object' do
        expect(instance.gen_dhparam(1024)).to be_kind_of(OpenSSL::PKey::DH)
      end
    end
  end

  describe '#get_key_filename' do
    context 'When the input is not a string' do
      it 'Throws a TypeError' do
        expect do
          instance.get_key_filename(33)
        end.to raise_error(TypeError)
      end
    end

    context 'when the input is a string' do
      it 'Generates valid keyfile names' do
        expect(instance.get_key_filename('/etc/temp.crt')).to match('/etc/temp.key')
      end
    end
  end
end
