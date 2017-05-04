require('sinatra')
require('sinatra/reloader')
require('./lib/train')
require('./lib/city')
require('pry')
require('pg')
also_reload('lib/**/*.rb')

DB = PG.connect({:dbname => "trains"})

get('/') do
  @cities = City.all()
  @trains = Train.all()
  erb(:index)
end

get('/admin') do
  @cities = City.all()
  @trains = Train.all()
  erb(:admin)
end

post('/add_train') do
  identifier = params[:identifier]
  driver = params[:driver]
  num_cars = params[:num_cars].to_i()
  new_train = Train.new({:identifier => identifier, :driver => driver, :num_cars => num_cars})
  new_train.save()
  @cities = City.all()
  @trains = Train.all()
  erb(:admin)
end

post('/add_city') do
  name = params[:name]
  new_city = City.new({:name => name})
  new_city.save()
  @cities = City.all()
  @trains = Train.all()
  erb(:admin)
end

get('/cities/admin/:id') do
  @city = City.find(params[:id].to_i())
  @trains = Train.all()
  erb(:city)
end

get('/cities/:id') do
  @city = City.find(params[:id].to_i())
  @trains = Train.all()
  erb(:city_user)
end

patch('/cities/admin/:id') do
  @city = City.find(params[:id].to_i())
  if params[:name] != ""
    name = params[:name]
    @city.update({:name => name})
  end
  if params["train_ids"] != nil
    train_ids = params["train_ids"]
    @city.update({:train_ids => train_ids})
  end
  @trains = Train.all()
  erb(:city)
end

delete('/cities/admin/:id') do
  @city = City.find(params[:id].to_i())
  @city.delete()
  @cities = City.all()
  @trains = Train.all()
  erb(:admin)
end

get('/trains/admin/:id') do
  @train = Train.find(params[:id].to_i())
  @cities = City.all()
  erb(:train)
end

get('/trains/:id') do
  @train = Train.find(params[:id].to_i())
  @cities = City.all()
  erb(:train_user)
end

patch('/trains/admin/:id') do
  @train = Train.find(params[:id].to_i())
  # key_array = ["driver", "num_cars", "identifier"]
  # params.each() do |key, value|
  #   if key_array.include?(params[key])
  #     train.update({key => value})
  #   end
  # end
  if params[:identifier] != ''
    identifier = params[:identifier]
    @train.update({:identifier => identifier})
  end
  if params[:driver] != ''
    driver = params[:driver]
    @train.update({:driver => driver})
  end
  if params[:num_cars] != ''
    num_cars = params[:num_cars]
    @train.update({:num_cars => num_cars})
  end
  if params["city_ids"] != nil
    city_ids = params["city_ids"]
    arrival = params["train_arrival"]
    @train.update({:city_ids => city_ids, :train_arrival => arrival})
  end
  @train = Train.find(params[:id].to_i())
  @cities = City.all()
  erb(:train)
end

delete('/trains/admin/:id') do
  @train = Train.find(params[:id].to_i())
  @train.delete()
  @trains = Train.all()
  @cities = City.all()
  erb(:admin)
end

post('/clear_all') do
  clear_all()
  @trains = Train.all()
  @cities = City.all()
  erb(:admin)
end

def clear_all
  DB.exec("DELETE FROM trains *;")
  DB.exec("DELETE FROM stops *;")
  DB.exec("DELETE FROM cities *;")
end
