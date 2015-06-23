
actions [:create]
default_action :create

attribute :name,        :kind_of => String,  :name_attribute => true
attribute :key_length,  :kind_of => Integer, :default => 2048
attribute :generator,   :equal_to => [2, 5], :default => 2
attribute :owner,       :kind_of => String
attribute :group,       :kind_of => String
attribute :mode,        :kind_of => [Fixnum, String]
