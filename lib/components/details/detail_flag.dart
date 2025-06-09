import 'package:flutter/material.dart';

/// Widget que muestra la bandera del país
class DetailFlag extends StatelessWidget {
  final String countryFlag;
  const DetailFlag({super.key, required this.countryFlag});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Image.network(
        countryFlag,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Icon(Icons.flag_outlined, size: 30, color: Colors.grey),
          );
        },
      ),
    );
  }
}
