import 'package:flutter/material.dart';
import '../model/pqrs.dart';

class PQRSPage extends StatelessWidget {
  const PQRSPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<PQRS> mockPQRS = [
      PQRS(
        tipo: 'Petición',
        descripcion: 'Solicitud de información',
        fecha: DateTime.now(),
        estado: 'Abierta',
      ),
      PQRS(
        tipo: 'Queja',
        descripcion: 'Problema con el servicio',
        fecha: DateTime.now(),
        estado: 'En proceso',
      ),
      PQRS(
        tipo: 'Reclamo',
        descripcion: 'Cobro incorrecto',
        fecha: DateTime.now(),
        estado: 'Cerrada',
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('PQRS')),
      body: ListView.builder(
        itemCount: mockPQRS.length,
        itemBuilder: (context, index) {
          final pqrs = mockPQRS[index];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text(pqrs.tipo),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pqrs.descripcion),
                  const SizedBox(height: 4),
                  Text(
                    'Estado: ${pqrs.estado}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              trailing: const Icon(Icons.chevron_right),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
