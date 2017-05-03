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
  erb(:admin)
end

post('/add_train') do
  identifier = params[:identifier]
  driver = params[:driver]
  num_cars = params[:num_cars]
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

get('/cities/:id') do
  @city = City.find(params[:id].to_i())
  erb(:city)
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
