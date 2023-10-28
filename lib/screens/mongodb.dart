import 'package:notchai_frontend/utils/constant.dart';
import 'dart:developer';
import 'package:mongo_dart/mongo_dart.dart';

class MongoDatabase {
  static connect() async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    inspect(db);
    var status = db.serverStatus();
    // ignore: avoid_print
    print(status);
    var collection = db.collection(COLLECTION_NAME);
    // ignore: avoid_print
    print(await collection.find().toList());
  }

  static Future<void> insert() async {
    try {} catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }
}
