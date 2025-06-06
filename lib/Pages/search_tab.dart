import 'package:countries/components/country_card.dart';
import 'package:countries/components/text_search.dart';
import 'package:countries/core/country_data.dart';
import 'package:countries/core/text_styles.dart';
import 'package:flutter/material.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
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
      final data = await CountryData.list(fields: 'name,capital,flags');
      setState(() {
        debugPrint('Country data loaded: ${data.length} countries');
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
      final data = await CountryData.search(query);
      setState(() {
        _countryData = data;
        _isFiltered = true;
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
                    await _loadCountryData();
                  },
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    padding: const EdgeInsets.all(8),
                    itemCount: _countryData.length,
                    itemBuilder: (context, index) {
                      final countryData = _countryData[index];
                      return CountryCard(
                        key: ValueKey(countryData['name']['common']),
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
