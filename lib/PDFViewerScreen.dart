import 'dart:io'; // Add this line to import the File class

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart'; // Import Syncfusion PDF Viewer package

class PDFViewerScreen extends StatelessWidget {
  final String filePath;

  const PDFViewerScreen({Key? key, required this.filePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: SfPdfViewer.file(
        File(filePath), // Use the File class from the dart:io package
      ),
    );
  }
}
