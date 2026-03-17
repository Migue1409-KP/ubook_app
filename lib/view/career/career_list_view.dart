import 'package:flutter/material.dart';
import 'package:ubook_app/dialog/career_delete_dialog.dart';
import 'package:ubook_app/model/career/career_model.dart';
import 'package:ubook_app/view_model/career_view_model.dart';
import 'package:ubook_app/widgets/career/career_table.dart';
import 'package:ubook_app/widgets/career/search_bar.dart';

import 'career_create_view.dart';
import 'career_detail_view.dart';
import 'career_edit_view.dart';

class CareerListView extends StatefulWidget {
  const CareerListView({super.key});

  @override
  State<CareerListView> createState() => _CareerListViewState();
}

class _CareerListViewState extends State<CareerListView> {

  final CareerViewModel vm = CareerViewModel();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Careers"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            SearchBarWidget(
              onSearch: (value) {
                setState(() {
                  vm.setSearch(value);
                });
              },
            ),

            const SizedBox(height: 20),

            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                child: const Text("Add Career"),

                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CareerCreateView(vm: vm),
                    ),
                  ).then((_) => setState(() {}));
                },
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                child: CareerTable(

                  careers: vm.careers,

                  onView: (Career career) {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            CareerDetailView(career: career),
                      ),
                    );

                  },

                  onEdit: (Career career) {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            CareerEditView(career: career, vm: vm),
                      ),
                    ).then((_) => setState(() {}));

                  },

                  onDelete: (Career career) {

                    showDialog(
                      context: context,
                      builder: (_) => CareerDeleteDialog(
                        career: career,
                        vm: vm,
                      ),
                    ).then((_) => setState(() {}));

                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}