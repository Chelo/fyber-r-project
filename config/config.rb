Dir.mkdir('log') unless File.exist?('log')
configure do
  set :packages_url, "http://cran.r-project.org/src/contrib/PACKAGES"
  set :base_url, "http://cran.r-project.org/src/contrib/"
  set :number_of_packages, nil
end

configure :production do
  $log = Logger.new(STDOUT)
  $log.level = Logger::DEBUG
end

configure :development, :test  do
  $log = Logger.new("log/output.log", "weekly")
  $log.level = Logger::DEBUG
end

