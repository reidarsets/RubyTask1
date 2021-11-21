require 'pg'

con = PG.connect(dbname: 'task1', user: 'ruby', password: 'pass')

con.exec(
    'DROP TABLE IF EXISTS offices CASCADE;
    DROP TABLE IF EXISTS zones CASCADE;
    DROP TABLE IF EXISTS rooms CASCADE;
    DROP TABLE IF EXISTS fixtures CASCADE;
    DROP TABLE IF EXISTS materials;'
)
