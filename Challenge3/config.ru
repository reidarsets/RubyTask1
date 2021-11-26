require "bundler/setup"
require "hanami/api"
require_relative 'controllers/home'
require_relative 'controllers/upload'

class MyApp < Hanami::API
  get "/", to: Home.new
  get "/upload", to: Upload.new
  post "/upload", to: Upload.new
end

run MyApp.new