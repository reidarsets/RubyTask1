require 'csv'
require 'pg'
require 'erb'

class Home
    def call(env)
        [200, { 'Content-Type' => 'text/html' }, [ERB.new(File.read('views/home.html')).result(binding)]]
    end
end