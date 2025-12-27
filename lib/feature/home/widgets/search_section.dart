import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF009D8B);

class SearchSection extends StatelessWidget {
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onFilterPressed;

  const SearchSection({super.key, this.onSearchChanged, this.onFilterPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: "Search user...",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey.shade100,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(50),
          ),
          child: IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: onFilterPressed,
          ),
        ),
      ],
    );
  }
}
