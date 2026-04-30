import 'package:flutter/material.dart';
import '../../model/attachments/attachment.dart';
import '../../view_model/attachments/attachments_view_model.dart';
import '../../widgets/file_picker_widget.dart';
import '../../theme/app_colors.dart';

class AttachmentsView extends StatefulWidget {
  final String subjectId;
  final String teacherId;
  final String uploadedById;

  const AttachmentsView({
    super.key,
    this.subjectId = '',
    this.teacherId = '',
    this.uploadedById = '',
  });

  @override
  State<AttachmentsView> createState() => _AttachmentsViewState();
}

class _AttachmentsViewState extends State<AttachmentsView> {
  // Singleton: no se crea ni se destruye con la vista.
  // La selección de archivo y la lista persisten al navegar.
  final AttachmentsViewModel _vm = AttachmentsViewModel.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // No llamamos _vm.dispose() — el singleton debe seguir vivo.
    super.dispose();
  }

  Future<void> _openForm() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AttachmentForm(
        vm: _vm,
        subjectId: widget.subjectId,
        teacherId: widget.teacherId,
      ),
    );
  }

  Future<void> _confirmDeletion(int index) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar adjunto'),
        content: Text('¿Deseas eliminar "${_vm.attachments[index].fileName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (ok == true) _vm.deleteAttachment(index);
  }

  Future<void> _openFile(Attachment attachment) async {
    final error = await _vm.openFile(attachment);
    if (!mounted) return;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Adjuntos'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: 0,
      ),
      body: ListenableBuilder(
        listenable: _vm,
        builder: (context, _) {
          if (_vm.attachments.isEmpty) return const _EmptyScreen();
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: _vm.attachments.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, i) => _AttachmentCard(
              attachment: _vm.attachments[i],
              isOpening: _vm.isOpening,
              onDelete: () => _confirmDeletion(i),
              onOpen: () => _openFile(_vm.attachments[i]),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openForm,
        icon: const Icon(Icons.upload_file),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        label: const Text('Subir archivo'),
      ),
    );
  }
}

class _AttachmentForm extends StatefulWidget {
  final AttachmentsViewModel vm;
  final String subjectId;
  final String teacherId;

  const _AttachmentForm({
    required this.vm,
    required this.subjectId,
    required this.teacherId,
  });

  @override
  State<_AttachmentForm> createState() => _AttachmentFormState();
}

class _AttachmentFormState extends State<_AttachmentForm> {
  final _formKey = GlobalKey<FormState>();
  final _fileNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Restaura el nombre personalizado guardado en el VM (persiste entre aperturas del modal).
    _fileNameController.text = widget.vm.customFileName;
    // Sincroniza ediciones del usuario de vuelta al VM.
    _fileNameController.addListener(() {
      widget.vm.updateCustomFileName(_fileNameController.text);
    });
    widget.vm.addListener(_onViewModelChanged);
  }

  void _onViewModelChanged() {
    // Solo sobreescribe el campo cuando se selecciona un archivo nuevo
    // (el VM rellena customFileName automáticamente con el nombre del archivo).
    if (_fileNameController.text != widget.vm.customFileName) {
      _fileNameController.text = widget.vm.customFileName;
    }
  }

  @override
  void dispose() {
    widget.vm.removeListener(_onViewModelChanged);
    _fileNameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final attachment = widget.vm.buildAttachment(
      name: _fileNameController.text.trim(),
      subjectId: widget.subjectId,
      teacherId: widget.teacherId,
    );
    if (attachment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Debes seleccionar un archivo'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }
    widget.vm.addAttachment(attachment);
    widget.vm.clearSelection();
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(20, 24, 20, 24 + bottom),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              Text(
                'Subir adjunto',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              ListenableBuilder(
                listenable: widget.vm,
                builder: (context, _) => FilePickerWidget(
                  fileName: widget.vm.fileName,
                  detectedType: widget.vm.detectedType.isNotEmpty
                      ? widget.vm.detectedType
                      : null,
                  size: widget.vm.formattedFileSize.isNotEmpty
                      ? widget.vm.formattedFileSize
                      : null,
                  isLoading: widget.vm.isSelecting,
                  onSelect: () => widget.vm.selectFile(
                    allowedExtensions: [
                      'pdf',
                      'doc',
                      'docx',
                      'ppt',
                      'pptx',
                      'xls',
                      'xlsx',
                      'jpg',
                      'jpeg',
                      'png',
                      'zip',
                      'rar',
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              _Field(
                controller: _fileNameController,
                label: 'Nombre del archivo *',
                icon: Icons.insert_drive_file,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Ingresa el nombre del archivo'
                    : null,
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _submit,
                      icon: const Icon(Icons.upload),
                      label: const Text('Subir'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AttachmentCard extends StatelessWidget {
  final Attachment attachment;
  final bool isOpening;
  final VoidCallback onDelete;
  final VoidCallback onOpen;

  const _AttachmentCard({
    required this.attachment,
    required this.isOpening,
    required this.onDelete,
    required this.onOpen,
  });

  IconData get _icon {
    switch (attachment.fileType.toUpperCase()) {
      case 'PDF':
        return Icons.picture_as_pdf;
      case 'DOCX':
      case 'DOC':
        return Icons.description;
      case 'PPTX':
      case 'PPT':
        return Icons.slideshow;
      case 'XLSX':
      case 'XLS':
        return Icons.table_chart;
      case 'JPG':
      case 'JPEG':
      case 'PNG':
        return Icons.image;
      case 'ZIP':
        return Icons.folder_zip;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _color(ColorScheme colorScheme) {
    return AppColors.primary;
  }

  String _formatDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/'
      '${dt.month.toString().padLeft(2, '0')}/'
      '${dt.year}';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _color(colorScheme).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(_icon, color: _color(colorScheme), size: 26),
            ),
            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    attachment.fileName,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 12,
                    runSpacing: 2,
                    children: [
                      _Chip(Icons.category, attachment.fileType),
                      _Chip(Icons.person, attachment.uploadedById),
                      _Chip(Icons.book, attachment.subjectId),
                      _Chip(Icons.school, attachment.teacherId),
                      _Chip(Icons.data_usage, attachment.fileSizeFormatted),
                      _Chip(
                        Icons.calendar_today,
                        _formatDate(attachment.uploadedAt),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            isOpening
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : IconButton(
                    icon: Icon(
                      attachment.fileBytes != null
                          ? Icons.download_outlined
                          : Icons.cloud_off,
                      color: attachment.fileBytes != null
                          ? AppColors.primary
                          : Theme.of(context).colorScheme.outlineVariant,
                    ),
                    tooltip: attachment.fileBytes != null
                        ? 'Ver / Descargar'
                        : 'Archivo no disponible localmente',
                    onPressed: attachment.fileBytes != null ? onOpen : null,
                  ),
            IconButton(
              icon: Icon(
                Icons.delete_outline,
                color: Theme.of(context).colorScheme.error,
              ),
              tooltip: 'Eliminar',
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Chip(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 3),
        Text(
          text,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? Function(String?) validator;

  const _Field({
    required this.controller,
    required this.label,
    required this.icon,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      validator: validator,
    );
  }
}

class _EmptyScreen extends StatelessWidget {
  const _EmptyScreen();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_open, size: 90, color: AppColors.divider),
          const SizedBox(height: 16),
          Text(
            'Sin adjuntos todavía',
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Toca el botón para subir el primer archivo',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
