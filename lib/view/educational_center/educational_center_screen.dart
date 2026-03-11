import 'package:flutter/material.dart';
import '../../model/educational_center/educational_center_model.dart';
import '../../view_model/educational_center_view_model.dart';
import '../../widgets/educational_center_row.dart';

class EducationalCenterScreen extends StatefulWidget {
  const EducationalCenterScreen({super.key});

  @override
  State<EducationalCenterScreen> createState() =>
      _EducationalCenterScreenState();
}

class _EducationalCenterScreenState extends State<EducationalCenterScreen> {
  final EducationalCenterViewModel viewModel = EducationalCenterViewModel();

  List<EducationalCenter> filteredCenters = [];

  @override
  void initState() {
    super.initState();
    filteredCenters = viewModel.centers;
  }

  void _search(String query) {
    setState(() {
      filteredCenters = viewModel.searchCenter(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Centros educativos'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Buscar centro educativo',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: _search,
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // Aquí luego irá navegación
                  },
                  child: const Icon(Icons.add),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: filteredCenters.length,
                itemBuilder: (context, index) {
                  return EducationalCenterRow(center: filteredCenters[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
