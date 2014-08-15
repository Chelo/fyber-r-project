require_relative "../helpers/utils"
include Utils
module Services
  class GetPackageService
    def self.run settings
      puts "Looking for packages file"
      #get packages document
      packages = get_packages_hash settings

      #for testing
      #packages = [{"Package"=>"sdckmsd", "Version"=>"1.7-05", "Depends"=>"R (>= 2.15.0), xtable, pbapply", "Suggests"=>"randomForest, e1071", "License"=>"GPL (>= 2)", "NeedsCompilation"=>"no"}]

      packages.each do |package|
        name = package["Package"]
        version = package["Version"]
        puts "Package: #{name}, Version: #{version}"
        #search package
        pack = Package.where(name: name).first
        if pack
          puts "Package exists"
          #search package version
          pack_version = pack.package_versions.where(version: version).first
          unless pack_version
            puts "Package version doesn't exists"
            #create new package version
            get_package_info(name, version, pack, settings)
          end
        else
          #create new package
          puts "package doesn't exists"
          pack = Package.create(name: name)
          get_package_info(name, version, pack, settings)
        end
      end
    end
  end
end
