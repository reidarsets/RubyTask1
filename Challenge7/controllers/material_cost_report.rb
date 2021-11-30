require 'pg'
require 'erb'
require './DB/connect_db'

class MaterialCostReport
def call(env)
    @result = {}
    @material_summ = {}
    CONN.exec('SELECT DISTINCT * FROM offices;').each do |office|
      @result[office['title']] = CONN.exec_params('SELECT materials.type, materials.cost 
          FROM materials 
          INNER JOIN fixtures ON materials.fixture_id = fixtures.id
          INNER JOIN rooms ON fixtures.room_id = rooms.id
          INNER JOIN zones ON rooms.zone_id = zones.id
          INNER JOIN offices ON zones.office_id = offices.id
          WHERE offices.id = $1;', [office['id']])
      total_material = {}
      @result[office['title']].each do |materials|
        if total_material[materials['type']]
          total_material[materials['type']] += materials['cost'].to_i
        else
          total_material[materials['type']] = materials['cost'].to_i
        end
      end
      @material_summ[office['title']] = total_material.values.reduce(:+)
      @result[office['title']] = total_material
    end
    return [200, { 'Content-Type' => 'text/html' }, [ERB.new(File.read('views/material_cost_report.erb')).result(binding)]]
  end
end
