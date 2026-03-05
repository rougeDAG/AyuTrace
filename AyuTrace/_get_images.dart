import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final queries = [
    'Withania_somnifera', // Ashwagandha
    'Ocimum_tenuiflorum', // Tulsi
    'Triphala',
    'Liver', // For spaliv
    'Bacopa_monnieri', // Brahmi
    'Chyavanprash', // Chyawanprash
  ];

  for (final q in queries) {
    print('Querying $q...');
    final url = Uri.parse(
      'https://en.wikipedia.org/api/rest_v1/page/summary/$q',
    );
    final request = await HttpClient().getUrl(url);
    final response = await request.close();
    final stringData = await response.transform(utf8.decoder).join();
    final json = jsonDecode(stringData);
    if (json.containsKey('thumbnail')) {
      print('$q -> ${json['thumbnail']['source']}');
    } else {
      print('$q -> no image found');
    }
  }
}
