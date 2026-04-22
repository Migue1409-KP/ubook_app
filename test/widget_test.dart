import 'package:flutter_test/flutter_test.dart';

import 'package:ubook_app/main.dart';
import 'package:ubook_app/model/computer_lab/computer_lab.dart';
import 'package:ubook_app/model/computer_lab/computer_lab_repository.dart';

class FakeComputerLabRepository implements ComputerLabRepository {
  final List<ComputerLab> _labs = [];

  @override
  Future<List<ComputerLab>> getAll() async => List.unmodifiable(_labs);

  @override
  Future<ComputerLab> save(ComputerLab lab) async {
    _labs.add(lab);
    return lab;
  }
}

void main() {
  testWidgets('dashboard renders expected sections', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MyApp(repository: FakeComputerLabRepository()));
    await tester.pumpAndSettle();

    expect(find.text('Top 5 Centros Educativos'), findsOneWidget);
    expect(find.text('Salas de Cómputo'), findsOneWidget);
  });
}
