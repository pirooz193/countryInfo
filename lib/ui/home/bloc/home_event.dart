part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class HomeStarted extends HomeEvent {}
class HomeRefresh extends HomeEvent {}
class ClearSearchHistory extends HomeEvent {}
class HomeScreenCountrySearch extends HomeEvent{
  final String searchTerm ;

  HomeScreenCountrySearch(this.searchTerm);
}