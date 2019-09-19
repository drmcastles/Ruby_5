class Route
attr_reader :stations, :start, :finish, :mid_stations
  def initialize(start, finish)
    @mid_stations = []
    @stations = []
    @start = start
    @finish = finish
  end

  def add_station(station)
    mid_stations << station
  end

  def remove_station(station)
    mid_stations.delete(station)
  end

  def stations
    [start, mid_stations, finish].flatten
  end
end

