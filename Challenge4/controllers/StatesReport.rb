require 'csv'
require 'pg'
require 'erb'
require './DB/connect_db'

class StatesReport
    def call(env)
        @result = []
        if env['router.params'][:id]
            @result = CONN.exec("SELECT * FROM offices WHERE state='#{env['router.params'][:id].upcase}'")
            if @result.first
                @result = [@result]
            else
                return [404, { 'Content-Type' => 'text/html' }, [ERB.new(File.read('views/Home.erb')).result(binding)]]
            end
        else
            CONN.exec('SELECT DISTINCT state FROM offices;').each do |state|
                @result << CONN.exec("SELECT * FROM offices WHERE state='#{state['state']}'")
            end
        end
        [200, { 'Content-Type' => 'text/html' }, [ERB.new(File.read('views/StatesReport.erb')).result(binding)]]
    end
end