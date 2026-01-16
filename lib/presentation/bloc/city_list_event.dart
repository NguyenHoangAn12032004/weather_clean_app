import 'package:equatable/equatable.dart';

abstract class CityListEvent extends Equatable {
  const CityListEvent();

  @override
  List<Object> get props => [];
}

class LoadCities extends CityListEvent {}

class AddCity extends CityListEvent {
  final String city;
  const AddCity(this.city);

  @override
  List<Object> get props => [city];
}

class RemoveCity extends CityListEvent {
  final String city;
  const RemoveCity(this.city);

  @override
  List<Object> get props => [city];
}
