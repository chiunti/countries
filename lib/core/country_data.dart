import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Clase para gestionar los datos
class CountryData {
  static const String _baseUrl = 'https://restcountries.com/v3.1';
  static const String _savedCountriesKey = 'saved_countries';

  // Get a single country by name
  static Future<Map<String, dynamic>?> get(String name) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/name/$name'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          // find exact match name
          final country = data.firstWhere(
            (country) => country['name']['common'] == name,
            orElse: () => data.first,
          );
          final saved = await isSaved(country['name']['common']);
          return Map<String, dynamic>.from(country)..['isBookmarked'] = saved;
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error getting country: $e');
      return null;
    }
  }

  // Search for countries by name, partial name, or region
  static Future<List<Map<String, dynamic>>> search(String query) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/name/$query'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final prefs = await SharedPreferences.getInstance();
        final savedCountries = prefs.getStringList(_savedCountriesKey) ?? [];

        return List<Map<String, dynamic>>.from(
          data.map((country) {
            final isSaved = savedCountries.contains(country['name']['common']);
            return Map<String, dynamic>.from(country)
              ..['isBookmarked'] = isSaved;
          }),
        );
      }
      return [];
    } catch (e) {
      debugPrint('Error searching countries: $e');
      return [];
    }
  }

  // Search for Saved countries
  static Future<List<Map<String, dynamic>>> searchSaved(String query) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCountries = prefs.getStringList(_savedCountriesKey) ?? [];
      final response = await http.get(Uri.parse('$_baseUrl/name/$query'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(
          data.where(
            (country) =>
                savedCountries.contains(country['name']['common']) &&
                country['isBookmarked'] == true,
          ),
        );
      }
      return [];
    } catch (e) {
      debugPrint('Error searching saved countries: $e');
      return [];
    }
  }

  // Get list of all countries
  static Future<List<Map<String, dynamic>>> list({String? fields}) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/all?fields=$fields'),
      );
      if (response.statusCode == 200) {
        final list = List<Map<String, dynamic>>.from(
          json.decode(response.body),
        );
        list.sort((a, b) => a['name']['common'].compareTo(b['name']['common']));
        for (var country in list) {
          final saved = await isSaved(country['name']['common']);
          country['isBookmarked'] = saved;
        }
        return list;
      }
      return [];
    } catch (e) {
      debugPrint('Error listing countries: $e');
      return [];
    }
  }

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
      final response = await http.get(
        Uri.parse('$_baseUrl/all?fields=$fields'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<Map<String, dynamic>> list = List<Map<String, dynamic>>.from(
          data.where(
            (country) => savedCountries.contains(country['name']['common']),
          ),
        );
        for (var country in list) {
          final saved = await isSaved(country['name']['common']);
          country['isBookmarked'] = saved;
        }
        return list;
      }
      return [];
    } catch (e) {
      debugPrint('Error getting saved countries: $e');
      return [];
    }
  }
}
