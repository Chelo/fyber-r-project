require_relative "../helpers/utils"
include Utils
module Services
  class GetPackageService
    def self.run settings
      #get packages document
      packages = get_packages_hash settings
      packages.each do |package|
        name = package["Package"]
        version = package["Version"]
        $log.info "Reading package: #{name}, version: #{version}"
        #search package
        pack = Package.where(name: name).first
        if pack
          $log.info "Package already exists"
          #search package version
          pack_version = pack.package_versions.where(version: version).first
          unless pack_version
            $log.info "Package version doesn't exists"
            #create new package version
            get_package_info(name, version, pack, settings)
          end
        else
          #create new package
          $log.info "Package doesn't exists"
          pack = Package.create(name: name)
          get_package_info(name, version, pack, settings)
        end
      end
    end
  end
end
