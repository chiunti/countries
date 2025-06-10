import 'package:flutter/material.dart';
import 'package:countries/app/theme/app_colors.dart';
import 'package:countries/app/theme/text_styles.dart';
import 'package:intl/intl.dart';

/// Widget que muestra la población del país
class DetailPopulation extends StatelessWidget {
  final int countryPopulation;
  const DetailPopulation({super.key, required this.countryPopulation});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 10, left: 5, right: 5),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: AppColors.cardBackground,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Population', style: TextStyles.detailCardTitle),
              Text(
                NumberFormat('#,###').format(countryPopulation),
                style: TextStyles.detailCardSubtitle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
