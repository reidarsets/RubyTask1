require 'pg'
require 'erb'
require './DB/connect_db'

class StatesReport
    def call(env)
        @offices = []
        if env['router.params'][:id]
            @offices = CONN.exec("SELECT * FROM offices WHERE state='#{env['router.params'][:id].upcase}'")
        else
            @offices = CONN.exec("SELECT * FROM offices ORDER BY state;")
        end
        [200, { 'Content-Type' => 'text/html' }, [ERB.new(File.read('views/states_report.erb')).result(binding)]]
    end
end