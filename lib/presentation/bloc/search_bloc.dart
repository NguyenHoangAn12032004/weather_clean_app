import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/usecases/search_cities_usecase.dart';
import 'search_event.dart';
import 'search_state.dart';

@injectable
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchCitiesUseCase _searchCitiesUseCase;

  SearchBloc(this._searchCitiesUseCase) : super(SearchInitial()) {
    on<SearchQueryChanged>(_onSearchQueryChanged, transformer: _debounce(const Duration(milliseconds: 300)));
  }

  EventTransformer<T> _debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(SearchInitial());
      return;
    }
    
    emit(SearchLoading());
    final result = await _searchCitiesUseCase(event.query);
    result.fold(
      (failure) => emit(SearchError(failure.message)),
      (cities) => emit(SearchLoaded(cities)),
    );
  }
}
