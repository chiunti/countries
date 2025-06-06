import 'package:countries/components/detail_car_drive.dart';
import 'package:countries/components/detail_coat.dart';
import 'package:countries/components/detail_country_name.dart';
import 'package:countries/components/detail_currencies.dart';
import 'package:countries/components/detail_flag.dart';
import 'package:countries/components/detail_location.dart';
import 'package:countries/components/detail_population.dart';
import 'package:countries/components/detail_time_zone.dart';
import 'package:countries/components/detail_languages.dart';
import 'package:countries/core/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:countries/core/country_data.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key, required String countryName})
    : _countryName = countryName;

  final String _countryName;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  Map<String, dynamic>? countryJSON;
  String _countryName = '';
  String _countryOfficial = '';
  List<dynamic> _countryCapital = [];
  String _countryFlag = '';
  int _countryPopulation = 0;
  List<dynamic> _countryTimeZones = [];
  Map<String, dynamic> _countryLanguages = {};
  Map<String, dynamic> _countryCurrencies = {};
  String _countryCarDrive = '';
  String _countryCoat = '';
  String _countryRegion = '';
  String _countrySubregion = '';
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    debugPrint(
      'DetailsPage initState called with countryName: ${widget._countryName}',
    );
    _loadCountryData();
  }

  Future<void> _loadCountryData() async {
    try {
      debugPrint('Loading country data for: ${widget._countryName}');
      final data = await CountryData.get(widget._countryName);
      setState(() {
        _countryName = data?['name']['common'] ?? '';
        _countryOfficial = data?['name']['official'] ?? '';
        _countryFlag = data?['flags']['png'] ?? '';
        _countryPopulation = data?['population'] ?? 0;
        _countryTimeZones = data?['timezones'] ?? [];
        _countryLanguages = data?['languages'] ?? {};
        _countryCurrencies = data?['currencies'] ?? {};
        _countryCarDrive = data?['car']['side'] ?? '';
        _countryCoat = data?['coatOfArms']['png'] ?? '';
        _countryRegion = data?['region'] ?? '';
        _countrySubregion = data?['subregion'] ?? '';
        _countryCapital = data?['capital'] ?? [];
        _isBookmarked = data?['isBookmarked'] ?? false;
      });
    } catch (e) {
      debugPrint('Error loading country data in DetailsPage: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_countryName.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('Details'),
          centerTitle: true,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(_isBookmarked ? Icons.bookmark : Icons.bookmark_border),
            color: AppColors.bookmark,
            onPressed: () {
              if (_isBookmarked) {
                CountryData.removeCountry(_countryName);
              } else {
                CountryData.saveCountry(_countryName);
              }
              setState(() {
                _isBookmarked = !_isBookmarked;
              });
            },
          ),
        ],
        title: Text(_countryName),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              DetailFlag(countryFlag: _countryFlag),
              SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    DetailLocation(
                      countryRegion: _countryRegion,
                      countrySubregion: _countrySubregion,
                      countryCapital: _countryCapital,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: DetailTimeZone(
                            countryTimeZones: _countryTimeZones,
                          ),
                        ),
                        Expanded(
                          child: DetailPopulation(
                            countryPopulation: _countryPopulation,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: DetailLanguages(
                            countryLanguages: _countryLanguages,
                          ),
                        ),
                        Expanded(
                          child: DetailCurrencies(
                            countryCurrencies: _countryCurrencies,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: DetailCarDrive(carDriveSide: _countryCarDrive),
                        ),
                        Expanded(child: DetailCoat(countryCoat: _countryCoat)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 160,
            left: 20,
            right: 20,
            child: DetailCountryName(
              countryName: _countryName,
              countryOfficial: _countryOfficial,
            ),
          ),
        ],
      ),
    );
  }
}
