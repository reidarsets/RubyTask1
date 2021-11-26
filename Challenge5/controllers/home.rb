require 'erb'

class Home
    def call(env)
        [200, { 'Content-Type' => 'text/html' }, [ERB.new(File.read('views/home.erb')).result(binding)]]
    end
end