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
    final response = await httpClient.get('all');
    validateResponse(response);
    final countries = <CountryEntity>[];
    (response.data as List).forEach((element) {
      countries.add(CountryEntity.fromJson(element));
    });

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
