import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PrescriptionPdfGenerator {
  static Future<Uint8List> generatePrescription() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(32),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Ayurvedic Prescription',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: const PdfColor.fromInt(0xFF2E4F4F),
                      ),
                    ),
                    pw.Container(
                      width: 40,
                      height: 40,
                      decoration: const pw.BoxDecoration(
                        shape: pw.BoxShape.circle,
                        color: PdfColor.fromInt(0xFF2E8B57),
                      ),
                      child: pw.Center(
                        child: pw.Text(
                          'A',
                          style: pw.TextStyle(
                            color: PdfColors.white,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 24),

                // Doctor Info
                pw.Container(
                  padding: const pw.EdgeInsets.all(16),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey100,
                    borderRadius: pw.BorderRadius.circular(12),
                  ),
                  child: pw.Row(
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'Dr. Joseph Criston',
                            style: pw.TextStyle(
                              fontSize: 18,
                              fontWeight: pw.FontWeight.bold,
                              color: const PdfColor.fromInt(0xFF2E8B57),
                            ),
                          ),
                          pw.SizedBox(height: 4),
                          pw.Text(
                            'Consulted on: 3 March 2026',
                            style: const pw.TextStyle(color: PdfColors.grey700),
                          ),
                          pw.Text(
                            'RX-ID: AYU 2026-03-02',
                            style: const pw.TextStyle(color: PdfColors.grey700),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 24),

                // Patient Info
                _buildSectionTitle('Patient Info'),
                pw.SizedBox(height: 8),
                pw.Text('Saima · 34 · Pitta-Vata Prakruti'),
                pw.SizedBox(height: 20),

                // Dosha Balance
                _buildSectionTitle('Dosha Balance'),
                pw.SizedBox(height: 12),
                _buildDoshaText('Vata', '█████████████░░░░░░░ (55%)'),
                _buildDoshaText('Pitta', '█████████████████░░░ (70%)'),
                _buildDoshaText('Kapha', '████████░░░░░░░░░░░░ (35%)'),
                pw.SizedBox(height: 24),

                // Medicines
                _buildSectionTitle('Prescribed Medicines'),
                pw.SizedBox(height: 12),
                _buildMedicineItem(
                  'Ashwagandha:',
                  '500 mg twice daily after meals',
                ),
                _buildMedicineItem(
                  'Triphala:',
                  '1 tsp with warm water at night',
                ),
                _buildMedicineItem(
                  'Brahmi Ghrita:',
                  '1 tsp morning on empty stomach',
                ),
                pw.SizedBox(height: 24),

                // Recommendations
                _buildSectionTitle('Recommendations'),
                pw.SizedBox(height: 12),
                _buildMedicineItem(
                  'Pathya:',
                  'Warm cooked foods, gentle exercise',
                ),
                _buildMedicineItem(
                  'Apathya:',
                  'Cold drinks, late nights, spicy foods',
                ),
                pw.SizedBox(height: 24),

                // Follow up
                _buildSectionTitle('Follow up'),
                pw.SizedBox(height: 8),
                pw.Text(
                  'Next follow up: 16 March 2026',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 48),

                // Signature
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Dr. Joseph',
                          style: pw.TextStyle(
                            fontSize: 24,
                            fontStyle: pw.FontStyle.italic,
                            color: const PdfColor.fromInt(0xFF2E4F4F),
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          'Vaidya Joseph · 03 Mar 2026',
                          style: const pw.TextStyle(color: PdfColors.grey600),
                        ),
                      ],
                    ),
                    pw.Container(
                      width: 50,
                      height: 50,
                      decoration: pw.BoxDecoration(
                        shape: pw.BoxShape.circle,
                        border: pw.Border.all(
                          color: const PdfColor.fromInt(0xFFD4A84B),
                          width: 2,
                        ),
                      ),
                      child: pw.Center(
                        child: pw.Text(
                          'SEAL',
                          style: pw.TextStyle(
                            color: const PdfColor.fromInt(0xFFD4A84B),
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildSectionTitle(String title) {
    return pw.Text(
      title,
      style: pw.TextStyle(
        fontSize: 16,
        fontWeight: pw.FontWeight.bold,
        color: const PdfColor.fromInt(0xFF2E4F4F),
      ),
    );
  }

  static pw.Widget _buildDoshaText(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 60,
            child: pw.Text(
              label,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Text(value, style: const pw.TextStyle(color: PdfColors.grey700)),
        ],
      ),
    );
  }

  static pw.Widget _buildMedicineItem(String name, String dosage) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            '$name ',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          pw.Expanded(child: pw.Text(dosage)),
        ],
      ),
    );
  }
}
