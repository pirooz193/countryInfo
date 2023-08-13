import 'package:bloc/bloc.dart';
import 'package:counries_info/common/exceptions.dart';
import 'package:counries_info/ui/home/home.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/CountryEntity.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(
    countryRepository,
  ) : super(HomeLoading()) {
    on<HomeEvent>((event, emit) async {
      if (event is HomeStarted ||
          event is HomeRefresh ||
          event is HomeScreenCountrySearch ||
          event is ClearSearchHistory) {
        final String searchTerm;
        emit(HomeLoading());
        await Future.delayed(const Duration(seconds: 1));
        if (event is HomeScreenCountrySearch) {
          searchTerm = event.searchTerm;
        } else {
          searchTerm = '';
        }
        if(event is ClearSearchHistory) {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.remove('lastSearches');
          prefs.setStringList('lastSearches', <String>[]);
        }
        try {
          emit(HomeLoading());
          final countries =
              await countryRepository.getCountries(searchKeyword: searchTerm);
          final List<String>? lastSearches = await getLastSearches();

          if (lastSearches != null) {
            for (String search in lastSearches) {
              lastSearche.add(search);
            }
          }
          emit(HomeSuccess(countries, lastSearches));
        } catch (error) {
          emit(HomeError(
              exception: error is AppException ? error : AppException()));
        }
      } 
    });
  }

  Future<List<String>?> getLastSearches() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList("lastSearches") ?? [];
  }
}
