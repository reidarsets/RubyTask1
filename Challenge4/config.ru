require "bundler/setup"
require "hanami/api"
require_relative 'controllers/home'
require_relative 'controllers/upload'
require_relative 'controllers/states_report'

class MyApp < Hanami::API
  get "/", to: Home.new
  get "/upload", to: Upload.new
  post "/upload", to: Upload.new
  get "/reports/states", to: StatesReport.new
  get "/reports/states/:id", to: StatesReport.new
end

run MyApp.new