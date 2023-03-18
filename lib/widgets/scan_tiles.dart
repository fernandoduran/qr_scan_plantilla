import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/scan_list_provider.dart';
import '../utils/utils.dart';

class ScanTiles extends StatelessWidget {
  
  final String tipo;

  const ScanTiles({Key? key, required this.tipo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    final scanListProvider = Provider.of<ScanListProvider>(context);
    final scans = scanListProvider.scans;

    return ListView.builder(
      itemCount: scans.length,
      itemBuilder: (_, i) => Dismissible(
        key: UniqueKey(),
        background: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.centerRight,
          color: Colors.red,
          child: const Icon(Icons.delete_forever_outlined),
        ),
        onDismissed: (DismissDirection direction) {
          Provider.of<ScanListProvider>(context, listen: false)
              .esborraPerId(scans[i].id!);
        },
        child: ListTile(
          leading: Icon( 
            (tipo == 'http')
              ? Icons.home_outlined
              : Icons.map_outlined, 
            color: Theme.of(context).primaryColor 
          ),
          title: Text(scans[i].valor),
          subtitle: Text(scans[i].id.toString()),
          trailing: const Icon(
            Icons.keyboard_arrow_right, 
            color: Colors.grey),
          onTap: () => launchURL(context, scans[i]),
        ),
      )
    );


  }
}