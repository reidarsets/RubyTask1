require 'csv'
require 'pg'
require 'erb'
require './create_db'

class Upload
    def call(env)
        request = Rack::Request.new(env)
        if request.get?
            [200, { 'Content-Type' => 'text/html' }, [ERB.new(File.read('views/upload.html')).result(binding)]]
        else
            file = File.read(request.params['file'][:tempfile])
            parsed = CSV.parse(file, headers: true)

            parsed.each { |row|
                CONN.exec_params("INSERT INTO offices (id, title, address, city, state, phone, lob, type) VALUES 
                    (DEFAULT, $1, $2, $3, $4, $5, $6, $7);",
                    [row["Office"], row["Office address"], row["Office city"], row["Office State"], row["Office phone"],
                    row["Office lob"], row["Office type"]])
            }
            parsed.each { |row|
                CONN.exec_params("INSERT INTO zones (id, type, office_id) VALUES 
                    (DEFAULT, $1, (SELECT id from offices WHERE title = $2 ORDER BY offices ASC LIMIT 1));",
                    [row['Zone'], row["Office"]])
            }
            parsed.each { |row|
                CONN.exec_params("INSERT INTO rooms (id, name, area, max_people, zone_id) VALUES 
                    (DEFAULT, $1, $2, $3, (SELECT id FROM zones WHERE (zones.type = $4 AND zones.office_id = 
                    (SELECT id from offices WHERE title = $5 ORDER BY offices ASC LIMIT 1)) ORDER BY zones ASC LIMIT 1));",
                    [row["Room"], row["Room area"], row["Room max people"], row["Zone"],row["Office"]])
            }
            parsed.each { |row|
                CONN.exec_params("INSERT INTO fixtures (id, name, type, room_id) VALUES 
                    (DEFAULT, $1, $2, (SELECT id FROM rooms WHERE (rooms.name = $3 AND rooms.zone_id = 
                    (SELECT id from zones WHERE (type = $4 AND office_id = (SELECT id from offices WHERE title = $5 
                    ORDER BY offices ASC LIMIT 1)) ORDER BY zones ASC LIMIT 1)) ORDER BY rooms ASC LIMIT 1));",
                    [row["Fixture"], row["Fixture Type"], row["Room"], row["Zone"], row["Office"]])
            }
            parsed.each { |row|
                CONN.exec_params("INSERT INTO materials (id, name, type, cost, fixture_id) VALUES 
                    (DEFAULT, $1, $2, $3, (SELECT id FROM fixtures WHERE name = $4 AND room_id = 
                    (SELECT id FROM rooms WHERE ( rooms.name = $5 AND rooms.zone_id = 
                    (SELECT id from zones WHERE (type = $6 AND office_id = (SELECT id from offices WHERE title = $7 
                    ORDER BY offices ASC LIMIT 1)) ORDER BY zones ASC LIMIT 1)) ORDER BY rooms ASC LIMIT 1) 
                    ORDER BY fixtures ASC LIMIT 1));",
                    [row["Marketing material"], row["Marketing material type"], row["Marketing material cost"], 
                    row["Fixture"], row["Room"], row["Zone"], row["Office"]])
            }
            [200, { 'Content-Type' => 'text/html' }, [ERB.new(File.read('views/home.html')).result(binding)]]
        end
    end
end