require_relative "../helpers/utils"
include Utils
module Services
  class GetPackageService
    def self.run settings
      #get packages document
      get_packages_hash settings do |packages|
        packages.each do |package|
          name = package["Package"]
          version = package["Version"]
          $log.info "Reading package: #{name}, version: #{version}"
          #search package
          pack = Package.where(name: name).first

          #check if pack and package version exists
          if pack && !pack.package_versions.where(version: version).exists?
            $log.info "Package already exists but package version doesn't exist"
            #create new package version
            get_package_info(name, version, pack, settings)
          else
            #create new package
            $log.info "Package doesn't exist"
            pack = Package.create(name: name)
            get_package_info(name, version, pack, settings)
          end
        end
      end
    end
  end
end
