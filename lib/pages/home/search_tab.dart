import 'package:countries/components/home.dart';
import 'package:countries/models/country/country_service.dart';
import 'package:countries/core/theme/text_styles.dart';
import 'package:countries/models/country/country_model.dart';
import 'package:flutter/material.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
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
      final data = await CountryService.list(fields: 'name,capital,flags');
      setState(() {
        _countryData = data;
        _isLoading = false;
        _isFiltered = false;
      });
    } catch (e) {
      debugPrint('Error loading country data in SearchTab: $e');
      setState(() {
        _isLoading = false;
        _isFiltered = false;
      });
    }
  }

  Future<void> _searchCountryData(String query) async {
    try {
      final data = await CountryService.search(query);
      setState(() {
        _countryData = data;
        _isFiltered = true;
        _searchQuery = query;
      });
    } catch (e) {
      debugPrint('Error searching country data in SearchTab: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Text('Search', style: TextStyles.title),
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
                child: RefreshIndicator(
                  onRefresh: () async {
                    if (_isFiltered) {
                      await _searchCountryData(_searchQuery);
                    } else {
                      await _loadCountryData();
                    }
                  },
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    padding: const EdgeInsets.all(8),
                    itemCount: _countryData.length,
                    itemBuilder: (context, index) {
                      final countryData = _countryData[index];
                      return CountryCard(
                        key: ValueKey(countryData.name.common),
                        countryData: countryData,
                      );
                    },
                  ),
                ),
              ),
            ],
          );
  }
}
