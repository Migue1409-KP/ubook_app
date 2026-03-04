import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../model/adjuntos/adjunto.dart';

//   file_picker: ^8.1.0

class AdjuntosView extends StatefulWidget {
  const AdjuntosView({super.key});

  @override
  State<AdjuntosView> createState() => _AdjuntosViewState();
}

class _AdjuntosViewState extends State<AdjuntosView> {

  final List<Adjunto> _adjuntos = [];

  void _agregarAdjunto(Adjunto adjunto) {
    setState(() => _adjuntos.add(adjunto));
  }

  void _eliminarAdjunto(int index) {
    setState(() => _adjuntos.removeAt(index));
  }

  Future<void> _abrirFormulario() async {
    final resultado = await showModalBottomSheet<Adjunto>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _FormularioAdjunto(),
    );
    if (resultado != null) _agregarAdjunto(resultado);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text('Adjuntos'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _adjuntos.isEmpty
          ? const _PantallaVacia()
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _adjuntos.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) => _AdjuntoCard(
                adjunto: _adjuntos[i],
                onEliminar: () => _confirmarEliminacion(context, i),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirFormulario,
        icon: const Icon(Icons.upload_file),
        label: const Text('Subir archivo'),
      ),
    );
  }

  Future<void> _confirmarEliminacion(BuildContext context, int index) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar adjunto'),
        content: Text(
            '¿Deseas eliminar "${_adjuntos[index].fileName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (ok == true) _eliminarAdjunto(index);
  }
}
────────────────────────────────────────────────────────────────────────────

class _FormularioAdjunto extends StatefulWidget {
  const _FormularioAdjunto();

  @override
  State<_FormularioAdjunto> createState() => _FormularioAdjuntoState();
}

class _FormularioAdjuntoState extends State<_FormularioAdjunto> {
  final _formKey = GlobalKey<FormState>();

  final _fileNameCtrl     = TextEditingController();
  final _uploadedByCtrl   = TextEditingController();
  final _subjectCtrl      = TextEditingController();
  final _teacherCtrl      = TextEditingController();

  String? _tipoSeleccionado;

  Uint8List? _archivoBytes;
  String?    _archivoNombre;
  int?       _archivoTamano;

  bool _seleccionando = false;

  static const _tipos = ['PDF', 'DOCX', 'PPTX', 'XLSX', 'JPG', 'PNG', 'ZIP', 'RAR', 'DOC', 'OTRO'];

  @override
  void dispose() {
    _fileNameCtrl.dispose();
    _uploadedByCtrl.dispose();
    _subjectCtrl.dispose();
    _teacherCtrl.dispose();
    super.dispose();
  }

  /// file_picker: ^8.1.0` 
  Future<void> _seleccionarArchivo() async {
    setState(() => _seleccionando = true);

    //FILE_PICKER

    // Simulacion
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _archivoNombre  = 'archivo_ejemplo.pdf';
      _archivoTamano  = 204800; // 200 KB
      _archivoBytes   = Uint8List(0);
      if (_fileNameCtrl.text.isEmpty) {
        _fileNameCtrl.text = _archivoNombre!;
      }
      _tipoSeleccionado ??= 'PDF';
      _seleccionando = false;
    });
  }

  void _enviar() {
    if (!_formKey.currentState!.validate()) return;
    if (_archivoBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes seleccionar un archivo'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final adjunto = Adjunto(
      fileName:     _fileNameCtrl.text.trim(),
      fileType:     _tipoSeleccionado!,
      uploadedById: _uploadedByCtrl.text.trim(),
      subjectId:    _subjectCtrl.text.trim(),
      teacherId:    _teacherCtrl.text.trim(),
      fileBytes:    _archivoBytes,
      fileSize:     _archivoTamano,
      uploadedAt:   DateTime.now(),
    );

    Navigator.of(context).pop(adjunto);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(20, 24, 20, 24 + bottom),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40, height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              Text('Subir adjunto',
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),


              _SelectorArchivo(
                nombreArchivo: _archivoNombre,
                tamano: _archivoBytes != null
                    ? Adjunto(
                        fileName: '',
                        fileType: '',
                        uploadedById: '',
                        subjectId: '',
                        teacherId: '',
                        fileSize: _archivoTamano,
                        uploadedAt: DateTime.now(),
                      ).fileSizeFormatted
                    : null,
                cargando: _seleccionando,
                onSeleccionar: _seleccionarArchivo,
              ),
              const SizedBox(height: 16),

              _Campo(
                controller: _fileNameCtrl,
                label: 'Nombre del archivo *',
                icon: Icons.insert_drive_file,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Ingresa el nombre del archivo'
                    : null,
              ),
              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                value: _tipoSeleccionado,
                decoration: const InputDecoration(
                  labelText: 'Tipo de archivo *',
                  prefixIcon: Icon(Icons.category),
                  border: OutlineInputBorder(),
                ),
                items: _tipos
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (v) => setState(() => _tipoSeleccionado = v),
                validator: (v) =>
                    v == null ? 'Selecciona el tipo de archivo' : null,
              ),
              const SizedBox(height: 12),

              _Campo(
                controller: _uploadedByCtrl,
                label: 'ID de usuario *',
                icon: Icons.person,
                helper: 'FK: quien sube el archivo',
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Ingresa el ID del usuario'
                    : null,
              ),
              const SizedBox(height: 12),

              _Campo(
                controller: _subjectCtrl,
                label: 'ID de materia *',
                icon: Icons.book,
                helper: 'FK: materia a la que pertenece',
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Ingresa el ID de la materia'
                    : null,
              ),
              const SizedBox(height: 12),

              _Campo(
                controller: _teacherCtrl,
                label: 'ID de profesor *',
                icon: Icons.school,
                helper: 'FK: profesor asociado',
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Ingresa el ID del profesor'
                    : null,
              ),
              const SizedBox(height: 24),

              Row(children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _enviar,
                    icon: const Icon(Icons.upload),
                    label: const Text('Subir'),
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}


class _SelectorArchivo extends StatelessWidget {
  final String?  nombreArchivo;
  final String?  tamano;
  final bool     cargando;
  final VoidCallback onSeleccionar;

  const _SelectorArchivo({
    required this.nombreArchivo,
    required this.tamano,
    required this.cargando,
    required this.onSeleccionar,
  });

  @override
  Widget build(BuildContext context) {
    final seleccionado = nombreArchivo != null;

    return GestureDetector(
      onTap: cargando ? null : onSeleccionar,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: seleccionado
              ? Colors.green.shade50
              : Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: seleccionado
                ? Colors.green.shade300
                : Colors.blue.shade300,
            width: 1.5,
          ),
        ),
        child: cargando
            ? const Center(
                child: SizedBox(
                  width: 28, height: 28,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                ),
              )
            : Row(
                children: [
                  Icon(
                    seleccionado
                        ? Icons.check_circle
                        : Icons.upload_file,
                    color: seleccionado
                        ? Colors.green.shade600
                        : Colors.blue.shade600,
                    size: 36,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          seleccionado
                              ? nombreArchivo!
                              : 'Toca para seleccionar archivo',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: seleccionado
                                ? Colors.green.shade700
                                : Colors.blue.shade700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (tamano != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            tamano!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ] else
                          Text(
                            'Imágenes (JPG/PNG) o documentos (PDF/DOCX...)',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (seleccionado)
                    Icon(Icons.swap_horiz,
                        color: Colors.green.shade400, size: 20),
                ],
              ),
      ),
    );
  }
}

class _AdjuntoCard extends StatelessWidget {
  final Adjunto adjunto;
  final VoidCallback onEliminar;

  const _AdjuntoCard({required this.adjunto, required this.onEliminar});

  IconData get _icono {
    switch (adjunto.fileType.toUpperCase()) {
      case 'PDF':  return Icons.picture_as_pdf;
      case 'DOCX':
      case 'DOC':  return Icons.description;
      case 'PPTX':
      case 'PPT':  return Icons.slideshow;
      case 'XLSX':
      case 'XLS':  return Icons.table_chart;
      case 'JPG':
      case 'JPEG':
      case 'PNG':  return Icons.image;
      case 'ZIP':  return Icons.folder_zip;
      default:     return Icons.insert_drive_file;
    }
  }

  Color get _color {
    switch (adjunto.fileType.toUpperCase()) {
      case 'PDF':  return Colors.red;
      case 'DOCX':
      case 'DOC':  return Colors.blue;
      case 'PPTX':
      case 'PPT':  return Colors.orange;
      case 'XLSX':
      case 'XLS':  return Colors.green;
      case 'JPG':
      case 'JPEG':
      case 'PNG':  return Colors.purple;
      case 'ZIP':  return Colors.brown;
      default:     return Colors.grey;
    }
  }

  String _formatFecha(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/'
      '${dt.month.toString().padLeft(2, '0')}/'
      '${dt.year}';

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Icono de tipo
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                color: _color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(_icono, color: _color, size: 26),
            ),
            const SizedBox(width: 14),

            // Info del archivo
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    adjunto.fileName,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 12,
                    runSpacing: 2,
                    children: [
                      _Chip(Icons.category,     adjunto.fileType),
                      _Chip(Icons.person,        adjunto.uploadedById),
                      _Chip(Icons.book,          adjunto.subjectId),
                      _Chip(Icons.school,        adjunto.teacherId),
                      _Chip(Icons.data_usage,    adjunto.fileSizeFormatted),
                      _Chip(Icons.calendar_today, _formatFecha(adjunto.uploadedAt)),
                    ],
                  ),
                ],
              ),
            ),

            // Botón eliminar
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              tooltip: 'Eliminar',
              onPressed: onEliminar,
            ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String   text;
  const _Chip(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: Colors.grey.shade500),
        const SizedBox(width: 3),
        Text(text,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
      ],
    );
  }
}

class _Campo extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? helper;
  final String? Function(String?) validator;

  const _Campo({
    required this.controller,
    required this.label,
    required this.icon,
    required this.validator,
    this.helper,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
        helperText: helper,
      ),
      validator: validator,
    );
  }
}

class _PantallaVacia extends StatelessWidget {
  const _PantallaVacia();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_open, size: 90, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text('Sin adjuntos todavía',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Colors.grey.shade500)),
          const SizedBox(height: 8),
          Text('Toca el botón para subir el primer archivo',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey.shade400)),
        ],
      ),
    );
  }
}
