import 'package:countries/core/app_colors.dart';
import 'package:countries/core/text_styles.dart';
import 'package:flutter/material.dart';

/// Widget que muestra las monedas del país
class DetailCurrencies extends StatelessWidget {
  final Map<String, dynamic> countryCurrencies;
  const DetailCurrencies({super.key, required this.countryCurrencies});

  String formatCurrency(Map<String, dynamic> currency) {
    final symbol = currency['symbol'] ?? '';
    final name = currency['name'] ?? '';
    return '($symbol $name)';
  }

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
              Text('Currencies', style: TextStyles.detailCardTitle),
              Text(
                countryCurrencies.entries
                    .map((entry) {
                      return "${entry.key} ${formatCurrency(entry.value)}";
                    })
                    .join('\n'),
                style: TextStyles.detailCardSubtitle,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                countryCurrencies.length > 2 ? '...' : '',
                style: TextStyles.detailCardSubtitle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
