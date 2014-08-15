class PackageVersion
  include Mongoid::Document
  include Mongoid::Timestamps

  field :version, type: String
  field :publication_date, type: DateTime
  field :title, type: String
  field :description, type: String
  field :authors, type: String, default: ""
  field :maintainers, type: String, default: ""
  embedded_in :package
end
