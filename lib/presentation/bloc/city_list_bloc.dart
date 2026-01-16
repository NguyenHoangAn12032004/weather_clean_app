import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/get_saved_cities_usecase.dart';
import '../../domain/usecases/add_city_usecase.dart';
import '../../domain/usecases/remove_city_usecase.dart';
import 'city_list_event.dart';
import 'city_list_state.dart';

@injectable
class CityListBloc extends Bloc<CityListEvent, CityListState> {
  final GetSavedCitiesUseCase _getSavedCitiesUseCase;
  final AddCityUseCase _addCityUseCase;
  final RemoveCityUseCase _removeCityUseCase;

  CityListBloc(
    this._getSavedCitiesUseCase,
    this._addCityUseCase,
    this._removeCityUseCase,
  ) : super(CityListInitial()) {
    on<LoadCities>(_onLoadCities);
    on<AddCity>(_onAddCity);
    on<RemoveCity>(_onRemoveCity);
  }

  Future<void> _onLoadCities(LoadCities event, Emitter<CityListState> emit) async {
    emit(CityListLoading());
    final result = await _getSavedCitiesUseCase();
    result.fold(
      (failure) => emit(CityListError(failure.message)),
      (cities) => emit(CityListLoaded(cities)),
    );
  }

  Future<void> _onAddCity(AddCity event, Emitter<CityListState> emit) async {
    await _addCityUseCase(event.city);
    add(LoadCities());
  }

  Future<void> _onRemoveCity(RemoveCity event, Emitter<CityListState> emit) async {
    await _removeCityUseCase(event.city);
    add(LoadCities());
  }
}
