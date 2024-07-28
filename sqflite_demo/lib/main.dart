import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/widgets.dart';

dynamic database;

class Player {
  final String name;
  final int jerNo;
  final int runs;
  final double avg;

  Player({
    required this.name,
    required this.jerNo,
    required this.runs,
    required this.avg,
  });

  Map<String, dynamic> playerMap() {
    return {
      'name': name,
      'jerNo': jerNo,
      'runs': runs,
      'avg': avg,
    };
  }

  Future<void> insertPlayerData(Player obj) async {
    final localDB = await database;

    await localDB.insert(
      "Player",
      obj.playerMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Player>> getPlayerData() async {
    final localDB = await database;
    List<Map<String, dynamic>> listplayers = await localDB.query("Player");

    return List.generate(listplayers.length, (i) {
      return Player(
        name: listplayers[i]['name'],
        jerNo: listplayers[i]['jerNo'],
        runs: listplayers[i]['runs'],
        avg: listplayers[i]['avg'],
      );
    });
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  database =  openDatabase(
    join(await getDatabasesPath(), "playerDB.db"),
    version: 1,
    onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE Player(name TEXT ,jerNo INTEGER PRIMARY KEY ,runs INT ,avg REAL)');
    },
  );

  // INSERTING
  Player batsman1 = Player(
    name: "Virat Kohli",
    jerNo: 18,
    runs: 40000,
    avg: 50.30,
  );

  await batsman1.insertPlayerData(batsman1);
  print(await batsman1.getPlayerData());
}
