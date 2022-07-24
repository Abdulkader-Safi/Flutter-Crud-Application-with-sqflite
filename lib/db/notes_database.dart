import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:note_taking_application/model/note.dart';

class NotesDatabase {
  static final NotesDatabase instance = NotesDatabase._init();

  static Database? _database;

  NotesDatabase._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDB("notes.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
    const textType = "TEXT NOT NULL";
    const boolType = "BOOLEAN NOT NULL";
    const integerType = "INTEGER NOT NULL";

    await db.execute('''
      CREATE TABLE $tableNotes (
        ${NoteFiels.id} $idType,
        ${NoteFiels.isImportant} $boolType,
        ${NoteFiels.number} $integerType,
        ${NoteFiels.title} $textType,
        ${NoteFiels.description} $textType,
        ${NoteFiels.time} $textType
      )
    ''');
  }

  Future<Note> create(Note note) async {
    final db = await instance.database;

    final id = await db.insert(tableNotes, note.toJson());
    return note.copy(id: id);
  }

  Future<Note> readNote(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableNotes,
      columns: NoteFiels.values,
      where: "${NoteFiels.id} = ?",
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    } else {
      throw Exception("ID $id not found");
    }
  }

  Future<List<Note>> readAllNote() async {
    final db = await instance.database;

    const orderBy = "${NoteFiels.time} ASC";
    final result = await db.query(tableNotes, orderBy: orderBy);
    return result.map((json) => Note.fromJson(json)).toList();
  }

  Future<int> update(Note note) async {
    final db = await instance.database;

    return await db.update(
      tableNotes,
      note.toJson(),
      where: "${NoteFiels.id} = ?",
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableNotes,
      where: "${NoteFiels.id} = ?",
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
