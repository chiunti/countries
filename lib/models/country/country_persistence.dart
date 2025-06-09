import 'package:countries/core/persistence.dart';

class CountryPersistence {
  static const String _savedCountriesKey = 'saved_countries';

  // Save a country to local storage
  static Future<void> saveCountry(String name) async {
    final savedCountries =
        await Persistence().get(_savedCountriesKey) as List<dynamic>? ?? [];
    if (!savedCountries.contains(name)) {
      savedCountries.add(name);
    }
    await Persistence().save(_savedCountriesKey, savedCountries);
  }

  // Remove a country from local storage
  static Future<void> removeCountry(String name) async {
    final savedCountries =
        await Persistence().get(_savedCountriesKey) as List<dynamic>? ?? [];
    savedCountries.remove(name);
    await Persistence().save(_savedCountriesKey, savedCountries);
  }

  // get if country is saved
  static Future<bool> isSaved(String name) async {
    final savedCountries =
        await Persistence().get(_savedCountriesKey) as List<dynamic>? ?? [];
    return savedCountries.contains(name);
  }
}
