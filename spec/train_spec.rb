require('spec_helper')

describe(Train) do

  describe('.all') do
    it('is empty at start') do
      expect(Train.all()).to eq([])
    end
  end

  describe('#save') do
    it('saves a train to the database and is returned in .all') do
      new_train = Train.new(:identifier => "GT99", :driver => "Brad", :num_cars => 2, :id => nil)
      new_train.save()
      expect(Train.all()).to eq([new_train])
    end
  end

  describe('#==') do
    it('changes == to compare using identifier()') do
      new_train = Train.new(:identifier => "GT99", :driver => "Brad", :num_cars => 2, :id => nil)
      new_train2 = Train.new(:identifier => "GT99", :driver => "Brad", :num_cars => 2, :id => nil)
      expect(new_train == new_train2).to eq(true)
    end
  end

  describe('.find') do
    it('returns object using id') do
      new_train = Train.new(:identifier => "GT99", :driver => "Brad", :num_cars => 2, :id => nil)
      new_train.save()
      new_train1 = Train.new(:identifier => "GT99", :driver => "Brad", :num_cars => 2, :id => nil)
      new_train1.save()
      expect(Train.find(new_train1.id())).to eq(new_train1)
    end
  end

  describe('#update') do
    it('changes existing train object in the database') do
      new_train = Train.new(:identifier => "GT99", :driver => "Brad", :num_cars => 2, :id => nil)
      new_train.save()
      new_train.update({:num_cars => 3})
      expect(new_train.num_cars()).to eq(3)
      expect(new_train.driver()).to eq("Brad")
      new_train.update({:driver => "Jeff"})
      expect(new_train.driver()).to eq("Jeff")
      new_train.update({:identifier => "ZX44"})
      expect(new_train.identifier()).to eq("ZX44")
    end
    it('lets you add a city(ies) to a train') do
      new_train = Train.new(:identifier => "GT99", :driver => "Brad", :num_cars => 2, :id => nil)
      new_train.save()
      new_city = City.new(:name => "NY", :id => nil)
      new_city.save()
      new_train.update({:city_ids => [new_city.id()]})
      expect(new_train.cities()).to eq([new_city])
    end
  end

  describe('#delete') do
    it('delete a train from the database') do
      new_train = Train.new(:identifier => "GT99", :driver => "Brad", :num_cars => 2, :id => nil)
      new_train.save()
      new_train1 = Train.new(:identifier => "GT99", :driver => "Brad", :num_cars => 2, :id => nil)
      new_train1.save()
      new_train1.delete()
      expect(Train.all()).to eq([new_train])
    end
  end

end
