import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/text_styles.dart';

/// Widget que muestra el escudo nacional
class DetailCoat extends StatelessWidget {
  final String countryCoat;
  const DetailCoat({super.key, required this.countryCoat});

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
            children: [
              Text('Coat of Arms', style: TextStyles.detailCardTitle),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: AppColors.background,
                  child: CircleAvatar(
                    radius: 23,
                    backgroundColor: AppColors.cardBackground,
                    child: Image.network(
                      countryCoat,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.shield_outlined);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
