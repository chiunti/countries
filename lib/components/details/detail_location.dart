import 'package:flutter/material.dart';
import 'package:countries/app/theme/app_colors.dart';
import 'package:countries/app/theme/text_styles.dart';

/// Widget que muestra la ubicación del país
class DetailLocation extends StatelessWidget {
  final String countryRegion;
  final String countrySubregion;
  final List<dynamic> countryCapital;
  const DetailLocation({
    super.key,
    required this.countryRegion,
    required this.countrySubregion,
    required this.countryCapital,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: AppColors.cardBackground,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Region', style: TextStyles.detailCardTitle),
                    Text(countryRegion, style: TextStyles.detailCardSubtitle),
                  ],
                ),
              ),
              Container(width: 1, height: 40, color: AppColors.cardDivider),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Subregion', style: TextStyles.detailCardTitle),
                    Text(
                      countrySubregion,
                      style: TextStyles.detailCardSubtitle,
                    ),
                  ],
                ),
              ),
              Container(width: 1, height: 40, color: AppColors.cardDivider),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Capital', style: TextStyles.detailCardTitle),
                    Text(
                      countryCapital.join(', '),
                      style: TextStyles.detailCardSubtitle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
