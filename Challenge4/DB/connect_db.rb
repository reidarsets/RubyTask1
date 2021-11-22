require 'pg'

CONN = PG.connect(dbname: 'task1', user: 'ruby', password: 'pass')
