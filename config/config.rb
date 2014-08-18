Dir.mkdir('log') unless File.exist?('log')
$log = Logger.new(STDOUT)

configure do
  set :packages_url, "http://cran.r-project.org/src/contrib/PACKAGES"
  set :base_url, "http://cran.r-project.org/src/contrib/"
  set :number_of_packages, nil
end

configure :production do
  $log.level = Logger::DEBUG
end

configure :development do
  $log.level = Logger::DEBUG
end

