require("rspec")
require("pg")
require("pry")
require("train")
require("city")

DB = PG.connect({:dbname => "trains_test"})

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM trains *;")
    DB.exec("DELETE FROM stops *;")
    DB.exec("DELETE FROM cities *;")
  end
end

# trains
# ID
# identifier
# driver
# num_cars
#
# stops
# ID
# train_id
# city_id
# train_arrival
#
# cities
# ID
# name
