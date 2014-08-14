class Package
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  embeds_many :package_versions
end
