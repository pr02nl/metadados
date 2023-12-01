import 'dart:io';

import 'package:uno/uno.dart';
import 'package:xml/xml.dart';

class OnePieceEpisodeInfo {
  Future<void> searchEpisodeInfo() async {
    final uno = Uno();
    final url = 'https://api.jikan.moe/v4/anime/21/episodes';
    var path = "C:\\Users\\pr02n\\Videos\\Series\\One Piece EX - 1 East Blue";
    var dir = Directory(path);
    var listSync = dir.listSync();
    for (var file in listSync) {
      var nameFile = file.path.replaceAll(path, "");
      if (nameFile.contains("720")) {
        continue;
      }
      // print(nameFile);
      var fileNameNfo = file.path.replaceAll(RegExp(r'(mkv|mp4|avi)'), 'nfo');
      var fileNfo = File(fileNameNfo);
      if (fileNfo.existsSync()) {
        print("Já existe");
        continue;
      }
      var num = nameFile.replaceAll(
          RegExp(r'([A-Z]|[õ]|mp4|[é]|[a-z]|\\|[:-_\.])'), '');
      print(num);
      num = num.split(" ").last;
      final html = await uno.get('$url/$num',
          responseType: ResponseType.json,
          headers: {'Accept-Language': 'pt-BR'});
      Map dados = html.data['data'];
      String title = dados['title'];
      String synopsis = dados['synopsis'] ?? '';
      String epNumber = num;
      var nfo = await fileNfo.create();

      final builder = XmlBuilder();
      builder.processing('xml', 'version="1.0"');
      builder.element('episodedetails', nest: () {
        builder.element('plot', nest: () {
          builder.text(synopsis);
        });
        builder.element('title', nest: () {
          builder.text(title);
        });
        builder.element('episode', nest: () {
          builder.text(epNumber);
        });
      });
      final document = builder.buildDocument();
      nfo.writeAsStringSync(document.toXmlString(pretty: true, indent: '  '),
          flush: true);
      await Future.delayed(Duration(seconds: 1));
    }
  }
}
