import 'package:countries/components/details.dart';
import 'package:countries/core/theme/app_colors.dart';
import 'package:countries/models/country/country_persistence.dart';
import 'package:countries/models/country/country_model.dart';
import 'package:flutter/material.dart';
import 'package:countries/models/country/country_service.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key, required String countryName})
    : _countryName = countryName;

  final String _countryName;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  Country? _country;

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
      final data = await CountryService.get(widget._countryName);
      setState(() {
        _country = data;
      });
    } catch (e) {
      debugPrint('Error loading country data in DetailsPage: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_country == null) {
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
            icon: Icon(
              _country!.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            ),
            color: AppColors.bookmark,
            onPressed: () {
              if (_country!.isBookmarked) {
                CountryPersistence.removeCountry(_country!.name.common);
              } else {
                CountryPersistence.saveCountry(_country!.name.common);
              }
              setState(() {
                _country!.isBookmarked = !_country!.isBookmarked;
              });
            },
          ),
        ],
        title: Text(_country!.name.common),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              DetailFlag(countryFlag: _country!.flagPng!),
              SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    DetailLocation(
                      countryRegion: _country!.region!,
                      countrySubregion: _country!.subregion!,
                      countryCapital: _country!.capital!,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: DetailTimeZone(
                            countryTimeZones: _country!.timezones!,
                          ),
                        ),
                        Expanded(
                          child: DetailPopulation(
                            countryPopulation: _country!.population!,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: DetailLanguages(
                            countryLanguages: _country!.languages!.languageMap,
                          ),
                        ),
                        Expanded(
                          child: DetailCurrencies(
                            countryCurrencies:
                                _country!.currencies!.currencyMap,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: DetailCarDrive(
                            carDriveSide: _country!.car!.side,
                          ),
                        ),
                        Expanded(
                          child: DetailCoat(
                            countryCoat: _country!.coatOfArmsPng!,
                          ),
                        ),
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
              countryName: _country!.name.common,
              countryOfficial: _country!.name.official,
            ),
          ),
        ],
      ),
    );
  }
}
