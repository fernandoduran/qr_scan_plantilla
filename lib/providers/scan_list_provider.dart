// ignore_for_file: unnecessary_new

import 'package:flutter/material.dart';
import '../models/scan_model.dart';
import 'db_provider.dart';

class ScanListProvider extends ChangeNotifier {

  List<ScanModel> scans = []; //Lista de scans que se rellenará al consultarlos
  String tipusSeleccionat = 'http';

  //Inserción de un nuevo scan independientemente de su tipo
  Future<ScanModel> nouScan(String valor) async 
  {
    final nouScan = new ScanModel(valor: valor);
    final id = await DBProvider.db.insertScan(nouScan);
   
    nouScan.id = id;

    if (tipusSeleccionat == nouScan.tipo) {
      scans.add(nouScan);
      notifyListeners();
    }

    return nouScan;
  }

  //Carga todos los scans, independientemente de su tipo
  carregarScans() async 
  {
    final scans = await DBProvider.db.getAllScans();
    this.scans = [...scans];
    notifyListeners();
  }

  //Carga los scans por tipo
  carregarScanPerTipus(String tipo) async 
  {
    final scans = await DBProvider.db.getScansByType(tipo);
    this.scans = [...scans];
    tipusSeleccionat = tipo;
    notifyListeners();
  }

  //Borra todo el historial de scans
  esborraTots() async 
  {
    await DBProvider.db.deleteAllScans();
    scans = [];
    notifyListeners();
  }

  //Borra un scan en concreto
  esborraPerId(int id) async 
  {
    await DBProvider.db.deleteScan(id);

    ///Elminamos del array de scans el scan recién
    ///eliminado para que en la pantalla no aparezca
    ///al terminar el dissmis
    scans.removeWhere((scan) => scan.id == id);
    notifyListeners();
  }
}

