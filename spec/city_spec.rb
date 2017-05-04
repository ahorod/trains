require('spec_helper')

describe(City) do

  describe('.all') do
    it('is empty at start') do
      expect(City.all()).to eq([])
    end
  end

  describe('#save') do
    it('saves a city to the database and is returned in .all') do
      new_city = City.new(:name => "Cherrytown", :id => nil)
      new_city.save()
      expect(City.all()).to eq([new_city])
    end
  end

  describe('#==') do
    it('changes == to compare using identifier()') do
      new_city = City.new(:name => "NY", :id => nil)
      new_city2 = City.new(:name => "NY", :id => nil)
      expect(new_city == new_city2).to eq(true)
    end
  end

  describe('.find') do
    it('returns city  using id') do
      new_city = City.new(:name => "NY", :id => nil)
      new_city.save()
      new_city1 = City.new(:name => "NY", :id => nil)
      new_city1.save()
      expect(City.find(new_city1.id())).to eq(new_city1)
    end
  end

  describe('#update') do
    it('changes existing city in the database') do
      new_city = City.new(:name => "NY", :id => nil)
      new_city.save()
      new_city.update({:name => "Paris"})
      expect(new_city.name()).to eq("Paris")
    end
    it('lets you add a train(s) to a city') do
      new_city = City.new(:name => "NY", :id => nil)
      new_city.save()
      new_train = Train.new(:identifier => "GT99", :driver => "Brad", :num_cars => 2, :id => nil)
      new_train.save()
      new_train1 = Train.new(:identifier => "ZZ99", :driver => "Rose", :num_cars => 3, :id => nil)
      new_train1.save()
      new_city.update({:train_ids => [new_train.id(), new_train1.id()]})
      expect(new_city.trains()).to eq([new_train, new_train1])
    end
  end

  describe('#delete') do
    it('delete a city from the database') do
      new_city = City.new(:name => "NY", :id => nil)
      new_city.save()
      new_city1 = City.new(:name => "NJ", :id => nil)
      new_city1.save()
      new_city1.delete()
      expect(City.all()).to eq([new_city])
    end
  end


end
