part of 'database.dart';

extension DatabaseExtensionJSON on DatabaseHelper {
  Future<Map> addMetadataToJson(Map json) async {
    json['date'] = DateTime.now().toIso8601String();
    json['budgetiser-version'] = (await PackageInfo.fromPlatform()).version;
    return json;
  }

  Future<Map> getRobustJSON() async {
    final db = await DatabaseHelper.instance.database;
    final List<String> relations = [
      'account',
      'budget',
      'category',
      'categoryBridge',
      'categoryToBudget',
      'singleTransaction'
    ];
    var fullJSON = {};

    for (String relation in relations) {
      List data = await db.query(relation);
      fullJSON[relation] = data;
    }
    return fullJSON;
  }

  void exportAsPrettyJson() async {
    debugPrint('start json export');
    var fullJSON = await generatePrettyJson();
    fullJSON = await addMetadataToJson(fullJSON);
    saveJsonToJsonFile(jsonEncode(fullJSON));
  }

  /// Returns database content as JSON object
  Future<Map> generatePrettyJson() async {
    var fullJSON = {};
    await AccountModel().getAllAccounts().then((value) {
      fullJSON['Accounts'] = value.map((e) => e.toJsonMap()).toList();
    });

    await BudgetModel().getAllBudgets().then((value) {
      fullJSON['Budgets'] = value.map((e) => e.toJsonMap()).toList();
    });

    await CategoryModel().getAllCategories().then((value) {
      fullJSON['Categories'] = value.map((e) => e.toJsonMap()).toList();
    });

    await TransactionModel().getAllTransactions().then((value) {
      fullJSON['Transactions'] = value.map((e) => e.toJsonMap()).toList();
    });
    return fullJSON;
  }

  void importFromJson() async {
    String jsonString = '';
    try {
      jsonString = await readJsonFromFile();
    } on FileSystemException catch (e) {
      debugPrint('Error while reading json file: $e');
      return;
    }
    Map<String, dynamic> jsonObject = jsonDecode(jsonString);

    setDatabaseContentWithJson(jsonObject);
  }

  /// Clears db and fills with json content
  Future<void> setDatabaseContentWithJson(Map jsonObject) async {
    await resetDB();

    // import data
    final db = await DatabaseHelper.instance.database;
    final List<String> relations = [
      'account',
      'budget',
      'category',
      'categoryBridge',
      'categoryToBudget',
      'singleTransaction'
    ];
    debugPrint('importing data from json...');
    for (String relation in relations) {
      for (Map<String, dynamic> row in jsonObject[relation]) {
        await db.insert(relation, row);
      }
    }
    debugPrint('done importing data from json!');
  }

  void saveJsonToJsonFile(String jsonString) async {
    debugPrint('start saving json to file');

    final directory =
        await getExternalStorageDirectories(type: StorageDirectory.downloads);
    DateTime now = DateTime.now();
    String formattedNow = DateFormat('yyyyMMdd_HHmmss').format(now);
    final file =
        File('${directory?.first.path}/budgetiser_${formattedNow}.json');
    await file.writeAsString(jsonString, mode: FileMode.write);

    if (!await FlutterFileDialog.isPickDirectorySupported()) {
      debugPrint('Picking directory not supported');
      Exception('Picking directory not supported ');
    }

    final pickedDirectory = await FlutterFileDialog.pickDirectory();

    if (pickedDirectory != null) {
      final filePath = await FlutterFileDialog.saveFileToDirectory(
        directory: pickedDirectory,
        data: file.readAsBytesSync(),
        mimeType: 'application/json',
        fileName: 'budgetiser.json',
        replace: true,
      );
      debugPrint('saved json to: $filePath');
    }
  }

  Future<String> readJsonFromFile() async {
    const params = OpenFileDialogParams(
      dialogType: OpenFileDialogType.document,
      sourceType: SourceType.photoLibrary,
      fileExtensionsFilter: ['json'],
    );
    final filePath = await FlutterFileDialog.pickFile(params: params);

    // final directory =
    // await getExternalStorageDirectories(type: StorageDirectory.downloads);

    if (filePath == null) {
      throw const FileSystemException(
          'File not found or nothing picked by Dialog');
    }
    try {
      final file = File(filePath);
      if (await file.exists()) {
        String contents = await file.readAsString();
        return contents;
      } else {
        throw const FileSystemException('File not found');
      }
    } catch (e) {
      // Handle exceptions, such as File not found or other I/O errors.
      throw Exception('Error reading JSON file: $e');
    }
  }
}
