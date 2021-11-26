require 'pg'
require 'erb'
require './DB/connect_db'

class OfficeInstallationSearch
    def call(env)
        @offices = CONN.exec('SELECT * FROM offices;')
        return [200, { 'Content-Type' => 'text/html' }, [ERB.new(File.read('views/office_installation_search.erb')).result(binding)]]
    end
end
