require 'rack/test'
require './app'

RSpec.configure do |config|
    config.include Rack::Test::Methods
end

describe "APP" do
  include Rack::Test::Methods
  include Utils

  def app
    Sinatra::Application
  end

  before :each do
    (1..5).each do |i|
      paq = Package.create! name: "package#{i}"
      paq.package_versions.create!(version: "0.0", description: "descr", title: "titlle", publication_date: Time.now, 
                                   authors: "Foo Bar <foo@email.com>", maintainers: "maintainername maintainerlastname <em@email.com>")
    end
  end

  describe "GET /packages" do
    it 'render packages' do
      paq = Package.first
      pv = paq.package_versions.first
      get '/packages'
      expect(last_response.body).to include(paq.name)
      expect(last_response.body).to include(pv.version)
    end
  end

  describe "GET /packages/:package_id" do
    it "shows package info" do
      paq = Package.first
      pv = paq.package_versions.first
      get "/packages/#{paq.id}"
      expect(last_response.body).to include(paq.name)
      expect(last_response.body).to include(pv.version)
    end
  end

  describe "not found" do
    it "shows not_found page" do
      get "/"
      expect(last_response.body).to include("PAGE NOT FOUND")
    end
  end
end
