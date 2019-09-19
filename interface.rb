class Main

  attr_reader :stations, :trains, :routes

  def initialize
    @stations = []
    @trains = []
    @routes = []
  end

  def clear_screen
    if RUBY_PLATFORM =~ /win32|win64|\.NET|windows|cygwin|mingw32/i
    system('cls')
    else
    system('clear')
    end
  end

  def execute
    clear_screen
    menu
    loop do

      case gets.chomp.to_i
      when 0
        puts 'Exit...'
        break

      when 1
        station_menu
        break

      when 2
        route_menu
        break

      when 3
        train_menu
        break

      end
    end
  end

  def execute_stations_menu
    loop do

      case gets.chomp.to_i
      when 0
        execute
        break

      when 1
        create_station

      when 2
        view_stations

      when 3
        view_trains_on_stations

      end
    end
  end

  def execute_train_menu
    loop do

      case gets.chomp.to_i
      when 0
        execute
        break

      when 1
        create_train

      when 2
        add_train_on_route

      when 3
        add_carriage_to_train

      when 4
        delete_carriage_to_train

      when 5
        move_train_direction

      end
    end
  end

  def execute_route_menu
    loop do

      case gets.chomp.to_i
      when 0
        execute
        break

      when 1
        create_route

      when 2
        add_stations_route

      when 3
        remove_stations_route
      end
    end
  end

  def menu
    puts %Q(
    ┌───────────────────────────────────┐
    │ 1.Station menu                    │
    │ 2.Route menu                      │
    │ 3.Train menu                      │
    │                                   │
    │ 0.Exit                            │
    └───────────────────────────────────┘
    )
  end

  def station_menu
    puts %Q(
    ┌───────────────────────────────────┐
    │ 1.Create station                  │
    │ 2.View stations                   │
    │ 3.View trains on stations         │
    │                                   │
    │ 0.Exit                            │
    └───────────────────────────────────┘
    )
    execute_stations_menu
  end

  def train_menu
    puts %Q(
    ┌───────────────────────────────────┐
    │ 1.Create train                    │
    │ 2.Assign train to the route       │
    │ 3.Add carriage to the train       │
    │ 4.Remove carriage to the train    │
    │ 5.Move train on route             │
    │                                   │
    │ 0.Exit                            │
    └───────────────────────────────────┘
    )
    execute_train_menu
  end

  def route_menu
    puts %Q(
    ┌──────────────────────────────────────────┐
    │ 1.Create route                           │
    │ 2.Add station to the route               │
    │ 3.Delete station on the route            │
    │                                          │
    │ 0.Exit                                   │
    └──────────────────────────────────────────┘
    )
    execute_route_menu
  end

#функции для станций
  def create_station
    puts "Enter station name: "
    name = gets.chomp
    if stations.any? { |station| station.name == name }
      puts "This station already exist."
      return
    end
    new_station = Station.new(name)
    stations << new_station
    puts "You created a station: #{new_station.name}"
  end


  def view_stations
    @stations.each_with_index { |station, i | puts "#{i + 1}. Station: \"#{station.name}\"" }

  end

def view_trains_on_stations
validates_stations!

  stations.each_with_index { |station, i | puts "#{i + 1}. #{station.name}" }
  puts "Enter station number if you want to see trains list."

  current_station = stations[gets.chomp.to_i - 1]

  station_cargo_trains = current_station.cargo_trains
  station_passenger_trains = current_station.passenger_trains
  station.trains.each_with_index { |train| train}

  station_cargo_trains.each_with_index { |ct, i| print "#{i + 1}. Cargo Train: #{ct.number} \n" } if station_passenger_trains
  station_passenger_trains.each_with_index { |pt, i| print "#{i + 1}. Passenger Train: #{pt.number} \n" } if station_passenger_trains

  puts "There is no trains on station: #{current_station.name}." if station_cargo_trains.empty? && station_passenger_trains.empty?
  end


#функции для поезда
  def create_train
    puts "Enter train number:"
    number = gets.chomp
    puts %Q("Enter type train, where
    1- Passenger,
    2- Cargo")
    case gets.to_i
      when 1 then trains << PassengerTrain.new(number)
        puts "Passenger train number #{number} is created"
      when 2 then trains << CargoTrain.new(number)
        puts "Cargo train number #{number} is created"
      else
        puts "Input error."
      return
    end
  end

def add_carriage_to_train
    train = get_current_train

  if train.type == :cargo
    carriage = CargoCarriage.new(SecureRandom.hex(5))
    train.add_carriage(carriage)
    puts "#{carriage} was added to Train number: #{train.number}"
  else
    carriage = PassengerCarriage.new(SecureRandom.hex(5))
    train.add_carriage(carriage)
    puts "#{carriage} was added to Train number: #{train.number}"
  end
end

def delete_carriage_to_train
  current_train = get_current_train
  current_train.delete_carriage
  puts "Carriage was removed from the Train: #{current_train.number}"
end

def add_train_on_route


  train = get_current_train
  route = get_current_route
  train.add_route(route)

  puts "Train number: \"#{train.number}\" added on Route: \"#{route.start} - #{route.finish}\""
end

def move_train_direction
  train = get_current_train
puts %Q("0 - Exit
1- go prev station
2- go next station")

  loop do

      case gets.chomp.to_i
      when 0
        break
      when 1
         train.go_next_station

      when 2
         train.go_previous_station
      end
    end
  end


#функции для машрута
  def create_route
    puts "Выберите стартовую станцию: "
    start = get_current_station
    puts "Введите финишную станцию: "
    finish = get_current_station
  if routes.any? {|route| route.start == start} &&
    routes.any? {|route| routes.finish == finish}
    puts "This station already exist."
    return
  end
    if start == finish
      puts "error"
      return
  end
    routes << Route.new(start, finish)
    puts "Route #{start} - #{finish} is created"
  end

  def view_route
     routes.each_with_index { |route, i | puts "#{i + 1}. Route: \"#{route.start} - #{route.finish}\"" }
  end

end

def add_stations_route
  validates_routes!
  current_route = get_current_route
  current_station = get_current_station
  current_route.add_station(current_station)
  current_route.mid_stations.each { |station| p "Station: #{station.name} is added on Route: #{current_route.start.name} - #{current_route.finish.name}"}
end

def remove_stations_route
  validates_routes!
  current_route = get_current_route
  current_station = get_current_station
  current_route.remove_station(current_station)
  current_route.mid_stations.each { |station| p "Station: #{station.name} is removing on Route: #{current_route.start.name} - #{current_route.finish.name}"}
end

#выбрать поезд, маршрут, станцию
def get_current_route
  validates_routes!
  routes.each_with_index { |route, i | puts "#{i + 1}. Route: \"#{route.start} - #{route.finish}\"" }
  puts "Enter index route"
  index_route = gets.chomp.to_i - 1
  current_route = routes[index_route]
end

def get_current_station
  stations.each_with_index { |station, i | puts "#{i + 1}. Station: \"#{station.name}\"" }
  puts "Enter index station"
  index_station = gets.chomp.to_i - 1
  current_station = stations[index_station]
end

def get_current_train
  trains.each_with_index { |train, i | puts "#{i + 1}. Number: \"#{train.number}\"" }
  puts "Enter index train"
  index_train = gets.chomp.to_i - 1
  current_train = trains[index_train]
end

#проверки на ошибки
def validates_stations!
  if stations.empty?
      puts('Create at least 1 station')
      Time.new
      sleep 1.2
    execute
  end
end

def validates_stations_size!
  if stations.size < 2
    puts('Create at least 2 stations')
    Time.new
    sleep 1.2
    execute
  end
end

def validates_stations_index!
  if @start == @finish
      puts 'Choose different station!'
      Time.new
    sleep 1.2
    execute
  end
end

def validates_trains!
  if trains.empty?
    puts 'Create at least one Train!'
    Time.new
    sleep 1.2
    execute
  end
end

def validates_routes!
  if routes.empty?
    puts 'ERROR! Create at least one Route!'
    Time.new
    sleep 1.2
    execute
  end
end



main = Main.new
main.execute
