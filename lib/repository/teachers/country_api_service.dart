import 'dart:convert';
import 'package:http/http.dart' as http;

class CountryPhoneCode {
  final String name;
  final String code;
  final String dialCode;

  CountryPhoneCode({
    required this.name,
    required this.code,
    required this.dialCode,
  });

  factory CountryPhoneCode.fromJson(Map<String, dynamic> json) {
    String dCode = '';
    if (json['idd'] != null) {
      final root = json['idd']['root'] ?? '';
      final suffixes = json['idd']['suffixes'] as List<dynamic>?;
      final suffix = (suffixes != null && suffixes.isNotEmpty) ? suffixes[0] : '';
      dCode = '$root$suffix';
    }

    return CountryPhoneCode(
      name: json['name']?['common'] ?? 'Unknown',
      code: json['cca2'] ?? '',
      dialCode: dCode,
    );
  }
}

class CountryApiService {
  static const String _baseUrl = 'https://restcountries.com/v3.1/all?fields=name,idd,cca2';

  Future<List<CountryPhoneCode>> fetchCountries() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        final countries = jsonList
            .map((json) => CountryPhoneCode.fromJson(json))
            .where((c) => c.dialCode.isNotEmpty)
            .toList();
        
        countries.sort((a, b) => a.name.compareTo(b.name));
        return countries;
      } else {
        throw Exception('Failed to load countries');
      }
    } catch (e) {
      // In case of error (e.g. no internet), return a controlled list or throw
      throw Exception('Could not fetch country data: $e');
    }
  }

  // Fallback data if internet fails
  List<CountryPhoneCode> getFallbackCountries() {
    return [
      CountryPhoneCode(name: 'Colombia', code: 'CO', dialCode: '+57'),
      CountryPhoneCode(name: 'Mexico', code: 'MX', dialCode: '+52'),
      CountryPhoneCode(name: 'United States', code: 'US', dialCode: '+1'),
      CountryPhoneCode(name: 'Spain', code: 'ES', dialCode: '+34'),
      CountryPhoneCode(name: 'Argentina', code: 'AR', dialCode: '+54'),
      CountryPhoneCode(name: 'Peru', code: 'PE', dialCode: '+51'),
      CountryPhoneCode(name: 'Chile', code: 'CL', dialCode: '+56'),
    ];
  }
}
