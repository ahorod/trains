class City
  attr_accessor(:name)
  attr_reader(:id)

  def initialize(attributes)
    @name = attributes[:name]
    @id = attributes[:id]
  end

  def self.all
    all_cities = DB.exec('SELECT * FROM cities')
    saved_cities = []
    all_cities.each() do |city|
      name = city['name']
      id = city['id'].to_i()
      each_city = City.new({:name => name, :id => id})
      saved_cities.push(each_city)
    end
    return saved_cities
  end

  def save
    result = DB.exec("INSERT INTO cities (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first()['id'].to_i()
  end

  def ==(another_city)
    return self.name() == another_city.name()
  end

  def self.find(id)
    found_city = nil
    City.all().each() do |city|
      if city.id() == id
        found_city = city
      end
    end
    return found_city
  end

  def trains
    stops = []
    results = DB.exec("SELECT train_id FROM stops WHERE city_id = #{self.id()};")
    results.each() do |result|
      train_id = result["train_id"].to_i()
      train = DB.exec("SELECT * FROM trains WHERE id = #{train_id};")
      identifier = train.first()["identifier"]
      driver = train.first()["driver"]
      num_cars = train.first()["num_cars"]
      stops.push(Train.new({:identifier => identifier, :driver => driver, :num_cars => num_cars, :id => train_id}))
    end
    return stops
  end

  def update(attributes)
    @name = attributes.fetch(:name, @name)
    @id = self.id()
    DB.exec("UPDATE cities SET name = '#{@name}' WHERE id = #{@id};")
    if attributes[:train_ids] != nil
      DB.exec("DELETE FROM stops WHERE city_id = #{@id};")
      attributes.fetch(:train_ids, []).each() do |train_id|
        DB.exec("INSERT INTO stops (train_id, city_id) VALUES (#{train_id}, #{self.id()});")
      end
    end
  end

  def delete
    @id = self.id()
    DB.exec("DELETE FROM cities WHERE id = #{@id};")
    DB.exec("DELETE FROM stops WHERE city_id = #{@id};")
  end

end
