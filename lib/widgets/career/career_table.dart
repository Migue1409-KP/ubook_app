import 'package:flutter/material.dart';
import 'package:ubook_app/model/career/career_model.dart';
import 'package:ubook_app/theme/app_colors.dart';

class CareerTable extends StatelessWidget {

  final List<Career> careers;

  final Function(Career) onView;
  final Function(Career) onEdit;
  final Function(Career) onDelete;

  const CareerTable({
    super.key,
    required this.careers,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {

    return DataTable(

      headingRowColor:
          MaterialStateProperty.all(AppColors.inputFill),

      columns: const [

        DataColumn(label: Text("Name")),
        DataColumn(label: Text("Semesters")),
        DataColumn(label: Text("Credits")),
        DataColumn(label: Text("Actions")),

      ],

      rows: careers.map((career) {

        return DataRow(cells: [

          DataCell(Text(career.name)),
          DataCell(Text(career.semesters.toString())),
          DataCell(Text(career.credits.toString())),

          DataCell(Row(

            children: [

              IconButton(
                icon: const Icon(Icons.visibility,
                    color: AppColors.primary),
                onPressed: () => onView(career),
              ),

              IconButton(
                icon: const Icon(Icons.edit,
                    color: Colors.orange),
                onPressed: () => onEdit(career),
              ),

              IconButton(
                icon: const Icon(Icons.delete,
                    color: Colors.red),
                onPressed: () => onDelete(career),
              ),

            ],
          ))

        ]);

      }).toList(),
    );
  }
}