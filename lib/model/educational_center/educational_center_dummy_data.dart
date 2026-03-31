class EducationalCenterDummyData {
  final String address;
  final String type;
  final String website;

  const EducationalCenterDummyData({
    required this.address,
    required this.type,
    required this.website,
  });
}

EducationalCenterDummyData educationalCenterDummyById(String centerId) {
  switch (centerId) {
    case '1':
      return const EducationalCenterDummyData(
        address: 'Medellín, Colombia',
        type: 'Pública',
        website: 'https://unal.edu.co',
      );
    case '2':
      return const EducationalCenterDummyData(
        address: 'Medellín, Colombia',
        type: 'Pública',
        website: 'https://www.itm.edu.co',
      );
    case '3':
      return const EducationalCenterDummyData(
        address: 'Bogotá, Colombia',
        type: 'Privada',
        website: 'https://www.colombiaaprende.edu.co',
      );
    default:
      return const EducationalCenterDummyData(
        address: 'Sin dirección registrada',
        type: 'Pública',
        website: 'https://example.com',
      );
  }
}
