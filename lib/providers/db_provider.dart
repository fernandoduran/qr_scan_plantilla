// ignore_for_file: avoid_print

import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/scan_model.dart';

class DBProvider
{
  static Database? _database;

  static final DBProvider db = DBProvider._();
  DBProvider._();

  Future<Database> get database async {
    _database ??= await initDB();

    return _database!;
  }

  //Función que inicializa la base de datos
  Future<Database> initDB() async
  {

    //Directorio donde se almacenará la base de datos
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'ScansDB.db');
    print(path);

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) { },
      onCreate: ( Database db, int version ) async {

        await db.execute('''
          CREATE TABLE Scans(
            id INTEGER PRIMARY KEY,
            tipo TEXT,
            valor TEXT
          )
        ''');
      }
    );
  }

  /// Función para insert un SCAN usando sentencias SQL.
  /// @retun int - 1 si insert 0 si no
  Future<int> insertRawScan(ScanModel nouScan) async 
  {
    final id    = nouScan.id;
    final tipo  = nouScan.tipo;
    final valor = nouScan.valor;

    // Verificar la base de datos
    final db = await database;

    final res = await db.rawInsert('''
      INSERT INTO Scans(id, tipo, valor)
        VALUES($id, '$tipo', '$valor')
    ''');

    return res;
  }

  /// Función para insert un SCAN usando función insert nativa.
  /// @retun int - 1 si insert 0 si no
  Future<int> insertScan( ScanModel nouScan ) async 
  {
    final db = await database;
    final res = await db.insert('Scans', nouScan.toJson() );

    return res;
  }

  /// Función para recuperar todos SCAN usando función query nativa.
  /// @retun List de scans
  Future<List<ScanModel>> getAllScans() async 
  {
    final db  = await database;
    final res = await db.query('Scans');

    return res.isNotEmpty
      ? res.map((row) => ScanModel.fromJson(row)).toList()
      : [];
  }

  /// Función para recuperar un SCAN usando función query nativa con parámetros.
  /// 
  /// OJO. FUNCIÓN NO IMPLEMENTADA
  /// 
  /// @retun Scan
  Future<ScanModel?> getScanById(int id) async 
  {
    final db  = await database;
    final res = await db.query(
      'Scans', 
      where: 'id = ?', 
      whereArgs: [id]
    );

    return res.isNotEmpty
      ? ScanModel.fromJson(res.first)
      : null;
  }

  /// Función para recuperar todos SCAN usando función query nativa
  /// usando como parámetro el tipo.
  /// @retun List de scans
  Future<List<ScanModel>> getScansByType(String tipo) async 
  {
    final db  = await database;
    final res = await db.rawQuery('''
      SELECT * FROM Scans WHERE tipo = '$tipo'    
    ''');

    return res.isNotEmpty
      ? res.map((row) => ScanModel.fromJson(row)).toList()
      : [];
  }

  /// Función para actualizar un SCAN usando función update nativa
  /// pasando el parámetro del ID del scan.
  /// 
  /// OJO. FUNCIÓN NO IMPLEMENTADA
  /// 
  /// @retun int 1 si lo borra 0 si no
  Future<int> updateScan(ScanModel nouScan) async 
  {
    final db  = await database;
    final res = await db.update(
      'Scans', nouScan.toJson(), 
      where: 'id = ?', 
      whereArgs: [nouScan.id]
    );

    return res;
  }

  /// Para borrar todo el historial de Scans
  /// 
  /// @retun int 1 si lo borra 0 si no
  Future<int> deleteAllScans() async 
  {
    final db  = await database;
    final res = await db.rawDelete('''
      DELETE FROM Scans    
    ''');
    return res;
  }

  /// Para borrar del historial un Scan específico
  /// 
  /// @retun int 1 si lo borra 0 si no
  Future<int> deleteScan( int id ) async {
    final db  = await database;
    final res = await db.delete( 
      'Scans', 
      where: 'id = ?', 
      whereArgs: [id] 
    );
    return res;
  }
}
