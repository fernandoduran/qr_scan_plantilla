import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/scan_model.dart';

void launchURL(BuildContext context, ScanModel scan) async 
{
  final url = scan.valor;

  if (scan.tipo == 'http') {
    
    if(!await launchUrl(Uri.parse(url))) throw 'Could not launch $url';
    
  } else {
    Navigator.pushNamed(context, 'mapa', arguments: scan );
  }
}