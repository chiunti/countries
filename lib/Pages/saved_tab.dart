import 'package:countries/components/country_card.dart';
import 'package:countries/components/text_search.dart';
import 'package:countries/core/country_data.dart';
import 'package:countries/core/text_styles.dart';
import 'package:flutter/material.dart';

class SavedTab extends StatefulWidget {
  const SavedTab({super.key});

  @override
  State<SavedTab> createState() => _SavedTabState();
}

class _SavedTabState extends State<SavedTab> {
  List<Map<String, dynamic>> _countryData = [];
  bool _isLoading = true;
  bool _isFiltered = false;

  @override
  void initState() {
    super.initState();
    _loadCountryData();
  }

  Future<void> _loadCountryData() async {
    try {
      final data = await CountryData.saved(fields: 'name,capital,flags');
      setState(() {
        _countryData = data;
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
      final data = await CountryData.searchSaved(query);
      setState(() {
        _countryData = data;
        _isFiltered = true;
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
            onRefresh: _loadCountryData,
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
