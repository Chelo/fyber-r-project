class Package
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  embeds_many :package_versions

  def create_package_version package_info
    $log.info "Creating package version for #{self.name}"
    publication_date = package_info["Date/Publication"]
    #getting the info
    package_v = self.package_versions.new
    package_v.version = package_info["Version"]
    package_v.publication_date = Time.parse(publication_date)
    package_v.title = package_info["Title"]
    package_v.description = package_info["Description"]
    package_v.maintainers = package_info['Maintainer']
    package_v.authors = package_info['Author']
    package_v.save!
  end
end
