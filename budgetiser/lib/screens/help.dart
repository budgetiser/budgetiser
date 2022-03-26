import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../shared/widgets/drawer.dart';

class Help extends StatelessWidget {
  static String routeID = 'help';
  const Help({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Help",
        ),
      ),
      drawer: createDrawer(context),
      body: FutureBuilder(
        future: rootBundle.loadString("assets/how-to.md"),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return Markdown(
              data: snapshot.data!,
              // styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      // const Center(
      //   child: Markdown(data: _markdownData),
      // ),
    );
  }
}
