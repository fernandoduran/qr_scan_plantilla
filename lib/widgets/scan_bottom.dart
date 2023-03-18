import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/scan_list_provider.dart';
import '../utils/utils.dart';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ScanButton extends StatelessWidget {
  const ScanButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 0,
      child: const Icon(
        Icons.filter_center_focus,
      ),
      onPressed: () async {

        // String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        //   '#3D8BEF', 
        //   'Cancelar', 
        //   false, 
        //   ScanMode.QR 
        // );
        final barcodeScanRes = 'https://ibred.es';
        //final barcodeScanRes = 'geo:39.67555759016273,2.8257196053531533';

        if (barcodeScanRes == '-1') return;
        
        final scanListProvider = Provider.of<ScanListProvider>(context, listen: false);
        
        final nuevoScan = await scanListProvider.nouScan(barcodeScanRes);

        launchURL(context, nuevoScan);
      },
    );
  }
}
