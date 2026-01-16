
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_clean_app/domain/usecases/add_city_usecase.dart';
import 'package:weather_clean_app/domain/usecases/get_saved_cities_usecase.dart';
import 'package:weather_clean_app/domain/usecases/remove_city_usecase.dart';
import 'package:weather_clean_app/presentation/bloc/city_list_bloc.dart';
import 'package:weather_clean_app/presentation/bloc/city_list_event.dart';
import 'package:weather_clean_app/presentation/bloc/city_list_state.dart';

class MockGetSavedCitiesUseCase extends Mock implements GetSavedCitiesUseCase {}
class MockAddCityUseCase extends Mock implements AddCityUseCase {}
class MockRemoveCityUseCase extends Mock implements RemoveCityUseCase {}

void main() {
  late CityListBloc cityListBloc;
  late MockGetSavedCitiesUseCase mockGetSavedCitiesUseCase;
  late MockAddCityUseCase mockAddCityUseCase;
  late MockRemoveCityUseCase mockRemoveCityUseCase;

  setUp(() {
    mockGetSavedCitiesUseCase = MockGetSavedCitiesUseCase();
    mockAddCityUseCase = MockAddCityUseCase();
    mockRemoveCityUseCase = MockRemoveCityUseCase();

    cityListBloc = CityListBloc(
      mockGetSavedCitiesUseCase,
      mockAddCityUseCase,
      mockRemoveCityUseCase,
    );
  });

  final tCities = ['Hanoi', 'Ho Chi Minh City'];

  test('initial state should be CityListInitial', () {
    expect(cityListBloc.state, equals(CityListInitial()));
  });

  blocTest<CityListBloc, CityListState>(
    'emits [CityListLoading, CityListLoaded] when LoadCities is added',
    build: () {
      when(() => mockGetSavedCitiesUseCase())
          .thenAnswer((_) async => Right(tCities));
      return cityListBloc;
    },
    act: (bloc) => bloc.add(LoadCities()),
    expect: () => [
      CityListLoading(),
      CityListLoaded(tCities),
    ],
    verify: (_) {
      verify(() => mockGetSavedCitiesUseCase()).called(1);
    },
  );

  blocTest<CityListBloc, CityListState>(
    'emits [CityListLoading, CityListLoaded] after adding a city',
    build: () {
      when(() => mockAddCityUseCase(any()))
          .thenAnswer((_) async => const Right(null));
      when(() => mockGetSavedCitiesUseCase())
          .thenAnswer((_) async => Right(['Hanoi', 'Da Nang'])); // Mock updated list
      return cityListBloc;
    },
    act: (bloc) => bloc.add(const AddCity('Da Nang')),
    expect: () => [
      CityListLoading(),
      const CityListLoaded(['Hanoi', 'Da Nang']),
    ],
    verify: (_) {
      verify(() => mockAddCityUseCase('Da Nang')).called(1);
      verify(() => mockGetSavedCitiesUseCase()).called(1);
    },
  );

  blocTest<CityListBloc, CityListState>(
    'emits [CityListLoading, CityListLoaded] after removing a city',
    build: () {
      when(() => mockRemoveCityUseCase(any()))
          .thenAnswer((_) async => const Right(null));
      when(() => mockGetSavedCitiesUseCase())
          .thenAnswer((_) async => Right(['Hanoi'])); // Mock updated list
      return cityListBloc;
    },
    act: (bloc) => bloc.add(const RemoveCity('Ho Chi Minh City')),
    expect: () => [
      CityListLoading(),
      const CityListLoaded(['Hanoi']),
    ],
    verify: (_) {
      verify(() => mockRemoveCityUseCase('Ho Chi Minh City')).called(1);
      verify(() => mockGetSavedCitiesUseCase()).called(1);
    },
  );
}
