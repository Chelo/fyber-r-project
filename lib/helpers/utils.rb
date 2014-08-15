module Utils
  def get_package_info name, version, package, settings
    description_path = /DESCRIPTION/
    package_url = "#{settings.base_url}#{name}_#{version}.tar.gz"
    puts package_url

    #for testing
    #package_info = {"Package"=>"ACNE", "Version"=>"0.7.0", "Depends"=>"R (>= 2.15.0), aroma.affymetrix (>= 2.11.0)", "Imports"=>"MASS, R.methodsS3 (>= 1.5.2), R.oo (>= 1.15.8), R.utils (>= 1.27.1), matrixStats (>= 0.8.12), R.filesets (>= 2.3.0)", "Date"=>"2013-10-17", "Title"=>"Affymetrix SNP probe-summarization using non-negative matrix factorization", "Authors@R"=>"c( person(\"Maria\", \"Ortiz\", role=c(\"aut\")), person(\"Henrik\", \"Bengtsson\", role=c(\"aut\", \"cre\", \"cph\"), email=\"henrikb@braju.com\"), person(\"Angel\", \"Rubio\", role=c(\"aut\")))", "Description"=>"Package for NMF summarization of SNP probes.", "License"=>"LGPL (>= 2.1)", "URL"=>"http://r-forge.r-project.org/projects/snpsprocessing/", "LazyLoad"=>"TRUE", "biocViews"=>"Infrastructure, Microarray, DNACopyNumber, Preprocessing, aCGH, SNP, CopyNumberVariants", "Packaged"=>"2013-10-17 23:00:06 UTC; hb", "Author"=>"Maria Ortiz [aut], Henrik Bengtsson [aut, cre, cph], Angel Rubio [aut]", "Maintainer"=>"Henrik Bengtsson <henrikb@braju.com>", "NeedsCompilation"=>"no", "Repository"=>"CRAN", "Date/Publication"=>"2013-10-19 00:11:21"}

    #getting tar.gz
    open(package_url) do |remote_file|
      #getting tar
      tar_extract = Gem::Package::TarReader.new(Zlib::GzipReader.open(remote_file))
      tar_extract.rewind
      tar_extract.each do |entry|
        #search description file
        if entry.full_name =~ description_path
          package_v = package.package_versions.new
          package_info = Dcf.parse(entry.read)[0]
          puts package_info
          puts ""

          #getting the info
          package_v.version = version
          publication_date = package_info["Date/Publication"]
          package_v.publication_date = Date.parse(publication_date, "%Y-%m-%d %I:%M:%S")
          package_v.title = package_info["Title"]
          package_v.description = package_info["Description"]
          if package_info.key? 'Authors@R'
            package_v.authors = get_authors(package_info['Authors@R'])
          elsif package_info.key? 'Author'
            package_v.authors = package_info['Author'].force_encoding("UTF-8")
          end
          package_v.maintainers = package_info['Maintainer']
          puts package_v.inspect
          package_v.save!
        end
      end
      tar_extract.close
      remote_file.close
    end
  end

  def get_authors authors_string
    #get persons
    authors = authors_string
    re_persons = Regexp.new('c?\(?\s*(?<persons>.+)\)?')
    m = re_persons.match(authors_string)
    if m
      p =  m['persons'].split("person")
      p.delete("")
      #get name, last name and email
      authors = ""
      p.each do |a|
        rt = Regexp.new('\("(?<name>.+?)",\s?"(?<lastname>.*?)",((?!email).)+\s?(email\s?=\s?"(?<email>.+?)")?')
        m = rt.match(a)
        email = m[:email] ? "<#{m[:email]}>" : ""
        authors += "#{m[:name]} #{m[:lastname]} #{email}, "
      end
      authors = authors[0..-3]
    end
    authors
  end

  def get_packages_hash settings
      response = HTTParty.get(settings.packages_url)
      all_packages = Dcf.parse response.body

      #get just a few packages
      all_packages.take settings.number_of_packages
  end
end
