import 'package:flutter/material.dart';
import '../core/text_styles.dart';

/// Widget que muestra el nombre del país y su nombre oficial
class DetailCountryName extends StatelessWidget {
  final String countryName;
  final String countryOfficial;
  const DetailCountryName({
    super.key,
    required this.countryName,
    required this.countryOfficial,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Card(
          child: SizedBox(
            height: 70,
            width: 200,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    countryName,
                    textAlign: TextAlign.center,
                    style: TextStyles.cardTitle,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      countryOfficial,
                      textAlign: TextAlign.center,
                      style: TextStyles.cardSubtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
