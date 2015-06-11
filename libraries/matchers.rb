if defined?(ChefSpec)
  def create_x509_certificate(name)
    ChefSpec::Matchers::ResourceMatcher.new(:openssl_x509, :create, name)
  end
end
