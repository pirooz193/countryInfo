class CountryEntity {
  final Map<String, dynamic>? name;
  final List<String>? tld;
  final String? cca2;
  final String? ccn3;
  final String? cca3;
  final String? cioc;
  final bool independent;
  final String? status;
  final bool? unMember;
  final Map<String, dynamic>? currencies;
  final Map<String, dynamic> ?idd;
  final List<String>? capital;
  final List<String>? altSpellings;
  final String? region;
  final String? subregion;
  final Map<String, dynamic>? languages;
  final Map<String, dynamic>? translations;
  final List<double>? latlng;
  final bool? landlocked;
  final List<String>? borders;
  final double? area;
  final Map<String, dynamic>? demonyms;
  final String? flag;
  final Map<String, dynamic>? maps;
  final int? population;
  final Map<String, dynamic>? gini;
  final String? fifa;
  final Map<String, dynamic>? car;
  final List<String>? timezones;
  final List<String>? continents;
  final Map<String, dynamic>? flags;
  final Map<String, dynamic>? coatOfArms;
  final String? startOfWeek;
  final Map<String, dynamic>? capitalInfo;
  final Map<String, dynamic>? postalCode;

  CountryEntity({
     this.name,
     this.tld,
     this.cca2,
     this.ccn3,
     this.cca3,
     this.cioc,
     required this.independent,
     this.status,
     this.unMember,
     this.currencies,
     this.idd,
     this.capital,
     this.altSpellings,
     this.region,
     this.subregion,
     this.languages,
     this.translations,
     this.latlng,
     this.landlocked,
     this.borders,
     this.area,
     this.demonyms,
     this.flag,
     this.maps,
     this.population,
     this.gini,
     this.fifa,
     this.car,
     this.timezones,
     this.continents,
     this.flags,
     this.coatOfArms,
     this.startOfWeek,
     this.capitalInfo,
     this.postalCode,
  });

  factory CountryEntity.fromJson(Map<String, dynamic> json) {
    return CountryEntity(
      name: json['name'],
      tld: List<String>.from(json['tld'] ?? ['noting']),
      cca2: json['cca2'],
      ccn3: json['ccn3'],
      cca3: json['cca3'],
      cioc: json['cioc'],
      independent: json['independent'] ?? false,
      status: json['status'],
      unMember: json['unMember'],
      currencies: json['currencies'],
      idd: json['idd'],
      capital: List<String>.from(json['capital'] ?? []),
      altSpellings: List<String>.from(json['altSpellings']),
      region: json['region'],
      subregion: json['subregion'],
      languages: json['languages'],
      translations: json['translations'],
      latlng: List<double>.from(json['latlng']),
      landlocked: json['landlocked'],
      borders: List<String>.from(json['borders'] ?? []),
      area: json['area'],
      demonyms: json['demonyms'],
      flag: json['flag'],
      maps: json['maps'],
      population: json['population'],
      gini: json['gini'] ?? <String, dynamic>{},
      fifa: json['fifa'],
      car: json['car'],
      timezones: List<String>.from(json['timezones']),
      continents: List<String>.from(json['continents']),
      flags: json['flags'],
      coatOfArms: json['coatOfArms'],
      startOfWeek: json['startOfWeek'],
      capitalInfo: json['capitalInfo'],
      postalCode: json['postalCode'],
    );
  }
}
