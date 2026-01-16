import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_clean_app/core/error/failures.dart';
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

  const tCities = ['London', 'Paris'];
  const tCity = 'London';

  group('LoadCities', () {
    blocTest<CityListBloc, CityListState>(
      'emits [CityListLoading, CityListLoaded] when successful',
      build: () {
        when(() => mockGetSavedCitiesUseCase()).thenAnswer((_) async => const Right(tCities));
        return cityListBloc;
      },
      act: (bloc) => bloc.add(LoadCities()),
      expect: () => [
        CityListLoading(),
        CityListLoaded(tCities),
      ],
    );

    blocTest<CityListBloc, CityListState>(
      'emits [CityListLoading, CityListError] when failure',
      build: () {
        when(() => mockGetSavedCitiesUseCase()).thenAnswer((_) async => const Left(CacheFailure('Cache Error')));
        return cityListBloc;
      },
      act: (bloc) => bloc.add(LoadCities()),
      expect: () => [
        CityListLoading(),
        const CityListError('Cache Error'),
      ],
    );
  });

  group('AddCity', () {
    blocTest<CityListBloc, CityListState>(
      'calls AddCityUseCase and reloads cities',
      build: () {
        when(() => mockAddCityUseCase(any())).thenAnswer((_) async => const Right(null));
        when(() => mockGetSavedCitiesUseCase()).thenAnswer((_) async => const Right(tCities));
        return cityListBloc;
      },
      act: (bloc) => bloc.add(const AddCity(tCity)),
      expect: () => [
        CityListLoading(),
        CityListLoaded(tCities),
      ],
      verify: (_) {
        verify(() => mockAddCityUseCase(tCity)).called(1);
        verify(() => mockGetSavedCitiesUseCase()).called(1);
      },
    );
  });

  group('RemoveCity', () {
    blocTest<CityListBloc, CityListState>(
      'calls RemoveCityUseCase and reloads cities',
      build: () {
        when(() => mockRemoveCityUseCase(any())).thenAnswer((_) async => const Right(null));
        when(() => mockGetSavedCitiesUseCase()).thenAnswer((_) async => const Right(tCities));
        return cityListBloc;
      },
      act: (bloc) => bloc.add(const RemoveCity(tCity)),
      expect: () => [
        CityListLoading(),
        CityListLoaded(tCities),
      ],
      verify: (_) {
        verify(() => mockRemoveCityUseCase(tCity)).called(1);
        verify(() => mockGetSavedCitiesUseCase()).called(1);
      },
    );
  });
}
