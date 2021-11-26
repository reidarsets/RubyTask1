require "bundler/setup"
require "hanami/api"
require_relative 'controllers/home'
require_relative 'controllers/upload'
require_relative 'controllers/states_report'
require_relative 'controllers/fixture_report'

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