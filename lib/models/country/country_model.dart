// Helper function to decode a list of countries from a JSON string
import 'dart:convert';

List<Country> countryFromJson(String str) => List<Country>.from(
  (json.decode(str) as List<dynamic>).map(
    (x) => Country.fromJson(x as Map<String, dynamic>),
  ),
);

// Helper function to encode a list of countries to a JSON string
String countryToJson(List<Country> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Country {
  final Name name;
  final Currencies? currencies;
  final List<String>? capital;
  final String? region;
  final String? subregion;
  final Languages? languages;
  final int? population;
  final Car? car;
  final List<String>? timezones;
  final String? flagPng;
  final String? coatOfArmsPng;
  bool isBookmarked;

  Country({
    required this.name,
    this.currencies,
    this.capital,
    this.region,
    this.subregion,
    this.languages,
    this.population,
    this.car,
    this.timezones,
    this.flagPng,
    this.coatOfArmsPng,
    this.isBookmarked = false,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    try {
      final Map<String, dynamic>? flagsJson =
          json['flags'] as Map<String, dynamic>?;
      final Map<String, dynamic>? coatOfArmsJson =
          json['coatOfArms'] as Map<String, dynamic>?;

      return Country(
        name: Name.fromJson(json['name'] as Map<String, dynamic>),
        currencies: json['currencies'] != null
            ? Currencies.fromJson(json['currencies'] as Map<String, dynamic>)
            : null,
        capital: (json['capital'] as List<dynamic>?)
            ?.map((e) => e?.toString() ?? '')
            .where((e) => e.isNotEmpty)
            .toList(),
        region: json['region'] as String?,
        subregion: json['subregion'] as String?,
        languages: json['languages'] != null
            ? Languages.fromJson(json['languages'] as Map<String, dynamic>)
            : null,
        population: json['population'] != null
            ? int.tryParse(json['population'].toString())
            : null,
        car: json['car'] != null
            ? Car.fromJson(json['car'] as Map<String, dynamic>)
            : null,
        timezones: (json['timezones'] as List<dynamic>?)
            ?.map((e) => e?.toString() ?? '')
            .where((e) => e.isNotEmpty)
            .toList(),
        flagPng: flagsJson?['png'] as String?,
        coatOfArmsPng: coatOfArmsJson?['png'] as String? ?? '',
        isBookmarked: json['isBookmarked'] as bool? ?? false,
      );
    } catch (e) {
      throw FormatException('Error parsing Country: $e');
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name.toJson();
    if (currencies != null) {
      data['currencies'] = currencies!.toJson();
    }
    data['capital'] = capital;
    data['region'] = region;
    data['subregion'] = subregion;
    if (languages != null) {
      data['languages'] = languages!.toJson();
    }
    data['population'] = population;
    if (car != null) {
      data['car'] = car!.toJson();
    }
    data['timezones'] = timezones;
    if (flagPng != null) {
      data['flags'] = {'png': flagPng};
    }
    if (coatOfArmsPng != null) {
      data['coatOfArms'] = {'png': coatOfArmsPng};
    }
    data['isBookmarked'] = isBookmarked;
    return data;
  }
}

class Name {
  final String common;
  final String official;

  Name({required this.common, required this.official});

  factory Name.fromJson(Map<String, dynamic> json) => Name(
    common: json['common'] as String,
    official: json['official'] as String,
  );

  Map<String, dynamic> toJson() => {'common': common, 'official': official};
}

class Currencies {
  final Map<String, CurrencyDetail> currencyMap;

  Currencies({required this.currencyMap});

  factory Currencies.fromJson(Map<String, dynamic> json) => Currencies(
    currencyMap: json.map(
      (key, value) =>
          MapEntry(key, CurrencyDetail.fromJson(value as Map<String, dynamic>)),
    ),
  );

  Map<String, dynamic> toJson() =>
      currencyMap.map((key, value) => MapEntry(key, value.toJson()));
}

class CurrencyDetail {
  final String symbol;
  final String name;

  CurrencyDetail({required this.symbol, required this.name});

  factory CurrencyDetail.fromJson(Map<String, dynamic> json) => CurrencyDetail(
    symbol: json['symbol'] as String,
    name: json['name'] as String,
  );

  Map<String, dynamic> toJson() => {'symbol': symbol, 'name': name};
}

class Languages {
  final Map<String, String> languageMap;

  Languages({required this.languageMap});

  factory Languages.fromJson(Map<String, dynamic> json) => Languages(
    languageMap: json.map((key, value) => MapEntry(key, value as String)),
  );

  Map<String, dynamic> toJson() =>
      languageMap.map((key, value) => MapEntry(key, value));
}

class Car {
  final List<String> signs;
  final String side;

  Car({required this.signs, required this.side});

  factory Car.fromJson(Map<String, dynamic> json) => Car(
    signs:
        (json['signs'] as List<dynamic>?)
            ?.map((e) => e?.toString() ?? '')
            .where((e) => e.isNotEmpty)
            .toList() ??
        [],
    side: json['side'] as String? ?? '',
  );

  Map<String, dynamic> toJson() => {'signs': signs, 'side': side};
}
