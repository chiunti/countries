import 'package:flutter/material.dart';

/// Widget que muestra un campo de búsqueda
class TextSearch extends StatefulWidget {
  final Function(String) onChanged;
  const TextSearch({super.key, required this.onChanged});

  @override
  State<TextSearch> createState() => _TextSearchState();
}

class _TextSearchState extends State<TextSearch> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          hintText: 'Search',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {},
          ),
          filled: true,
        ),
      ),
    );
  }
}
