import 'dart:typed_data';

import 'package:budgetiser/core/database/database.dart';
import 'package:budgetiser/core/database/temporary_data/dataset.dart';
import 'package:budgetiser/shared/widgets/dialogs/confirmation_dialog.dart';
import 'package:budgetiser/shared/widgets/divider_with_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
          children: [
            const DividerWithText('Backup'),
            ListTile(
              title: const Text('Backup data'),
              subtitle: const Text(
                'Generates a \'.json\' file with all app data.',
              ),
              onTap: () async {
                DateTime now = DateTime.now();
                String dtSuffix = DateFormat('yyyyMMdd_HHmm').format(now);
                Uint8List databaseContent =
                    await DatabaseHelper.instance.getDatabaseContentAsJson();

                String? outputFile = await FilePicker.platform.saveFile(
                  fileName: 'budgetiser_$dtSuffix.json',
                  bytes: databaseContent,
                );

                if (outputFile == null) {
                  // User canceled the picker
                }
              },
            ),
            ListTile(
              title: const Text('Export data (JSON)'),
              subtitle: const Text(
                'Export app data to easy to read json format. (no import supported)',
              ),
              onTap: () async {
                DateTime now = DateTime.now();
                String dtSuffix = DateFormat('yyyyMMdd_HHmm').format(now);
                Uint8List databaseContent = await DatabaseHelper.instance
                    .getDatabaseContentAsPrettyJson();

                String? outputFile = await FilePicker.platform.saveFile(
                  fileName: 'budgetiser_pretty_$dtSuffix.json',
                  bytes: databaseContent,
                );

                if (outputFile == null) {
                  // User canceled the picker
                }
              },
            ),
            ListTile(
              title: const Text('Backup database'),
              subtitle: const Text(
                'Exports the database file. No app settings included. Also works with corrupted data.',
              ),
              onTap: () async {
                DateTime now = DateTime.now();
                String dtSuffix = DateFormat('yyyyMMdd_HHmm').format(now);
                Uint8List databaseContent =
                    await DatabaseHelper.instance.getDatabaseContent();

                String? outputFile = await FilePicker.platform.saveFile(
                  fileName: 'budgetiser_data_$dtSuffix.db',
                  bytes: databaseContent,
                );

                if (outputFile == null) {
                  // User canceled the picker
                }
              },
            ),
            const DividerWithText('Restore'),
            ListTile(
              title: const Text(
                'Restore data',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              subtitle: const Text(
                'Imports a compatible \'.json\' data file. App settings included.',
              ),
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ConfirmationDialog(
                      title: 'Attention',
                      description:
                          'Importing a json file will overwrite all existing data in the app. This action cannot be undone!',
                      onSubmitCallback: () async {
                        FilePickerResult? filesPickerResult =
                            await FilePicker.platform.pickFiles(
                          allowMultiple: false,
                          allowedExtensions: ['json'],
                          type: FileType.custom,
                        );

                        if (filesPickerResult == null ||
                            filesPickerResult.count != 1) {
                          return; // Invalid selection
                        }
                        String? filePath = filesPickerResult.files.first.path;
                        if (filePath == null) {
                          return; // Invalid file
                        }

                        DatabaseHelper.instance
                            .setDatabaseContentWithJson(filePath);
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
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
                'Restore from database-file',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              subtitle: const Text(
                'Imports a database-file.',
              ),
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ConfirmationDialog(
                      title: 'Attention',
                      description:
                          'Importing a database file will overwrite all existing data in the app '
                          '(excluding some preferential settings). This action cannot be undone!',
                      onSubmitCallback: () async {
                        FilePickerResult? filesPickerResult =
                            await FilePicker.platform.pickFiles(
                          allowMultiple: false,
                          type: FileType.any,
                        );

                        if (filesPickerResult == null ||
                            filesPickerResult.count != 1) {
                          return; // Invalid selection
                        }
                        String? filePath = filesPickerResult.files.first.path;
                        if (filePath == null || !filePath.endsWith('.db')) {
                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
                          return; // Invalid file
                        }
                        DatabaseHelper.instance
                            .importDatabaseFromPath(filePath);
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      },
                      onCancelCallback: () {
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              },
            ),
            const DividerWithText('Reset app'),
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

                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
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
                          child: const Text('cancel'),
                        ),
                      ],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 16,
                      ),
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
                                        allDataSets[index],
                                      );
                                      if (context.mounted) {
                                        Navigator.of(context).pop();
                                      }
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
