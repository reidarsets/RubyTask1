require "bundler/setup"
require "hanami/api"
require_relative 'controllers/Home'
require_relative 'controllers/Upload'
require_relative 'controllers/StatesReport'

class MyApp < Hanami::API
  get "/", to: Home.new
  get "/upload", to: Upload.new
  post "/upload", to: Upload.new
  get "/reports/states", to: StatesReport.new
  get "/reports/states/:id", to: StatesReport.new
end

run MyApp.new