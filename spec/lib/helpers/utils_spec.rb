require File.expand_path '../../../spec_helper.rb', __FILE__
ENV['RACK_ENV'] = 'test'

describe "Utils" do
  include Rack::Test::Methods
  def app
    Sinatra::Application
  end
  describe "get_package_info" do
    before do
      file = "BaBooN_0.1-6.tar.gz"
      allow(Utils).to receive(:open).and_return file
      expect(app).to receive(:create_package_version).and_return true
    end
    it "should get package and create package version" do
      paq = double("package")
      app.get_package_info("shape", "1.4.1", paq, app.settings)
    end
  end

  describe "get_package_hash" do
    before do
      res = double("response")
      @packages = [{"Package"=>"sdckmsd", "Version"=>"1.7-05", "Depends"=>"R (>= 2.15.0), xtable, pbapply", "Suggests"=>"randomForest, e1071", "License"=>"GPL (>= 2)", "NeedsCompilation"=>"no"}]
      allow(HTTParty).to receive(:get).and_return(res)
      allow(res).to receive_message_chain(:body, :force_encoding)
      allow(Dcf).to receive(:parse).and_return(@packages)
    end
    it "return package hash" do
      expect(app.get_packages_hash(app.settings)).to eq(@packages)
    end
  end

  describe "create_package_version" do
    it 'should create new plackage version from package' do
      package_info = {"Package"=>"AdequacyModel", "Type"=>"Package", "Title"=>"Adequacy of probabilistic models and generation of pseudo-random numbers.", "Authors@R"=>"c(person(given = \"Pedro Rafael\", family = \"Diniz Marinho\", role = c(\"aut\", \"cre\"), email = \"pedro.rafael.marinho@gmail.com\"), person(given = \"Marcelo\", family = \"Bourguignon\", role = c(\"aut\",\"ctb\"), email = \"m.p.bourguignon@gmail.com\"), person(given = \"Cicero Rafael\", family = \"Barros Dias\", role = c(\"aut\",\"ctb\"), email = \"cicerorafael@gmail.com\"))", "Version"=>"1.0.8", "Date"=>"2013-09-12", "Maintainer"=>"Pedro Rafael Diniz Marinho <pedro.rafael.marinho@gmail.com>", "Description"=>"This package provides some useful functions for calculating quality measures for adjustment, including statistics Kolmogorov-Smirnov, Cramer-von Mises and Anderson-Darling. These statistics are often used to compare models not equipped. Also provided are other measures of fitness, such as AIC, CAIC, BIC and HQIC. The package also provides functions for generating pseudo-random number of random variables that follow the following probability distributions: Kumaraswamy Birnbaum-Saunders, Kumaraswamy Pareto, Exponentiated Weibull and Kumaraswamy Weibull.", "URL"=>"http://www.r-project.org", "License"=>"GPL (>= 2)", "Author"=>"Pedro Rafael Diniz Marinho [aut, cre], Marcelo Bourguignon [aut, ctb], Cicero Rafael Barros Dias [aut, ctb]", "NeedsCompilation"=>"no", "Repository"=>"CRAN", "Packaged"=>"2013-12-20 15:38:04 UTC; pedro", "Date/Publication"=>"2013-12-20 17:01:24"}
      pack = Package.create name: "TestPack"
      expect(pack.package_versions.empty?).to eq(true)
      app.create_package_version pack, package_info
      expect(pack.reload.package_versions.empty?).to eq(false)
    end
  end
end
