import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Persistence {
  static const String _savedKeys = 'saved_keys';

  Future<void> save(String key, dynamic value) async {
    if (key.isEmpty) return;
    if (value == null) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      if (value is String) {
        await prefs.setString("${_savedKeys}_$key", "String");
        await prefs.setString(key, value);
      }
      if (value is int) {
        await prefs.setString("${_savedKeys}_$key", "int");
        await prefs.setInt(key, value);
      }
      if (value is double) {
        await prefs.setString("${_savedKeys}_$key", "double");
        await prefs.setDouble(key, value);
      }
      if (value is bool) {
        await prefs.setString("${_savedKeys}_$key", "bool");
        await prefs.setBool(key, value);
      }
      if (value is List<String>) {
        await prefs.setString("${_savedKeys}_$key", "List<String>");
        await prefs.setStringList(key, value);
      }
      if (value is List<int>) {
        await prefs.setString("${_savedKeys}_$key", "List<int>");
        await prefs.setStringList(key, value.map((e) => e.toString()).toList());
      }
      if (value is List<double>) {
        await prefs.setString("${_savedKeys}_$key", "List<double>");
        await prefs.setStringList(key, value.map((e) => e.toString()).toList());
      }
      if (value is List<bool>) {
        await prefs.setString("${_savedKeys}_$key", "List<bool>");
        await prefs.setStringList(key, value.map((e) => e.toString()).toList());
      }
      if (value is List<dynamic>) {
        await prefs.setString("${_savedKeys}_$key", "List<dynamic>");
        await prefs.setStringList(
          key,
          value.map((e) => "${e.runtimeType}:$e").toList(),
        );
      }
      if (value is Map<String, dynamic>) {
        await prefs.setString("${_savedKeys}_$key", "Map<String, dynamic>");
        await prefs.setString(key, value.toString());
      }
    } catch (e) {
      debugPrint('Error saving persistence $key: $e');
    }
  }

  Future<void> remove(String key) async {
    if (key.isEmpty) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove("${_savedKeys}_$key");
      await prefs.remove(key);
    } catch (e) {
      debugPrint('Error removing persistence $key: $e');
    }
  }

  Future<dynamic> get(String key) async {
    if (key.isEmpty) return null;
    try {
      final prefs = await SharedPreferences.getInstance();
      final type = prefs.getString("${_savedKeys}_$key");
      if (type == "String") {
        return prefs.getString(key);
      }
      if (type == "int") {
        return prefs.getInt(key);
      }
      if (type == "double") {
        return prefs.getDouble(key);
      }
      if (type == "bool") {
        return prefs.getBool(key);
      }
      if (type == "List<String>") {
        return prefs.getStringList(key);
      }
      if (type == "List<int>") {
        return prefs.getStringList(key)?.map((e) => int.parse(e)).toList();
      }
      if (type == "List<double>") {
        return prefs.getStringList(key)?.map((e) => double.parse(e)).toList();
      }
      if (type == "List<bool>") {
        return prefs.getStringList(key)?.map((e) => bool.parse(e)).toList();
      }
      if (type == "List<dynamic>") {
        final result = prefs.getStringList(key)?.map((e) {
          if (e.startsWith("int:")) {
            return int.parse(e.split(":")[1]);
          }
          if (e.startsWith("double:")) {
            return double.parse(e.split(":")[1]);
          }
          if (e.startsWith("bool:")) {
            return bool.parse(e.split(":")[1]);
          }
          return e.split(":")[1];
        }).toList();
        return result;
      }
      if (type == "Map<String, dynamic>") {
        return jsonDecode(prefs.getString(key)!) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      debugPrint('Error getting persistence $key: $e');
      return null;
    }
  }

  Future<bool> isSaved(String key) async {
    if (key.isEmpty) return false;
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedKeys = prefs.getString("${_savedKeys}_$key");
      return savedKeys != null;
    } catch (e) {
      debugPrint('Error checking if persistence $key is saved: $e');
      return false;
    }
  }
}
