require 'pg'
require 'erb'
require './DB/connect_db'

class MaterialCostReport
def call(env)
    @result = {}
    @material_summ = {}
    CONN.exec('SELECT DISTINCT * FROM offices;').each do |office|
      @result[office['title']] = CONN.exec_params('SELECT materials.type, materials.cost FROM materials WHERE fixture_id IN 
        (SELECT id FROM fixtures WHERE room_id IN 
        (SELECT id FROM rooms WHERE zone_id IN 
        (SELECT DISTINCT id FROM zones WHERE office_id = $1)));', [office['id']])
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
