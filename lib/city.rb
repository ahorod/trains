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

  def update(attributes)
    @name = attributes[:name]
    @id = self.id()
    DB.exec("UPDATE cities SET name = '#{@name}' WHERE id = #{@id};")
  end

  def delete
    @id = self.id()
    DB.exec("DELETE FROM cities WHERE id = #{@id}")
  end

end
