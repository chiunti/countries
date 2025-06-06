import 'package:countries/core/app_colors.dart';
import 'package:flutter/material.dart';
import '../core/text_styles.dart';

/// Widget que muestra los lenguajes del país
class DetailLanguages extends StatelessWidget {
  final Map<String, dynamic> countryLanguages;
  const DetailLanguages({super.key, required this.countryLanguages});

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
              Text('Languages', style: TextStyles.detailCardTitle),
              Text(
                countryLanguages.values.map((e) => '- $e').join('\n'),
                style: TextStyles.detailCardSubtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                countryLanguages.length > 2 ? '- ...' : '',
                style: TextStyles.detailCardSubtitle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
