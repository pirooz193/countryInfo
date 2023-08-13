import 'package:counries_info/data/CountryEntity.dart';
import 'package:counries_info/data/common/httpResponseValidator.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ICountryDataSource {
  Future<List<CountryEntity>> getCountries({String searchKeyword = ''});
}

class CountryRemoteDataSource
    with HttpResponseValidator
    implements ICountryDataSource {
  final Dio httpClient;

  CountryRemoteDataSource(this.httpClient);

  @override
  Future<List<CountryEntity>> getCountries({String searchKeyword = ''}) async {
    int cntr = 0 ;
    final response = await httpClient.get('all');
    validateResponse(response);
    final countries = <CountryEntity>[];
    for (var element in (response.data as List)) {
      final country = CountryEntity.fromJson(element);
      countries.add(country);
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (searchKeyword.isNotEmpty) {
      final latestSearches = prefs.getStringList("lastSearches") ?? [];
      latestSearches.add(searchKeyword);
      await prefs.setStringList('lastSearches', latestSearches);

      String searchKeywordLowerCase = searchKeyword.toLowerCase();
      return countries
          .where((element) =>
              element.translations!['per']
                  .toString()
                  .toLowerCase()
                  .contains(searchKeywordLowerCase) ||
              element.name!['common']
                  .toLowerCase()
                  .contains(searchKeywordLowerCase) ||
              element.tld!
                  .toString()
                  .toLowerCase()
                  .contains(searchKeywordLowerCase))
          .toList();
    } else {
      return countries;
    }
  }
}
