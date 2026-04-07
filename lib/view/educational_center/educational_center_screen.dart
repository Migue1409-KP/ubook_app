import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/educational_center/educational_center_model.dart';
import '../../theme/app_colors.dart';
import '../../view_model/educational_center/educational_center_count_provider.dart';
import '../../view_model/educational_center/educational_center_view_model.dart';
import 'educational_center_detail_screen.dart';
import '../../widgets/educational_center/educational_center_row.dart';
import '../../widgets/educational_center/educational_center_form.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<EducationalCenterCountProvider>().initialize(
        total: viewModel.centers.length,
      );
    });
  }

  void _search(String query) {
    setState(() {
      filteredCenters = viewModel.searchCenter(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.onPrimary,
        foregroundColor: AppColors.textPrimary,
        title: const Text(
          'Centros educativos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
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
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Explora, busca y administra los centros educativos',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 14),
            Consumer<EducationalCenterCountProvider>(
              builder: (context, counter, _) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.onPrimary,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.account_balance_outlined,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Total de centros educativos',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        '${counter.total}',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar centro educativo',
                      hintStyle: const TextStyle(color: AppColors.placeholder),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.primary,
                      ),
                      filled: true,
                      fillColor: AppColors.inputFill,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.divider),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.divider),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
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
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
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
                        style: TextStyle(fontWeight: FontWeight.w600),
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
                  final center = filteredCenters[index];
                  return EducationalCenterRow(
                    center: center,
                    onView: () => _openCenterDetail(center),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openCenterDetail(EducationalCenter center) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EducationalCenterDetailScreen(center: center),
      ),
    );
  }
}
