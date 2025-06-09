import 'package:countries/models/country/country_persistence.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:countries/models/country/country_model.dart';

/// Clase para gestionar los datos
class CountryService {
  static const String _baseUrl = 'https://restcountries.com/v3.1';

  // Get a single country by name
  static Future<Country?> get(String name) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/name/$name'));
      if (response.statusCode == 200) {
        List<Country> countries = countryFromJson(response.body);
        for (var country in countries) {
          final bool saved = await CountryPersistence.isSaved(
            country.name.common,
          );
          country.isBookmarked = saved;
        }
        countries.sort((a, b) => a.name.common.compareTo(b.name.common));
        return countries.first;
      }
      return null;
    } catch (e) {
      debugPrint('Error getting country: $e');
      return null;
    }
  }

  // Search for countries by name, partial name, or region
  static Future<List<Country>> search(String query) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/name/$query'));
      if (response.statusCode == 200) {
        List<Country> countries = countryFromJson(response.body);
        for (var country in countries) {
          final bool saved = await CountryPersistence.isSaved(
            country.name.common,
          );
          country.isBookmarked = saved;
        }
        countries.sort((a, b) => a.name.common.compareTo(b.name.common));
        return countries;
      }
      return [];
    } catch (e) {
      debugPrint('Error searching countries: $e');
      return [];
    }
  }

  // Search for Saved countries
  static Future<List<Country>> searchSaved(String query) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/name/$query'));
      if (response.statusCode == 200) {
        List<Country> countries = countryFromJson(response.body);
        for (var country in countries) {
          final bool saved = await CountryPersistence.isSaved(
            country.name.common,
          );
          country.isBookmarked = saved;
        }
        countries.sort((a, b) => a.name.common.compareTo(b.name.common));
        return countries.where((country) => country.isBookmarked).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error searching saved countries: $e');
      return [];
    }
  }

  // Get list of all countries
  static Future<List<Country>> list({String? fields}) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/all?fields=$fields'),
      );
      if (response.statusCode == 200) {
        List<Country> countries = countryFromJson(response.body);
        for (var country in countries) {
          final bool saved = await CountryPersistence.isSaved(
            country.name.common,
          );
          country.isBookmarked = saved;
        }
        countries.sort((a, b) => a.name.common.compareTo(b.name.common));
        return countries;
      }
      return [];
    } catch (e) {
      debugPrint('Error listing countries: $e');
      return [];
    }
  }

  static Future<List<Country>> saved({String? fields}) async {
    try {
      final listSaved = await CountryService.list(fields: fields);
      return listSaved.where((country) => country.isBookmarked).toList();
    } catch (e) {
      debugPrint('Error listing saved countries: $e');
      return [];
    }
  }
}
