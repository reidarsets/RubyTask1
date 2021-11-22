require "bundler/setup"
require "hanami/api"
require_relative 'controllers/Home'
require_relative 'controllers/Upload'
require_relative 'controllers/StatesReport'
require_relative 'controllers/FixtureReport'

class MyApp < Hanami::API
  get "/", to: Home.new
  get "/upload", to: Upload.new
  post "/upload", to: Upload.new
  get "/reports/states", to: StatesReport.new
  get "/reports/states/:id", to: StatesReport.new

  get "/reports/offices/fixture_types", to: FixtureReport.new
  get "/reports/offices/:id/fixture_types", to: FixtureReport.new
end

run MyApp.new