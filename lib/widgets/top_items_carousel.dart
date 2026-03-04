import 'package:flutter/material.dart';

class TopItemsCarousel extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;
  final List<Map<String, dynamic>> items;
  final Widget Function(Map<String, dynamic>) itemBuilder;

  const TopItemsCarousel({
    super.key,
    required this.title,
    required this.onSeeAll,
    required this.items,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              TextButton(
                onPressed: onSeeAll,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.indigo,
                ),
                child: const Text(
                  'Ver todos',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 190,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
                child: itemBuilder(items[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}
