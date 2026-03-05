import 'package:ayutrace/features/home/utils/prescription_pdf_generator.dart';
import 'package:ayutrace/services/ai_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:printing/printing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../cubit/home_cubit.dart';
import '../widgets/action_card.dart';
import '../widgets/product_grid_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchController = TextEditingController();

  // ORDER VARIABLES
  int _ashwaQty = 0;
  int _triphalaQty = 0;
  int _brahmiQty = 0;
  bool _isOrderPlaced = false;

  // AI VARIABLES
  final AIService _aiService = AIService();
  String _aiResponse = "No response yet";
  bool _isLoadingAI = false;
  final TextEditingController _aiQuestionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _aiQuestionController.dispose();
    super.dispose();
  }

  Future<void> _callAI() async {
    if (_aiQuestionController.text.trim().isEmpty) return;

    setState(() {
      _isLoadingAI = true;
    });

    final mockProducts = [
      {
        'name': 'Ashwagandha Churna',
        'ingredients': '100% Organic Ashwagandha Root Powder',
        'benefits': 'Reduces stress, improves sleep, and boosts energy levels.',
        'dosage': '1 teaspoon twice daily with warm milk',
      },
      {
        'name': 'Triphala Juice',
        'ingredients': 'Amla, Haritaki, Bahera',
        'benefits': 'Improves digestion, flushes toxins, and boosts immunity.',
        'dosage': '30ml with equal water before bedtime',
      },
    ];

    final String activePrescription = mockProducts
        .map((p) => "- ${p['name']}: ${p['dosage']}")
        .join('\\n');

    final result = await _aiService.askAboutProducts(
      userQuestion:
          "${_aiQuestionController.text}\\n\\n[SYSTEM NOTE: The user has an active prescription:\\n$activePrescription]",
      products: mockProducts,
      role: 'customer',
    );

    setState(() {
      _aiResponse = result ?? "No response";
      _isLoadingAI = false;
    });
  }

  // ── ELABORATE PRESCRIPTION OVERLAY ────────────────────────────
  void _showPrescriptionOverlay(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.95,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: AppColors.surface, // cream
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                // Header row
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back,
                        color: AppColors.darkSageGreen,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Ayurvedic Prescription',
                        style: AppTypography.headlineSmall.copyWith(
                          color: AppColors.darkSageGreen,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.primary,
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // ── Doctor card ───────────────────────
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColors.primaryLight.withValues(
                          alpha: 0.3,
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 36,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Joseph Criston',
                              style: AppTypography.titleLarge.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Consulted on 3 March 2026',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.darkSageGreen,
                              ),
                            ),
                            Text(
                              'RX-ID: AYU 2026-03-02',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.darkSageGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ── Patient info ─────────────────────
                _sectionTitle('Patient info'),
                const SizedBox(height: 8),
                Text(
                  'Saima . 34 . Pitta-Vata Prakruti',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.darkSageGreen,
                  ),
                ),
                const SizedBox(height: 20),

                // ── Dosha Balance ─────────────────────
                _sectionTitle('Dosha Balance'),
                const SizedBox(height: 12),
                _buildDoshaBar('Vata', 0.55, AppColors.primary),
                const SizedBox(height: 10),
                _buildDoshaBar('Pitta', 0.70, AppColors.primaryLight),
                const SizedBox(height: 10),
                _buildDoshaBar('Kapha', 0.35, AppColors.primaryDark),
                const SizedBox(height: 24),

                // ── Prescribed Medicines ─────────────
                _sectionTitle('Prescribed Medicines'),
                const SizedBox(height: 12),
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
                const SizedBox(height: 24),

                // ── Recommendations ──────────────────
                _sectionTitle('Recommendations'),
                const SizedBox(height: 12),
                _buildRecommendationRow(
                  'Pathya:',
                  'Warm cooked foods, gentle exercise',
                ),
                const SizedBox(height: 6),
                _buildRecommendationRow(
                  'Apathya:',
                  'Cold drinks, late nights, spicy foods',
                ),
                const SizedBox(height: 24),

                // ── Follow ups ───────────────────────
                _sectionTitle('Follow ups'),
                const SizedBox(height: 8),
                Text(
                  'Next follow up: 16 March 2026',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 28),

                // ── Signature & Seal ─────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dr. Joseph',
                            style: GoogleFonts.dancingScript(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              color: AppColors.darkSageGreen,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Vaidya Joseph · 03 Mar 2026',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.textHint,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Official seal
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFFD4A84B),
                            const Color(0xFFC49030),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFFD4A84B,
                            ).withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.verified,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // ── Bottom buttons ───────────────────
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final pdfBytes =
                              await PrescriptionPdfGenerator.generatePrescription();
                          await Printing.layoutPdf(
                            onLayout: (format) => pdfBytes,
                            name: 'ayurvedic_prescription.pdf',
                          );
                        },
                        icon: const Icon(Icons.download, size: 18),
                        label: const Text('DOWNLOAD PDF'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context); // close prescription sheet
                          _showRemindersBottomSheet(context);
                        },
                        icon: const Icon(Icons.alarm, size: 18),
                        label: const Text('SET REMINDERS'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryDark,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Prescription helper widgets ──────────────────────────────
  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: AppTypography.titleMedium.copyWith(
        color: AppColors.darkSageGreen,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildDoshaBar(String label, double fraction, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.darkSageGreen,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: fraction,
            minHeight: 10,
            backgroundColor: AppColors.divider.withValues(alpha: 0.3),
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }

  Widget _buildMedicineItem(String name, String dosage) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.darkSageGreen,
          ),
          children: [
            TextSpan(
              text: '$name ',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            TextSpan(text: dosage),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationRow(String label, String value) {
    return RichText(
      text: TextSpan(
        style: AppTypography.bodyMedium.copyWith(
          color: AppColors.darkSageGreen,
        ),
        children: [
          TextSpan(
            text: '$label ',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }

  // ── REMINDERS BOTTOM SHEET ─────────────────────────────────────
  void _showRemindersBottomSheet(BuildContext context) {
    // Simple state variables for the mocked times
    TimeOfDay ashwagandhaTime = const TimeOfDay(hour: 8, minute: 0); // 8:00 AM
    TimeOfDay ashwagandhaTime2 = const TimeOfDay(
      hour: 20,
      minute: 0,
    ); // 8:00 PM
    TimeOfDay triphalaTime = const TimeOfDay(hour: 21, minute: 30); // 9:30 PM
    TimeOfDay brahmiTime = const TimeOfDay(hour: 7, minute: 0); // 7:00 AM

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            Future<void> selectTime(
              TimeOfDay initial,
              Function(TimeOfDay) onSelected,
            ) async {
              final TimeOfDay? picked = await showTimePicker(
                context: context,
                initialTime: initial,
                builder: (BuildContext context, Widget? child) {
                  return Theme(
                    data: ThemeData.light().copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: AppColors.primary,
                        onPrimary: Colors.white,
                        surface: Colors.white,
                        onSurface: AppColors.darkSageGreen,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null) {
                setModalState(() {
                  onSelected(picked);
                });
              }
            }

            Widget buildTimePickerTile(
              String title,
              TimeOfDay time,
              Function(TimeOfDay) onChanged,
            ) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.divider.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.darkSageGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => selectTime(time, onChanged),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          time.format(context),
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          color: AppColors.divider,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.alarm,
                          color: AppColors.primaryDark,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Set Reminders',
                          style: AppTypography.headlineSmall.copyWith(
                            color: AppColors.darkSageGreen,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Set daily alarms for your prescribed medicines.',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textHint,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Ashwagandha (Twice daily)
                    Text(
                      'Ashwagandha (500mg twice daily)',
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.darkSageGreen,
                      ),
                    ),
                    const SizedBox(height: 8),
                    buildTimePickerTile(
                      'Morning Dose',
                      ashwagandhaTime,
                      (t) => ashwagandhaTime = t,
                    ),
                    buildTimePickerTile(
                      'Evening Dose',
                      ashwagandhaTime2,
                      (t) => ashwagandhaTime2 = t,
                    ),

                    const SizedBox(height: 12),

                    // Triphala (Night)
                    Text(
                      'Triphala (1 tsp at night)',
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.darkSageGreen,
                      ),
                    ),
                    const SizedBox(height: 8),
                    buildTimePickerTile(
                      'Night Dose',
                      triphalaTime,
                      (t) => triphalaTime = t,
                    ),

                    const SizedBox(height: 12),

                    // Brahmi (Morning)
                    Text(
                      'Brahmi Ghrita (1 tsp morning)',
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.darkSageGreen,
                      ),
                    ),
                    const SizedBox(height: 8),
                    buildTimePickerTile(
                      'Morning Dose',
                      brahmiTime,
                      (t) => brahmiTime = t,
                    ),

                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Close the sheet
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'Medicine reminders set successfully!',
                              ),
                              backgroundColor: AppColors.primary,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryDark,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'SAVE REMINDERS',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ── ORDER PRODUCTS BOTTOM SHEET ─────────────────────────────────────
  void _showOrderBottomSheet(BuildContext context) {
    // Max quantities based on prescription
    final int ashwaMax = 2;
    final int triphalaMax = 1;
    final int brahmiMax = 1;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            Widget buildCounterTile({
              required String title,
              required String subtitle,
              required int currentQty,
              required int maxQty,
              required Function() onIncrement,
              required Function() onDecrement,
            }) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.divider.withValues(alpha: 0.3),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.darkSageGreen,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textHint,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: (_isOrderPlaced || currentQty <= 0)
                              ? null
                              : onDecrement,
                          icon: const Icon(Icons.remove_circle_outline),
                          color: AppColors.primary,
                          disabledColor: AppColors.divider,
                        ),
                        SizedBox(
                          width: 24,
                          child: Text(
                            '$currentQty',
                            textAlign: TextAlign.center,
                            style: AppTypography.titleMedium.copyWith(
                              color: AppColors.darkSageGreen,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: (_isOrderPlaced || currentQty >= maxQty)
                              ? null
                              : onIncrement,
                          icon: const Icon(Icons.add_circle),
                          color: AppColors.primaryDark,
                          disabledColor: AppColors.divider,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }

            return Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          color: AppColors.divider,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.shopping_bag,
                          color: AppColors.primaryDark,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Order Products',
                          style: AppTypography.headlineSmall.copyWith(
                            color: AppColors.darkSageGreen,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Order medicines directly from your prescription. Quantities are limited to your prescribed dosage.',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textHint,
                      ),
                    ),
                    const SizedBox(height: 24),

                    buildCounterTile(
                      title: 'Ashwagandha',
                      subtitle: 'Max $ashwaMax for your 500mg daily dosage',
                      currentQty: _ashwaQty,
                      maxQty: ashwaMax,
                      onDecrement: () {
                        setModalState(() => _ashwaQty--);
                        setState(() {});
                      },
                      onIncrement: () {
                        setModalState(() => _ashwaQty++);
                        setState(() {});
                      },
                    ),
                    buildCounterTile(
                      title: 'Triphala',
                      subtitle: 'Max $triphalaMax for your nightly dosage',
                      currentQty: _triphalaQty,
                      maxQty: triphalaMax,
                      onDecrement: () {
                        setModalState(() => _triphalaQty--);
                        setState(() {});
                      },
                      onIncrement: () {
                        setModalState(() => _triphalaQty++);
                        setState(() {});
                      },
                    ),
                    buildCounterTile(
                      title: 'Brahmi Ghrita',
                      subtitle: 'Max $brahmiMax for your morning dosage',
                      currentQty: _brahmiQty,
                      maxQty: brahmiMax,
                      onDecrement: () {
                        setModalState(() => _brahmiQty--);
                        setState(() {});
                      },
                      onIncrement: () {
                        setModalState(() => _brahmiQty++);
                        setState(() {});
                      },
                    ),

                    const SizedBox(height: 32),
                    if (_isOrderPlaced)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.primary),
                        ),
                        child: Text(
                          'ORDER PLACED',
                          textAlign: TextAlign.center,
                          style: AppTypography.titleMedium.copyWith(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    else
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              (_ashwaQty == 0 &&
                                  _triphalaQty == 0 &&
                                  _brahmiQty == 0)
                              ? null
                              : () {
                                  setModalState(() => _isOrderPlaced = true);
                                  setState(() {});
                                  Navigator.pop(context); // Close the sheet
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text('Order Placed'),
                                      backgroundColor: AppColors.primary,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryDark,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: AppColors.divider
                                .withValues(alpha: 0.5),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'PLACE ORDER',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ══════════════════════════════════════════════════════════════
  // MAIN BUILD
  // ══════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppColors.gradientBackground,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                _buildHeader(context),
                const SizedBox(height: 24),
                _buildActionCards(),
                const SizedBox(height: 20),

                // AI Section
                Text(
                  "Ask the Ayurvedic AI Assistant",
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.darkSageGreen,
                  ),
                ),
                const SizedBox(height: 12),

                TextField(
                  controller: _aiQuestionController,
                  decoration: InputDecoration(
                    hintText: 'Ask about Ashwagandha or Triphala...',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send, color: AppColors.primary),
                      onPressed: _callAI,
                    ),
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 1,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                _isLoadingAI
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      )
                    : Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          _aiResponse,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.darkSageGreen,
                          ),
                        ),
                      ),

                const SizedBox(height: 24),
                _buildSearchBar(),
                const SizedBox(height: 20),
                _buildLabelSection(),
                const SizedBox(height: 16),
                _buildProductGrid(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Welcome!',
            style: AppTypography.headlineMedium.copyWith(
              color: AppColors.darkSageGreen,
            ),
          ),
        ),
        IconButton(
          onPressed: () => _showOrderBottomSheet(context),
          icon: const Icon(
            Icons.shopping_bag_outlined,
            color: AppColors.darkSageGreen,
          ),
        ),
        IconButton(
          onPressed: () {
            context.read<AuthCubit>().logout();
            context.go('/login');
          },
          icon: const Icon(Icons.logout, color: AppColors.darkSageGreen),
        ),
      ],
    );
  }

  Widget _buildActionCards() {
    return Row(
      children: [
        Expanded(
          child: ActionCard(
            icon: Icons.qr_code_scanner,
            label: 'QR Scanner',
            onTap: () {},
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ActionCard(
            icon: Icons.medical_services_outlined,
            label: 'Doctor',
            onTap: () => _showPrescriptionOverlay(context),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      onChanged: (query) {
        context.read<HomeCubit>().searchProducts(query);
      },
      decoration: InputDecoration(
        hintText: 'Search products...',
        prefixIcon: const Icon(Icons.search, color: AppColors.primary),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildLabelSection() {
    return Text(
      "Recent Products",
      style: AppTypography.titleMedium.copyWith(color: AppColors.darkSageGreen),
    );
  }

  Widget _buildProductGrid() {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (state is HomeLoaded) {
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.72,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: state.products.length,
            itemBuilder: (context, index) {
              final product = state.products[index];
              return ProductGridItem(
                product: product,
                onTap: () => context.go('/product/${product.id}'),
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
