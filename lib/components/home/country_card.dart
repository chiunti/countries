import 'package:countries/core/theme/app_colors.dart';
import 'package:countries/models/country/country_persistence.dart';
import 'package:countries/core/theme/text_styles.dart';
import 'package:countries/models/country/country_model.dart';
import 'package:flutter/material.dart';

/// Widget de tarjeta de país con información básica
class CountryCard extends StatefulWidget {
  final Country countryData;

  const CountryCard({super.key, required this.countryData});

  @override
  State<CountryCard> createState() => _CountryCardState();
}

class _CountryCardState extends State<CountryCard> {
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _isBookmarked = widget.countryData.isBookmarked;
  }

  void _toggleBookmark() {
    if (_isBookmarked) {
      CountryPersistence.removeCountry(widget.countryData.name.common);
    } else {
      CountryPersistence.saveCountry(widget.countryData.name.common);
    }
    setState(() {
      _isBookmarked = !_isBookmarked;
      widget.countryData.isBookmarked = _isBookmarked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Navega a la página de detalles cuando se hace clic en la tarjeta
      onTap: () {
        Navigator.pushNamed(
          context,
          '/details',
          arguments: widget.countryData.name.common,
        ).then((_) {
          setState(() {
            _isBookmarked = widget.countryData.isBookmarked;
          });
        });
      },
      // Tarjeta con información del país
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.grey, width: 1),
        ),
        color: AppColors.cardBackground,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Contenedor para la bandera del país
              SizedBox(
                width: 90,
                height: 90,
                child: Image.network(
                  widget.countryData.flagPng!,
                  fit: BoxFit.fitWidth,
                  // Manejo de errores para mostrar un ícono de bandera cuando no se puede cargar la imagen
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Icon(
                        Icons.flag_outlined,
                        size: 30,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              // Sección con información del país
              Expanded(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 90),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.countryData.name.common,
                        style: TextStyles.cardTitle,
                      ),
                      Text(
                        widget.countryData.name.official,
                        style: TextStyles.cardSubtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        widget.countryData.capital != null &&
                                widget.countryData.capital!.isNotEmpty
                            ? widget.countryData.capital![0]
                            : 'No capital listed',
                        style: TextStyles.cardCapital,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Botón para marcar/desmarcar favorito
              IconButton(
                icon: Icon(
                  _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: _isBookmarked
                      ? AppColors.bookmark
                      : AppColors.bookmarkBorder,
                ),
                onPressed: _toggleBookmark,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
