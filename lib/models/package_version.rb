class PackageVersion
  include Mongoid::Document
  include Mongoid::Timestamps

  field :version, type: String
  field :publication_date, type: DateTime
  field :title, type: String
  field :description, type: String
  embeds_many :persons
  embedded_in :package
end
