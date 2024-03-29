import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About',
        ),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: const Text('GitHub'),
              subtitle: const Text(
                'github.com/budgetiser/budgetiser',
              ),
              onTap: () => _launchURL(
                'https://github.com/budgetiser/budgetiser',
              ),
            ),
            ListTile(
              title: const Text('Website'),
              subtitle: const Text(
                'budgetiser.de',
              ),
              onTap: () => _launchURL('http://budgetiser.de'),
            ),
            ListTile(
              title: const Text('Version'),
              subtitle: FutureBuilder(
                future: PackageInfo.fromPlatform(),
                builder: (context, AsyncSnapshot<PackageInfo> snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  return Text(
                    snapshot.data!.version,
                  );
                },
              ),
              onTap: null,
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    final Uri urlParsed = Uri.parse(url);
    if (!await launchUrl(urlParsed, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $urlParsed');
    }
  }
}
