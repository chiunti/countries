import 'package:countries/components/home.dart';
import 'package:countries/models/country/country_model.dart';
import 'package:countries/models/country/country_service.dart';
import 'package:countries/app/theme/text_styles.dart';
import 'package:flutter/material.dart';

class SavedTab extends StatefulWidget {
  const SavedTab({super.key});

  @override
  State<SavedTab> createState() => _SavedTabState();
}

class _SavedTabState extends State<SavedTab> {
  List<Country> _countryData = [];
  bool _isLoading = true;
  bool _isFiltered = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadCountryData();
  }

  Future<void> _loadCountryData() async {
    try {
      final saved = await CountryService.saved(fields: 'name,capital,flags');
      setState(() {
        _countryData = saved;
        _isLoading = false;
        _isFiltered = false;
      });
    } catch (e) {
      debugPrint('Error loading country data in SavedTab: $e');
      setState(() {
        _isLoading = false;
        _isFiltered = false;
      });
    }
  }

  Future<void> _searchCountryData(String query) async {
    try {
      final data = await CountryService.searchSaved(query);
      setState(() {
        _countryData = data;
        _isFiltered = true;
        _searchQuery = query;
      });
    } catch (e) {
      debugPrint('Error searching country data in SavedTab: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: () async {
              if (_isFiltered) {
                await _searchCountryData(_searchQuery);
              } else {
                await _loadCountryData();
              }
            },
            child: Column(
              children: [
                Text('Saved', style: TextStyles.title),
                SizedBox(height: 8),
                TextSearch(
                  onChanged: (value) {
                    if (value.length > 2) {
                      setState(() {
                        _searchCountryData(value);
                      });
                    } else if (_isFiltered) {
                      setState(() {
                        _loadCountryData();
                      });
                    }
                  },
                ),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    padding: const EdgeInsets.all(8),
                    itemCount: _countryData.length,
                    itemBuilder: (context, index) {
                      return CountryCard(countryData: _countryData[index]);
                    },
                  ),
                ),
              ],
            ),
          );
  }
}
