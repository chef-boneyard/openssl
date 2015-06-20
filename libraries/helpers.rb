module OpenSSLCookbook
  # Helper functions for the OpenSSL cookbook.
  module Helpers
    # rubocop:disable Metrics/AbcSize, Style/IndentationConsistency

    include Chef::DSL::IncludeRecipe

    def self.included(_base)
      require 'openssl' unless defined?(OpenSSL)
    end

    def key_file_valid?(key_file_path, key_password = nil)
      # Check if the key file exists
      # Verify the key file contains a private key
      return false unless File.exist?(key_file_path)
      key = OpenSSL::PKey::RSA.new File.read(key_file_path), key_password
      key.private?
    end
  end
end
