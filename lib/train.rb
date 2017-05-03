class Train
  attr_accessor(:identifier, :driver, :num_cars)
  attr_reader(:id)

  def initialize(attributes)
    @identifier = attributes[:identifier]
    @driver = attributes[:driver]
    @num_cars = attributes[:num_cars]
    @id = attributes[:id]
  end

  def self.all
    all_trains = DB.exec('SELECT * FROM trains')
    saved_trains = []
    all_trains.each() do |train|
      identifier = train['identifier']
      driver = train['driver']
      num_cars = train['num_cars'].to_i()
      id = train['id'].to_i()
      each_train = Train.new({:identifier => identifier, :driver => driver, :num_cars => num_cars, :id => id})
      saved_trains.push(each_train)
    end
    return saved_trains
  end

  def save
    result = DB.exec("INSERT INTO trains (identifier, driver, num_cars) VALUES ('#{@identifier}', '#{@driver}', '#{@num_cars}') RETURNING id;")
    @id = result.first()['id'].to_i()
  end

  def ==(another_train)
    return self.identifier() == another_train.identifier()
  end

  def self.find(id)
    found_train = nil
    Train.all().each() do |train|
      if train.id() == id
        found_train = train
      end
    end
    return found_train
  end

  def update(attributes)
    @id = self.id()
    attributes.each() do |key, value|
      if value != nil
        # instance_variable_set("@#{key}", value)
        DB.exec("UPDATE trains SET #{key.to_s()} = '#{value}' WHERE id = #{@id};")
      end
    end
    # if attributes[:identifier] != nil
    #   @identifier = attributes[:identifier]
    #   DB.exec("UPDATE trains SET identifier = '#{@identifier}' WHERE id = #{@id};")
    # end
    # if attributes[:driver] != nil
    #   @driver = attributes[:driver]
    #   DB.exec("UPDATE trains SET driver = '#{@driver}' WHERE id = #{@id};")
    # end
    # if attributes[:num_cars].to_i() != nil
    #   @num_cars = attributes[:num_cars].to_i()
    #   DB.exec("UPDATE trains SET num_cars = '#{@num_cars}' WHERE id = #{@id};")
    # end
  end

  def delete
    @id = self.id()
    DB.exec("DELETE FROM trains WHERE id = #{@id}")
  end

end
