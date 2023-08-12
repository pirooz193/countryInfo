

import 'package:counries_info/common/http_client.dart';
import 'package:counries_info/data/CountryEntity.dart';
import 'package:counries_info/data/source/countryDataSource.dart';

final countryRepository = CountryRepository(CountryRemoteDataSource(httpClient));

abstract class ICountryRepository  { 
  Future<List<CountryEntity>> getCountries();
}

class CountryRepository implements ICountryRepository {

final ICountryDataSource dataSource ;

  CountryRepository(this.dataSource); 

  @override
  Future<List<CountryEntity>> getCountries({String searchKeyword = ''}) async{
   return dataSource.getCountries(searchKeyword: searchKeyword);
  }

}