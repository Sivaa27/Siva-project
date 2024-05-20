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
    required Map<String, String?> questionnaireValues,
    required Map<String, String?> remarks,
    required String comments,
    required String performedBy,
    required BuildContext context,
  }) async {
    final PdfDocument document = PdfDocument();

    // First page with equipment details
    final PdfPage page = document.pages.add();
    final PdfGrid grid = PdfGrid();
    grid.columns.add(count: 2);

    final PdfGridRow headerRow = grid.headers.add(1)[0];
    headerRow.cells[0].value = 'Field';
    headerRow.cells[1].value = 'Value';
    headerRow.style.font = PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold);

    _addRow(grid, 'Equipment Name', nameController.text);
    _addRow(grid, 'Serial Number', serialController.text);
    _addRow(grid, 'Manufacturer', manufacturerController.text);
    _addRow(grid, 'Hospital', hospitalController.text);
    _addRow(grid, 'PIC', picController.text);
    _addRow(grid, 'Last Date', dateController.text);
    _addRow(grid, 'Next Date', nextDateController.text);

    grid.style.cellPadding = PdfPaddings(left: 5, top: 5);
    grid.draw(
      page: page,
      bounds: Rect.fromLTWH(0, 0, page.getClientSize().width, page.getClientSize().height),
    );

    // Second page with checklist
    document.pages.add();
    final PdfPage secondPage = document.pages[1];
    final PdfTextElement title = PdfTextElement(
        text: '${nameController.text} Checklist',
        font: PdfStandardFont(PdfFontFamily.helvetica, 16, style: PdfFontStyle.bold));
    title.draw(
        page: secondPage,
        bounds: Rect.fromLTWH(0, 0, secondPage.getClientSize().width, 50),
        format: PdfLayoutFormat());

    final PdfGrid checklistGrid = PdfGrid();
    checklistGrid.columns.add(count: 3);

    final PdfGridRow checklistHeaderRow = checklistGrid.headers.add(1)[0];
    checklistHeaderRow.cells[0].value = 'Question';
    checklistHeaderRow.cells[1].value = 'Answer';
    checklistHeaderRow.cells[2].value = 'Remark';
    checklistHeaderRow.style.font = PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold);

    for (final entry in questionnaireValues.entries) {
      _addChecklistRow(checklistGrid, entry.key, entry.value ?? '', remarks[entry.key] ?? '');
    }

    // Add Comments and Performed By
    _addChecklistRow(checklistGrid, 'Comments', comments, '');
    _addChecklistRow(checklistGrid, 'Performed By', performedBy, '');

    checklistGrid.style.cellPadding = PdfPaddings(left: 5, top: 5);
    checklistGrid.draw(
      page: secondPage,
      bounds: Rect.fromLTWH(0, 50, secondPage.getClientSize().width, secondPage.getClientSize().height - 50),
    );

    // Save and open PDF
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';
    File(filePath).writeAsBytes(await document.save());
    document.dispose();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFViewerScreen(filePath: filePath),
      ),
    );
  }

  static void _addRow(PdfGrid grid, String label, String value) {
    final PdfGridRow row = grid.rows.add();
    row.cells[0].value = label;
    row.cells[1].value = value;
  }

  static void _addChecklistRow(PdfGrid grid, String question, String answer, String remark) {
    final PdfGridRow row = grid.rows.add();
    row.cells[0].value = question;
    row.cells[1].value = answer;
    row.cells[2].value = remark;
  }
}
