configure do
  set :packages_url, "http://cran.r-project.org/src/contrib/PACKAGES"
  set :base_url, "http://cran.r-project.org/src/contrib/"
  set :number_of_packages, 100
end

configure :development do
  LOGGER = Logger.new("log/sinatra.log")
end

configure :production do
  set :logging, true
end
