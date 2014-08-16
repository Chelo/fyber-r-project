require File.expand_path '../../../spec_helper.rb', __FILE__

describe "Services::GetPackageService" do
  include Rack::Test::Methods
  include Utils
  def app
    Sinatra::Application
  end
  describe "run" do
      before do
        packages = [{"Package"=>"sdckmsd", "Version"=>"1.7-05", "Depends"=>"R (>= 2.15.0), xtable, pbapply", "Suggests"=>"randomForest, e1071", "License"=>"GPL (>= 2)", "NeedsCompilation"=>"no"}]
        package_info = {"Package"=>"AdequacyModel", "Type"=>"Package", "Title"=>"Adequacy of probabilistic models and generation of pseudo-random numbers.", "Authors@R"=>"c(person(given = \"Pedro Rafael\", family = \"Diniz Marinho\", role = c(\"aut\", \"cre\"), email = \"pedro.rafael.marinho@gmail.com\"), person(given = \"Marcelo\", family = \"Bourguignon\", role = c(\"aut\",\"ctb\"), email = \"m.p.bourguignon@gmail.com\"), person(given = \"Cicero Rafael\", family = \"Barros Dias\", role = c(\"aut\",\"ctb\"), email = \"cicerorafael@gmail.com\"))", "Version"=>"1.0.8", "Date"=>"2013-09-12", "Maintainer"=>"Pedro Rafael Diniz Marinho <pedro.rafael.marinho@gmail.com>", "Description"=>"This package provides some useful functions for calculating quality measures for adjustment, including statistics Kolmogorov-Smirnov, Cramer-von Mises and Anderson-Darling. These statistics are often used to compare models not equipped. Also provided are other measures of fitness, such as AIC, CAIC, BIC and HQIC. The package also provides functions for generating pseudo-random number of random variables that follow the following probability distributions: Kumaraswamy Birnbaum-Saunders, Kumaraswamy Pareto, Exponentiated Weibull and Kumaraswamy Weibull.", "URL"=>"http://www.r-project.org", "License"=>"GPL (>= 2)", "Author"=>"Pedro Rafael Diniz Marinho [aut, cre], Marcelo Bourguignon [aut, ctb], Cicero Rafael Barros Dias [aut, ctb]", "NeedsCompilation"=>"no", "Repository"=>"CRAN", "Packaged"=>"2013-12-20 15:38:04 UTC; pedro", "Date/Publication"=>"2013-12-20 17:01:24"}
        allow(Services::GetPackageService).to receive(:get_packages_hash).and_return(packages)
        allow(Services::GetPackageService).to receive(:get_package_info).and_return(package_info)
      end
    context "if package exists" do
      before do
        paq = double("package")
        allow(Package).to receive_message_chain(:where, :first).and_return(paq)
        allow(paq).to receive_message_chain(:package_versions, :where, :first).and_return(nil)
      end
      context "if pack version doesnt exist" do
        it "create new package version" do
          Services::GetPackageService.run app.settings
        end
      end
    end

    context "if package doesn't exists" do
      before do
        allow(Package).to receive_message_chain(:where, :first).and_return(nil)
        expect(Package).to receive(:create)
      end
      it "create package" do
        Services::GetPackageService.run app.settings
      end
    end
  end
end
