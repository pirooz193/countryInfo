part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final List<CountryEntity> countries;
  final List<String>? lastSearches ;

  HomeSuccess(this.countries, this.lastSearches);
}

class HomeError extends HomeState {
  final AppException exception;

  HomeError({required this.exception});
}
