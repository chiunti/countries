import 'package:flutter/material.dart';
import 'package:countries/core/theme/app_colors.dart';
import 'package:countries/core/theme/text_styles.dart';

/// Widget que muestra la información de la dirección del coche
class DetailCarDrive extends StatelessWidget {
  final String carDriveSide;
  const DetailCarDrive({super.key, required this.carDriveSide});

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
              Text('Car Drive Side', style: TextStyles.detailCardTitle),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'LEFT',
                      style: carDriveSide == 'left'
                          ? TextStyles.detailCardTitle
                          : TextStyles.cardCapital,
                    ),
                    SizedBox(width: 5),
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: AppColors.background,
                      child: CircleAvatar(
                        radius: 13,
                        backgroundColor: AppColors.cardBackground,
                        child: Icon(Icons.directions_car_outlined),
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      'RIGHT',
                      style: carDriveSide == 'right'
                          ? TextStyles.detailCardTitle
                          : TextStyles.cardCapital,
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
