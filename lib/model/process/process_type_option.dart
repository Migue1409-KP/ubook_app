import 'process_model.dart';

class ProcessTypeOption {
  const ProcessTypeOption({
    required this.id,
    required this.value,
    required this.label,
  });

  final int id;
  final String value;
  final String label;

  String get processType => value;

  factory ProcessTypeOption.fromJson(Map<String, dynamic> json) {
    return ProcessTypeOption(
      id: (json['id'] as num?)?.toInt() ?? 0,
      value: json['value']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
    );
  }
}
