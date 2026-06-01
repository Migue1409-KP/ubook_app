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
  State<EducationalCenterScreen> createState() => _EducationalCenterScreenState();
}

class _EducationalCenterScreenState extends State<EducationalCenterScreen> {
  final TextEditingController _searchController = TextEditingController();
  late EducationalCenterViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    // 1. Inicializamos el ViewModel localmente
    _viewModel = EducationalCenterViewModel();

    // 2. Ejecutamos la carga inicial de SQLite usando el método real de tus compañeros
    _initFetch();
  }

  Future<void> _initFetch() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      // Llamamos al método correcto de tu ViewModel para leer SQLite
      await _viewModel.loadCenters();

      // Sincronizamos el contador numérico del dashboard principal
      if (mounted) {
        context.read<EducationalCenterCountProvider>().initialize(
          total: _viewModel.centers.length,
        );
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _viewModel.dispose(); // Liberamos memoria
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EducationalCenterViewModel>.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Consumer2<EducationalCenterViewModel, EducationalCenterCountProvider>(
              builder: (context, viewModel, countProvider, child) {

                // Obtenemos la lista real expuesta por el ViewModel
                final List<EducationalCenter> dynamicCenters = viewModel.centers;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Fila superior: Botón de regresar y título principal
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 22),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Centros Educativos',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Buscador y botón de Nuevo
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _searchController,
                              onChanged: (value) {
                                // Usa el filtro nativo que programaron tus compañeros
                                viewModel.searchCenter(value);
                              },
                              decoration: const InputDecoration(
                                hintText: 'Buscar centro...',
                                hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 15),
                                prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(vertical: 14),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF134E4A),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (dialogContext) {
                                return MultiProvider(
                                  providers: [
                                    ChangeNotifierProvider<EducationalCenterViewModel>.value(value: viewModel),
                                    ChangeNotifierProvider<EducationalCenterCountProvider>.value(value: countProvider),
                                  ],
                                  child: const EducationalCenterForm(),
                                );
                              },
                            );
                          },
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add),
                              SizedBox(width: 6),
                              Text('Nuevo', style: TextStyle(fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Lista Reactiva desde la Base de Datos Local
                    Expanded(
                      child: viewModel.isLoading
                          ? const Center(child: CircularProgressIndicator(color: Color(0xFF134E4A)))
                          : dynamicCenters.isEmpty
                          ? const Center(
                        child: Text(
                          'No hay centros educativos registrados.',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      )
                          : ListView.builder(
                        itemCount: dynamicCenters.length,
                        itemBuilder: (context, index) {
                          final center = dynamicCenters[index];
                          return EducationalCenterRow(
                            center: center,
                            onView: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EducationalCenterDetailScreen(center: center),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}