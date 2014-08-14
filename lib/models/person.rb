class Person
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :lastname, type: String
  field :email, type: String

  embedded_in :package_version
end
