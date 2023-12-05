
import 'package:labtest/sqlite.dart';

class BMI{

  static const String SQLiteTable = "bmi";

  String username;
  double height;
  double weight;
  String gender;
  String status;

  BMI(this.username, this.height, this.weight, this.gender, this.status);

  BMI.fromJson(Map<String, dynamic> json)
      : username = json['username'] as String,
        height = json['height'] as double,
        weight = json['weight'] as double,
        gender = json['gender'] as String,
        status = json['status'] as String;

  Map<String, dynamic> toJson() => {'username': username, 'height': height, 'weight': weight, 'gender': gender, 'status': status};

  Future<bool> save() async {
    return await SQLiteDB().insert(SQLiteTable, toJson()) != 0;
  }

  static Future<List<BMI>> loadAll() async {
    List<BMI> result = [];
 
      List<Map<String, dynamic>> localResult = await SQLiteDB().queryAll(SQLiteTable);
      for (var item in localResult) {
        result.add(BMI.fromJson(item));
      }

    return result;
  }
}