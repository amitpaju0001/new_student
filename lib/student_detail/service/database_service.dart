import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:student_info/auth/model/user_model.dart';
import 'package:student_info/student_detail/model/student_model.dart';

class DatabaseService {
  static Database? _database;
  static String tableName = 'student';

  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future _initDatabase() async {
    String dbPath = await getDatabasesPath();
    String dbName = 'school.db';
    String path = join(dbPath, dbName);
    return openDatabase(
      path,
      version: 1,
      onCreate: (Database database, int version) async {
        await createStudentTable(database);
        await createAuthTable(database);
      },
    );
  }

  static Future<void> createAuthTable(Database database) async {
    await database.execute(
        'create table auth (email primary key, name text, password text, phone text)');
  }

  static Future<void> createStudentTable(Database database) async {
    await database.execute(
      'CREATE TABLE $tableName ('
      'id INTEGER PRIMARY KEY AUTOINCREMENT, '
      'name TEXT, '
      'fName TEXT, '
      'village TEXT, '
      'fees TEXT, '
      'paidFee INTEGER, '
      'pendingFee INTEGER, '
      'joinDate TEXT,'
      'image TEXT'
      ')',
    );
  }

  Future insertStudent(StudentModel student) async {
    Database database = await getDatabase();
    await database.rawInsert(
      'INSERT INTO $tableName (name, fName,fees, village, paidFee, pendingFee, joinDate,image) '
      'VALUES (?, ?, ?, ?, ?, ?, ?,?)',
      [
        student.name,
        student.fName,
        student.fees.toString(),
        student.village,
        student.paidFee.toString(),
        student.pendingFee.toString(),
        student.joinDate,
        student.image
      ],
    );
  }

  Future registerUser(UserModel userModel) async {
    Database database = await getDatabase();
    await database.rawInsert('insert into auth values(?,?,?,?)', [
      userModel.email,
      userModel.userName,
      userModel.password,
      userModel.phone,
    ]);
  }

  Future<bool> isUserExists(String email) async {
    Database database = await getDatabase();
    List list =
        await database.rawQuery('select * from auth where email=?', [email]);

    if (list.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> login(String email,String password) async {
    Database database = await getDatabase();
    List list = await database
        .rawQuery('select * from auth where email=? and password=?', [
      email,
      password,
    ]);

    if (list.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<List<StudentModel>> fetchStudents() async {
    Database database = await getDatabase();
    List<Map<String, dynamic>> mapList =
        await database.rawQuery('select * from $tableName');
    List<StudentModel> studentModelList = [];
    for (int i = 0; i < mapList.length; i++) {
      studentModelList.add(StudentModel.fromMap(mapList[i]));
    }
    return studentModelList;
  }

  Future<int> updateStudent(StudentModel student) async {
    Database database = await getDatabase();
    String sql = '''
      UPDATE $tableName 
      SET name = ?, fName = ?, village = ? ,fees = ?,pendingFee = ?,paidFee = ?,joinDate = ?,image = ?
      WHERE id = ?
    ''';
    return await database.rawUpdate(sql, [
      student.name,
      student.fName,
      student.village,
      student.paidFee.toString(),
      student.pendingFee.toString(),
      student.joinDate,
      student.fees.toString(),
      student.image,
      student.id,
    ]);
  }

  static Future<int> deleteStudent(int id) async {
    Database database = await getDatabase();
    String sql = 'delete from $tableName where id = ?';
    return await database.rawDelete(sql, [id]);
  }
}
