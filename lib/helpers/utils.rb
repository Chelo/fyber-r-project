module Utils
  def get_package_info name, version, package, settings
    description_path = /DESCRIPTION/
    package_url = "#{settings.base_url}#{name}_#{version}.tar.gz"

    #getting tar.gz
    begin
      open(package_url) do |remote_file|
        #getting tar
        tar_extract = Gem::Package::TarReader.new(Zlib::GzipReader.open(remote_file))
        tar_extract.rewind
        tar_extract.each do |entry|
          #search description file
          if entry.full_name =~ description_path
            content = entry.read.encode("UTF-8", "binary", invalid: :replace, undef: :replace, replace: '')
            package_info = Dcf.parse(content)[0]
            create_package_version(package, package_info)
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

  #Funtion created for trying to get more info from the authors using Authors@R
  #finally it will not be used for inconsistent formats, it's more practice get
  #the author info from author key
  def try_get_authors authors_string
    #get persons
    authors = ""
    re_persons = Regexp.new('c?\(?\s*(?<persons>.+)\)?')
    m = re_persons.match(authors_string)
    if m
      p = m['persons'].split("person")
      p.delete("")
      #get name, last name and email
      p.each do |a|
        re_data = Regexp.new('\((given\s?=\s?)?"(?<name>.+?)",\s?(family\s?=\s?)?"(?<lastname>.*?)",((?!email).)+\s?(email\s?=\s?"(?<email>.+?)")?')
        m = re_data.match(a)
        puts m
        return "" unless m #pattern didn't work, return nothing.
        email = m[:email] ? "<#{m[:email]}>" : ""
        authors += "#{m[:name]} #{m[:lastname]} #{email.strip!}, "
      end
      authors = authors[0..-3]
    end
    authors
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

  def create_package_version package, package_info
    publication_date = package_info["Date/Publication"]
    #getting the info
    package_v = package.package_versions.new
    package_v.version = package_info["Version"]
    package_v.publication_date = Time.parse(publication_date)
    package_v.title = package_info["Title"]
    package_v.description = package_info["Description"]
    package_v.maintainers = package_info['Maintainer']
    package_v.authors = package_info['Author']
    package_v.save!
  end
end
