require 'pg'
require 'erb'
require './DB/connect_db'

class FixtureReport
    def call(env)
        @result = {}
        @fixtures = []
        @count = {}
        @total = {}
        @types = CONN.exec('SELECT DISTINCT type FROM fixtures;')
        @types.each do |type|
            @fixtures = CONN.exec_params("SELECT * FROM fixtures WHERE type = $1;", [type["type"]])
            @fixtures.each do |fixture|
                @zones = CONN.exec_params("SELECT * FROM zones WHERE id = $1;", [fixture["room_id"]])
                @zones.each do |zone|
                    if !@result[type["type"]]
                        @result[type["type"]] = []
                        @count[type["type"]] = {}
                    end
                    if env['router.params'][:id]
                        office = CONN.exec("SELECT * FROM offices WHERE id = #{env['router.params'][:id]};")
                    else
                        office = CONN.exec("SELECT * FROM offices WHERE id = #{zone["office_id"]};")
                    end
                    @result[type["type"]] << office[0]
                    
                    if @count[type["type"]][office[0]]
                        @count[type["type"]][office[0]] += 1
                    else
                        @count[type["type"]][office[0]] = 1
                    end
                end
            end

            @total[type["type"]] = @result[type["type"]].length
            @result[type["type"]].uniq!
        end
        return [200, { 'Content-Type' => 'text/html' }, [ERB.new(File.read('views/FixtureReport.erb')).result(binding)]]
    end
end