import 'package:budgetiser/core/database/database.dart';
import 'package:budgetiser/core/database/temporary_data/dataset.dart';
import 'package:budgetiser/shared/widgets/dialogs/confirmation_dialog.dart';
import 'package:flutter/material.dart';

class DangerZone extends StatelessWidget {
  const DangerZone({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Danger Zone',
        ),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: const Text('Export Database'),
              subtitle: const Text(
                'Into android/data',
              ),
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ConfirmationDialog(
                      title: 'Attention',
                      description:
                          'Are you sure? This will potentially override existing budgetiser.db file in the Download folder!',
                      onSubmitCallback: () {
                        DatabaseHelper.instance.exportDB();
                        Navigator.of(context).pop();
                      },
                      onCancelCallback: () {
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              },
            ),
            ListTile(
              title: const Text('Backup Data'),
              subtitle: const Text(
                'Generates a \'.json\' file with all app content.',
              ),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Export Database (JSON)'),
              subtitle: const Text(
                'Into android/data',
              ),
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ConfirmationDialog(
                      title: 'Attention',
                      description:
                          'Are you sure? This will potentially override existing budgetiser.json file in the App folder!',
                      onSubmitCallback: () {
                        DatabaseHelper.instance.exportAsJson();
                        Navigator.of(context).pop();
                      },
                      onCancelCallback: () {
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              },
            ),
            ListTile(
              title: const Text(
                'Import Database (JSON)',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              subtitle: const Text(
                'From android/data',
              ),
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ConfirmationDialog(
                      title: 'Attention',
                      description:
                          'Are you sure? This will override current state of the app! This cannot be undone! A correct DB file (budgetiser.json) must be present in Android/data/de.budgetiser.budgetiser/files/downloads folder!',
                      onSubmitCallback: () {
                        DatabaseHelper.instance.importFromJson();
                        Navigator.of(context).pop();
                      },
                      onCancelCallback: () {
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              },
            ),
            ListTile(
              title: const Text(
                'Import Database',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              subtitle: const Text(
                'From android/data',
              ),
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ConfirmationDialog(
                      title: 'Attention',
                      description:
                          'Are you sure? This will override current state of the app! This cannot be undone! A correct DB file (budgetiser.db) must be present in Android/data/de.budgetiser.budgetiser/files/downloads folder!',
                      onSubmitCallback: () {
                        DatabaseHelper.instance.importDB();
                        Navigator.of(context).pop();
                      },
                      onCancelCallback: () {
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              },
            ),
            ListTile(
              title: const Text(
                'Reset DB',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              subtitle: const Text(
                'Clear all entries',
              ),
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ConfirmationDialog(
                      title: 'Attention',
                      description:
                          'This action cannot be undone! All data will be lost.',
                      onSubmitCallback: () async {
                        await DatabaseHelper.instance.resetDB();
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pop();
                      },
                      onCancelCallback: () {
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              },
            ),
            ListTile(
              title: const Text(
                'Reset and fill DB',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              subtitle: const Text(
                'Clear all entries and fill with demo data',
              ),
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Select dataset'),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('cancel')),
                      ],
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                              ),
                              'This action cannot be undone! All current data will be lost.',
                            ),
                          ),
                          const SizedBox(height: 16),
                          Flexible(
                            child: SizedBox(
                              width: double.maxFinite,
                              child: ListView.builder(
                                itemCount: allDataSets.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(
                                      allDataSets[index].runtimeType.toString(),
                                    ),
                                    onTap: () async {
                                      await DatabaseHelper.instance.resetDB();
                                      DatabaseHelper.instance.fillDBwithTMPdata(
                                          allDataSets[index]);
                                      // ignore: use_build_context_synchronously
                                      Navigator.of(context).pop();
                                    },
                                  );
                                  // return Text('Nothing to select!');
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
