import 'dart:io';

import 'package:html/parser.dart' show parse;
import 'package:intl/intl.dart';
import 'package:uno/uno.dart';
import 'package:xml/xml.dart';

Future<void> main(List<String> arguments) async {
  final uno = Uno();
  final url = 'https://www.themoviedb.org/tv/12609-dragon-ball/season/1';
  final html = await uno.get(url,
      responseType: ResponseType.plain, headers: {'Accept-Language': 'pt-BR'});
  final document = parse(html.data);
  final title = document.querySelector('title')?.text;
  print(title);
  document.querySelectorAll('.episode').forEach((element) {
    final title = element.querySelector('.title');
    final epNumber = title?.querySelector('.episode_number')?.text;
    final epTitle = title?.querySelector('h3')?.text;
    final overview =
        element.querySelector('.overview')?.querySelector('p')?.text;
    print('epNumber: $epNumber, epTitle: $epTitle\noverview: $overview');
    readFile(epNumber, epTitle, overview);
  });
}

void readFile(String? epNumber, String? epTitle, String? overview) {
  String path1 =
      'C:\\Users\\pr02n\\Series\\Dragon Ball\\Dragon Ball [Episódio 01 ao 75]';
  String path2 =
      'C:\\Users\\pr02n\\Series\\Dragon Ball\\Dragon Ball [Episódio 76 ao 153]';
  String path = '';
  var episodioNumber = int.parse(epNumber!);
  if (episodioNumber <= 75) {
    path = path1;
  } else {
    path = path2;
  }
  var n = NumberFormat('000');
  final file =
      File('$path\\Dragon Ball - Episódio ${n.format(episodioNumber)}.nfo');
  final contents = file.readAsStringSync();
  final document = XmlDocument.parse(contents);
  document.getElement('episodedetails')?.childElements.forEach((element) {
    if (element.name.local == 'plot') {
      element.innerText = overview!;
    }
    if (element.name.local == 'title') {
      element.innerText = epTitle!;
    }
    if (element.name.local == 'episode') {
      element.innerText = epNumber;
    }
    if (element.name.local == 'season') {
      element.innerText = '1';
    }
  });
  file.writeAsStringSync(document.toXmlString(pretty: true, indent: '  '),
      flush: true);
}
