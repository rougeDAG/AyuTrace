import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../cubit/product_cubit.dart';
import '../widgets/ayush_license_dialog.dart';
import '../widgets/ai_analytics_card.dart';

class ProductInfoPage extends StatelessWidget {
  final String productId;

  const ProductInfoPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is ProductLoaded) {
            final product = state.product;
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Top bar
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => context.go('/product/$productId'),
                          ),
                          const Spacer(),
                          // AYUSH License button
                          GestureDetector(
                            onTap: () => AyushLicenseDialog.show(
                              context,
                              product.ayushLicense,
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.verified,
                                    color: AppColors.textOnPrimary,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'AYUSH License',
                                    style: AppTypography.labelLarge.copyWith(
                                      color: AppColors.textOnPrimary,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: AppColors.textOnPrimary,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: AppColors.cardBackground,
                            child: Icon(
                              Icons.account_circle_outlined,
                              size: 32,
                              color: AppColors.textHint,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Product image
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          product.imageUrl,
                          height: 250,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                height: 250,
                                color: AppColors.cardBackground,
                                child: Icon(
                                  Icons.local_florist,
                                  size: 80,
                                  color: AppColors.primary.withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // AI Analytics card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: AiAnalyticsCard(
                        analyticsText: product.aiAnalytics,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Chat button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () =>
                              context.go('/product/$productId/chat'),
                          icon: const Icon(Icons.chat_outlined),
                          label: const Text('Chat with AI'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.textOnPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            );
          }

          return const Center(child: Text('Product not found'));
        },
      ),
    );
  }
}
