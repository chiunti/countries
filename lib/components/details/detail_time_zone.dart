import 'package:flutter/material.dart';
import 'package:countries/core/theme/app_colors.dart';
import 'package:countries/core/theme/text_styles.dart';

/// Widget que muestra las zonas horarias del país
class DetailTimeZone extends StatelessWidget {
  final List<dynamic> countryTimeZones;
  const DetailTimeZone({super.key, required this.countryTimeZones});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 10, right: 5, left: 5),
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
              Text('Time Zone', style: TextStyles.detailCardTitle),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    countryTimeZones.map((e) => '- $e').join('\n'),
                    style: TextStyles.detailCardSubtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    countryTimeZones.length > 2 ? '- ...' : '',
                    style: TextStyles.detailCardSubtitle,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
