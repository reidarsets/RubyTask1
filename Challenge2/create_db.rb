require 'pg'

con = PG.connect(dbname: 'task1', user: 'ruby', password: 'pass')

con.exec (
  'CREATE TABLE IF NOT EXISTS offices (
    "id" SERIAL PRIMARY KEY,
    "title" varchar NOT NULL,
    "address" varchar NOT NULL,
    "city" varchar NOT NULL,
    "state" varchar NOT NULL,
    "phone" varchar NOT NULL,
    "lob" varchar NOT NULL,
    "type" varchar NOT NULL
  );'
)

con.exec(
  'CREATE TABLE IF NOT EXISTS "zones" (
    "id" SERIAL PRIMARY KEY,
    "type" varchar NOT NULL,
    "office_id" int NOT NULL REFERENCES "offices" ("id")
  );'
)

con.exec(
  'CREATE TABLE IF NOT EXISTS "rooms" (
    "id" SERIAL PRIMARY KEY,
    "name" varchar NOT NULL,
    "area" int NOT NULL,
    "max_people" int NOT NULL,
    "zone_id" int NOT NULL REFERENCES "zones" ("id")
  );'
)

con.exec(
  'CREATE TABLE IF NOT EXISTS "fixtures" (
    "id" SERIAL PRIMARY KEY,
    "name" varchar NOT NULL,
    "type" varchar NOT NULL,
    "room_id" int NOT NULL REFERENCES "rooms" ("id")
  );'
)

con.exec(
  'CREATE TABLE IF NOT EXISTS "materials" (
    "id" SERIAL PRIMARY KEY,
    "name" varchar NOT NULL,
    "type" varchar NOT NULL,
    "cost" int NOT NULL,
    "fixture_id" int NOT NULL REFERENCES "fixtures" ("id")
  );'
)
