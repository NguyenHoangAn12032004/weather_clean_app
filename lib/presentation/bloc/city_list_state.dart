import 'package:equatable/equatable.dart';

abstract class CityListState extends Equatable {
  const CityListState();
  
  @override
  List<Object> get props => [];
}

class CityListInitial extends CityListState {}

class CityListLoading extends CityListState {}

class CityListLoaded extends CityListState {
  final List<String> cities;
  const CityListLoaded(this.cities);

  @override
  List<Object> get props => [cities];
}

class CityListError extends CityListState {
  final String message;
  const CityListError(this.message);

  @override
  List<Object> get props => [message];
}
