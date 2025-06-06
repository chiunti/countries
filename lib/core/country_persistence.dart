import 'package:countries/core/country_service.dart' show CountryService;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CountryPersistence {
  static const String _savedCountriesKey = 'saved_countries';

  // Save a country to local storage
  static Future<void> saveCountry(String name) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCountries = prefs.getStringList(_savedCountriesKey) ?? [];

      // Add country name to saved list if not already saved
      if (!savedCountries.contains(name)) {
        savedCountries.add(name);
        await prefs.setStringList(_savedCountriesKey, savedCountries);
      }
    } catch (e) {
      debugPrint('Error saving country: $e');
    }
  }

  // Remove a country from local storage
  static Future<void> removeCountry(String name) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCountries = prefs.getStringList(_savedCountriesKey) ?? [];
      savedCountries.remove(name);
      await prefs.setStringList(_savedCountriesKey, savedCountries);
    } catch (e) {
      debugPrint('Error removing country: $e');
    }
  }

  // get if country is saved
  static Future<bool> isSaved(String name) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCountries = prefs.getStringList(_savedCountriesKey) ?? [];
      return savedCountries.contains(name);
    } catch (e) {
      debugPrint('Error checking if country is saved: $e');
      return false;
    }
  }

  // get list of saved countries
  static Future<List<Map<String, dynamic>>> saved({String? fields}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCountries = prefs.getStringList(_savedCountriesKey) ?? [];
      final data = await CountryService.list(fields: fields);
      final list = data
          .where(
            (country) => savedCountries.contains(country['name']['common']),
          )
          .toList();
      for (var country in list) {
        final saved = await isSaved(country['name']['common']);
        country['isBookmarked'] = saved;
      }
      return list;
    } catch (e) {
      debugPrint('Error getting saved countries: $e');
      return [];
    }
  }
}
