require 'pg'
require 'erb'
require './DB/connect_db'

class OfficeInstallationReport
    def call(env)
        @result = {}
        @total = {}
        if env['router.params'][:id]
            office_id = env['router.params'][:id]
            @office = CONN.exec("SELECT * FROM offices WHERE id='#{office_id}'").first
            if !@office
                return [200, { 'Content-Type' => 'text/html' }, [ERB.new(File.read('views/Home.erb')).result(binding)]]
            end

            zones = CONN.exec_params("SELECT DISTINCT type FROM zones WHERE office_id = $1;", [office_id])
            @area = 0
            @people = 0
            zones.each do |zone|
                @result[zone['type']] = {}
                rooms = CONN.exec_params("SELECT * FROM rooms WHERE zone_id IN
                (SELECT id FROM zones WHERE office_id = $1 and type = $2);", 
                [office_id, zone['type']])
                rooms.each do |room|
                    @area += room['area'].to_i
                    @people += room['max_people'].to_i
                    materials = CONN.exec_params("SELECT materials.type mat_type, materials.name mat_name, fixtures.name fix_name, fixtures.type fix_type
                        FROM ((rooms INNER JOIN fixtures ON rooms.id = fixtures.room_id)
                        INNER JOIN materials ON materials.fixture_id = fixtures.id)
                        where room_id = $1;", [room['id']])
                    @result[zone['type']][room['name']] = materials
                end
            end
        else
            return [200, { 'Content-Type' => 'text/html' }, [ERB.new(File.read('views/Home.erb')).result(binding)]]
        end
        return [200, { 'Content-Type' => 'text/html' }, [ERB.new(File.read('views/OfficeInstallationReport.erb')).result(binding)]]
    end
end