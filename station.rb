require_relative 'modules/instance_counter.rb'

class Station

  attr_reader :name, :trains


  @@stations = []

  def self.all
    @@stations
  end

  def initialize(name)
    @name = name
    @trains = []
  end


  def add_train(train)
    trains << train unless trains.include?(train)
  end

  def send_train(train)
    trains.delete(train) if trains.include?(train)
  end

  def cargo_trains
    trains_list(CargoTrain)
  end

  def passenger_trains
    trains_list(PassengerTrain)
  end


  def trains_list(target)
    trains.select{ |train| puts "Train: #{train.number}" if train.class == target}
  end
end
