module Utils
  def get_package_info name, version, package, settings
    description_path = /DESCRIPTION/
    package_url = "#{settings.base_url}#{name}_#{version}.tar.gz"
    puts package_url

    #for testing
    #package_info = {"Package"=>"AdequacyModel", "Type"=>"Package", "Title"=>"Adequacy of probabilistic models and generation of pseudo-random numbers.", "Authors@R"=>"c(person(given = \"Pedro Rafael\", family = \"Diniz Marinho\", role = c(\"aut\", \"cre\"), email = \"pedro.rafael.marinho@gmail.com\"), person(given = \"Marcelo\", family = \"Bourguignon\", role = c(\"aut\",\"ctb\"), email = \"m.p.bourguignon@gmail.com\"), person(given = \"Cicero Rafael\", family = \"Barros Dias\", role = c(\"aut\",\"ctb\"), email = \"cicerorafael@gmail.com\"))", "Version"=>"1.0.8", "Date"=>"2013-09-12", "Maintainer"=>"Pedro Rafael Diniz Marinho <pedro.rafael.marinho@gmail.com>", "Description"=>"This package provides some useful functions for calculating quality measures for adjustment, including statistics Kolmogorov-Smirnov, Cramer-von Mises and Anderson-Darling. These statistics are often used to compare models not equipped. Also provided are other measures of fitness, such as AIC, CAIC, BIC and HQIC. The package also provides functions for generating pseudo-random number of random variables that follow the following probability distributions: Kumaraswamy Birnbaum-Saunders, Kumaraswamy Pareto, Exponentiated Weibull and Kumaraswamy Weibull.", "URL"=>"http://www.r-project.org", "License"=>"GPL (>= 2)", "Author"=>"Pedro Rafael Diniz Marinho [aut, cre], Marcelo Bourguignon [aut, ctb], Cicero Rafael Barros Dias [aut, ctb]", "NeedsCompilation"=>"no", "Repository"=>"CRAN", "Packaged"=>"2013-12-20 15:38:04 UTC; pedro", "Date/Publication"=>"2013-12-20 17:01:24"}
    #authors = try_get_authors(package_info['Authors@R'])
    #puts authors

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
            puts package_info
            puts ""

            create_package_version(package, package_info)
          end
        end
        tar_extract.close
        remote_file.close
      end
    rescue OpenURI::Error, Timeout::Error => e
      puts "#{e.class}: #{e.message} with package #{name}. Try with next package..."
      return
    end
  end

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
        re_data = Regexp.new('\((given\s?=\s?)?"(?<name>.+?)",\s?(family\s?=\s?)?"(?<lastname>.*?)",((?!email).)*\s?(email\s?=\s?"(?<email>.+?)")?')
        m = re_data.match(a)
        return "" unless m #pattern didn't work, return nothing.
        email = m[:email] ? "<#{m[:email]}>" : ""
        authors += "#{m[:name]} #{m[:lastname]} #{email.strip!}, "
      end
      authors = authors[0..-3]
    end
    authors
  end

  def get_packages_hash settings
      response = HTTParty.get(settings.packages_url)
      all_packages = Dcf.parse response.body.force_encoding("UTF-8")

      #get just a few packages
      all_packages.take settings.number_of_packages
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

    #try to get authors and emails from Author@R
    authors = try_get_authors(package_info['Authors@R'])
    package_v.authors = authors unless authors.empty?
    puts package_v.inspect

    package_v.save!
  end
end
