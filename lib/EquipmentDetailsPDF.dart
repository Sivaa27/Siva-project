import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';

import 'PDFViewerScreen.dart';

class EquipmentDetailsPDF {
  static Future<void> generatePDF({
    required String fileName,
    required TextEditingController nameController,
    required TextEditingController serialController,
    required TextEditingController manufacturerController,
    required TextEditingController hospitalController,
    required TextEditingController departmentController,
    required TextEditingController wardController,
    required TextEditingController picController,
    required TextEditingController classController,
    required TextEditingController typeController,
    required TextEditingController dateController,
    required TextEditingController nextDateController,
    required Map<String, String?> questionnaireValues, // Added parameter for questionnaire values
    required BuildContext context,
  }) async {
    // Create a new PDF document
    final PdfDocument document = PdfDocument();

    // Add a new page to the document
    final PdfPage page = document.pages.add();

    // Create a PDF grid class to add tables for equipment details and checklist
    final PdfGrid grid = PdfGrid();
    final PdfGrid checklistGrid = PdfGrid();

    // Specify the grid column count for equipment details
    grid.columns.add(count: 2);

    // Add a grid header row for equipment details
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    headerRow.cells[0].value = 'Field';
    headerRow.cells[1].value = 'Value';

    // Set header font for equipment details
    headerRow.style.font = PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold);

    // Add rows to the grid for equipment details
    _addRow(grid, 'Equipment Name', nameController.text);
    _addRow(grid, 'Serial Number', serialController.text);
    _addRow(grid, 'Manufacturer', manufacturerController.text);
    _addRow(grid, 'Hospital', hospitalController.text);
    _addRow(grid, 'PIC', picController.text);
    _addRow(grid, 'Last Date', dateController.text);
    _addRow(grid, 'Next Date', nextDateController.text);

    // Set grid format for equipment details
    grid.style.cellPadding = PdfPaddings(left: 5, top: 5);

    // Draw equipment details table in the PDF page
    grid.draw(
      page: page,
      bounds: Rect.fromLTWH(0, 0, page.getClientSize().width, page.getClientSize().height),
    );

    // Add a new page for the checklist
    document.pages.add();

    // Add a title for the checklist
    final PdfPage secondPage = document.pages[1];
    final PdfTextElement title = PdfTextElement(
        text: '${nameController.text} Checklist',
        font: PdfStandardFont(PdfFontFamily.helvetica, 16, style: PdfFontStyle.bold));
    title.draw(
        page: secondPage,
        bounds: Rect.fromLTWH(0, 0, secondPage.getClientSize().width, 50),
        format: PdfLayoutFormat());

    // Specify the grid column count for the checklist
    checklistGrid.columns.add(count: 2);

    // Add rows to the grid for the checklist
    for (final entry in questionnaireValues.entries) {
      _addRow(checklistGrid, entry.key, entry.value ?? '');
    }

    // Set grid format for the checklist
    checklistGrid.style.cellPadding = PdfPaddings(left: 5, top: 5);

    // Draw checklist table in the PDF page
    checklistGrid.draw(
      page: secondPage,
      bounds: Rect.fromLTWH(0, 50, secondPage.getClientSize().width, secondPage.getClientSize().height - 50),
    );

    // Get the documents directory
    final directory = await getApplicationDocumentsDirectory();
    // Construct the file path
    final filePath = '${directory.path}/$fileName';

    // Save the document
    File(filePath).writeAsBytes(await document.save());

    // Dispose the document
    document.dispose();

    // Open the PDF file using any PDF viewer installed on the device
    // Here, I'm using the default PDF viewer provided by Flutter
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFViewerScreen(filePath: filePath),
      ),
    );
  }

  // Helper method to add a row to the PDF grid
  static void _addRow(PdfGrid grid, String label, String value) {
    final PdfGridRow row = grid.rows.add();
    row.cells[0].value = label;
    row.cells[1].value = value;
  }
}
