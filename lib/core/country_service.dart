import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:countries/core/country_persistence.dart';

/// Clase para gestionar los datos
class CountryService {
  static const String _baseUrl = 'https://restcountries.com/v3.1';

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
          final saved = await CountryPersistence.isSaved(
            country['name']['common'],
          );
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

        // sort data by name
        data.sort((a, b) => a['name']['common'].compareTo(b['name']['common']));

        return List<Map<String, dynamic>>.from(
          data.map((country) {
            final isSaved = CountryPersistence.isSaved(
              country['name']['common'],
            );
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
      final response = await http.get(Uri.parse('$_baseUrl/name/$query'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        // sort data by name
        data.sort((a, b) => a['name']['common'].compareTo(b['name']['common']));
        return List<Map<String, dynamic>>.from(
          data.map((country) {
            final isSaved = CountryPersistence.isSaved(
              country['name']['common'],
            );
            return Map<String, dynamic>.from(country)
              ..['isBookmarked'] = isSaved;
          }),
        ).where((country) => country['isBookmarked']).toList();
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
          final saved = await CountryPersistence.isSaved(
            country['name']['common'],
          );
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
}
