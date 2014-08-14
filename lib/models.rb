rbfiles = File.join("**", "*.rb")
Dir.glob("#{$ROOT}/lib/models/#{rbfiles}").each do |model_file|
  require model_file
end
