class Train
  attr_reader :number, :carriages, :route
  attr_accessor :speed

  def initialize(number)
    @speed = 0
    @number = number
    @carriages = []
    @route = route
  end

  def speed_control(value)
    @speed = @speed + value
    @speed = 0 if @speed < 0
  end

  def stop
    @speed = 0
  end

  def add_carriage(carriage)
    stop
    carriages << carriage
  end

  def delete_carriage
    if carriages.size > 0
      stop
      carriages.delete(carriages.last)
    else
      p "Number of carriges is 0!"
    end
  end

  def add_route=(route)
    @route = route
    @route.start.add_train(self)
  end

  def current_station
    current_route.find { |station| station.trains.include?(self) }
  end

  def next_station
    route.stations[index_for(current_station) + 1]
  end

  def previous_station
    if current_station > 0
      route.stations[index_for(current_station) - 1]
    end
  end

  def go_next_station
    return unless @route
    return unless next_station
    current_station.send_train(self)
    index_for(previous_station) + 1
    current_station.add_train(self)
  end

  def go_previous_station
    return unless @route
    return unless previous_station
    current_station.send_train(self)
    index_for(next_station) - 1
    current_station.add_train(self)
  end

  def current_route
    @route.stations
  end

  def index_for(station)
    current_route.index(station)
  end
end



