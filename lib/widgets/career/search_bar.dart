import 'package:flutter/material.dart';
import 'package:ubook_app/theme/app_colors.dart';
class SearchBarWidget extends StatelessWidget {

  final Function(String) onSearch;

  const SearchBarWidget({
    super.key,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {

    return TextField(

      onChanged: onSearch,

      decoration: InputDecoration(

        hintText: "Search careers",

        prefixIcon: const Icon(
          Icons.search,
          color: AppColors.textSecondary,
        ),

        filled: true,
        fillColor: AppColors.inputFill,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}