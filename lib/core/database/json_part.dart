part of 'database.dart';

extension DatabaseExtensionJSON on DatabaseHelper {
  Future<Map> addMetadataToJson(Map json) async {
    json['date'] = DateTime.now().toIso8601String();
    json['budgetiser-version'] = (await PackageInfo.fromPlatform()).version;
    return json;
  }

  Future<Map> generateRobustJSON() async {
    final db = await DatabaseHelper.instance.database;
    final List<String> relations = [
      'account',
      'budget',
      'category',
      'categoryBridge',
      'categoryToBudget',
      'singleTransaction',
    ];
    var fullJSON = {};

    for (String relation in relations) {
      List data = await db.query(relation);
      fullJSON[relation] = data;
    }
    return fullJSON;
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

  Future<Uint8List> getDatabaseContentAsJson() async {
    Map fullJSON = await generateRobustJSON();
    fullJSON = await addMetadataToJson(fullJSON);
    String jsonData = jsonEncode(fullJSON);
    return utf8.encode(jsonData);
  }

  Future<Uint8List> getDatabaseContentAsPrettyJson() async {
    Map fullJSON = await generatePrettyJson();
    fullJSON = await addMetadataToJson(fullJSON);
    String jsonData = jsonEncode(fullJSON);
    return utf8.encode(jsonData);
  }

  /// Clears db and fills with json content
  Future<void> setDatabaseContentWithJson(String jsonPath) async {
    File file = File(jsonPath);
    String fileData = await file.readAsString();
    Map jsonData = jsonDecode(fileData);

    await importJSONdata(jsonData);
  }

  Future<void> importJSONdata(Map<dynamic, dynamic> jsonData) async {
    await resetDB();

    // import data
    final db = await DatabaseHelper.instance.database;
    final List<String> relations = [
      'account',
      'budget',
      'category',
      'categoryBridge',
      'categoryToBudget',
      'singleTransaction',
    ];
    debugPrint('importing data from json...');
    for (String relation in relations) {
      if (!jsonData.containsKey(relation)) {
        continue; // Skipping not present keys
      }
      for (Map<String, dynamic> row in jsonData[relation]) {
        await db.insert(relation, row);
      }
    }
    debugPrint('done importing data from json!');
  }
}
