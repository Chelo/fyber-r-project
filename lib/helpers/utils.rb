module Utils
  def get_package_info name, version, package, settings
    description_path = "#{name}/DESCRIPTION"
    package_url = "#{settings.base_url}#{name}_#{version}.tar.gz"

    #getting tar.gz
    begin
      open(package_url) do |remote_file|
        #getting tar
        tar_extract = Gem::Package::TarReader.new(Zlib::GzipReader.open(remote_file))
        tar_extract.rewind
        tar_extract.each do |entry|
          #search description file
          if entry.full_name == description_path
            content = entry.read.encode("UTF-8", "binary", invalid: :replace, undef: :replace, replace: '')
            package_info = Dcf.parse(content)[0]
            package.create_package_version(package_info)
          end
        end
        tar_extract.close
        remote_file.close
      end
    rescue Timeout::Error => e
      $log.error "#{e.class}: #{e.message} with package #{name}. Try with next package..."
      return
    end
  end

  def get_packages_hash(settings)
    response = HTTParty.get(settings.packages_url)
    split_packages = response.body.force_encoding("UTF-8").split("\n\n")
    counter = 0
    l = settings.number_of_packages || split_packages.length
    while counter < l
      counter += 50
      yield Dcf.parse split_packages[(counter-50)..(counter>l ? l-1 : counter-1)].join("\n\n")
    end
  end
end
