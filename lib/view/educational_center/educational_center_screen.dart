import 'package:flutter/material.dart';
import '../../model/educational_center/educational_center_model.dart';
import '../../view_model/educational_center_view_model.dart';
import '../../widgets/educational_center_row.dart';
import '../../widgets/educational_center_form.dart';

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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        title: const Text(
          'Centros educativos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Gestión de Centros Educativos',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Explora, busca y administra los centros educativos',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar centro educativo',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.indigo.shade400,
                          width: 1.5,
                        ),
                      ),
                    ),
                    onChanged: _search,
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const EducationalCenterForm();
                      },
                    );
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add),
                      SizedBox(width: 6),
                      Text(
                        'Nuevo',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
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
