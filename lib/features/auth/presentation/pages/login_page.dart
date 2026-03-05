import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../cubit/auth_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppColors.gradientBackground,
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              context.go('/home');
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    // Logo
                    _buildLogo(),
                    const SizedBox(height: 24),
                    // Brand name
                    Text(
                      'AYUTRACE',
                      style: AppTypography.brandTitle.copyWith(
                        color: AppColors.brandTitle,
                        letterSpacing: 6,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Welcome text — dark sage green
                    Text(
                      'Welcome Back',
                      style: GoogleFonts.dancingScript(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkSageGreen,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Sign in to continue in your wellness journey',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.italic,
                        color: AppColors.darkSageGreen.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 48),
                    // Email field — cream bg
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: AppColors.primary,
                        ),
                        filled: true,
                        fillColor: AppColors.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Password field — cream bg
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: Icon(
                          Icons.keyboard_outlined,
                          color: AppColors.primary,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textHint,
                          ),
                          onPressed: () {
                            setState(
                              () => _obscurePassword = !_obscurePassword,
                            );
                          },
                        ),
                        filled: true,
                        fillColor: AppColors.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Forgot password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'Forgot Password?',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Sign In button — teal with white text
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return SizedBox(
                          width: 200,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: state is AuthLoading
                                ? null
                                : () {
                                    context.read<AuthCubit>().login(
                                      email: _emailController.text.trim(),
                                      password: _passwordController.text.trim(),
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.textOnPrimary,
                              elevation: 4,
                              shadowColor: AppColors.primaryDark.withValues(
                                alpha: 0.3,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: state is AuthLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    'SIGN IN',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 2,
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                    // Divider
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.white.withValues(alpha: 0.4),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            '',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.white.withValues(alpha: 0.4),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Sign Up link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't Have an Account?  ",
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.darkSageGreen,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.go('/signup'),
                          child: Text(
                            'Sign Up',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
      ),
      child: CustomPaint(painter: _LogoPainter(), size: const Size(140, 140)),
    );
  }
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Shield outline — dark teal
    final shieldPaint = Paint()
      ..color = AppColors.primaryDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final shieldPath = Path();
    shieldPath.moveTo(center.dx, center.dy - 55);
    shieldPath.lineTo(center.dx + 45, center.dy - 35);
    shieldPath.lineTo(center.dx + 45, center.dy + 10);
    shieldPath.quadraticBezierTo(
      center.dx + 40,
      center.dy + 45,
      center.dx,
      center.dy + 60,
    );
    shieldPath.quadraticBezierTo(
      center.dx - 40,
      center.dy + 45,
      center.dx - 45,
      center.dy + 10,
    );
    shieldPath.lineTo(center.dx - 45, center.dy - 35);
    shieldPath.close();
    canvas.drawPath(shieldPath, shieldPaint);

    // Inner shield
    final innerShieldPath = Path();
    innerShieldPath.moveTo(center.dx, center.dy - 45);
    innerShieldPath.lineTo(center.dx + 35, center.dy - 28);
    innerShieldPath.lineTo(center.dx + 35, center.dy + 5);
    innerShieldPath.quadraticBezierTo(
      center.dx + 30,
      center.dy + 35,
      center.dx,
      center.dy + 48,
    );
    innerShieldPath.quadraticBezierTo(
      center.dx - 30,
      center.dy + 35,
      center.dx - 35,
      center.dy + 5,
    );
    innerShieldPath.lineTo(center.dx - 35, center.dy - 28);
    innerShieldPath.close();
    canvas.drawPath(innerShieldPath, shieldPaint);

    // Pill (capsule) shape — teal
    final pillPaint = Paint()
      ..color = AppColors.primaryDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.save();
    canvas.translate(center.dx - 12, center.dy);
    canvas.rotate(-0.5);
    final pillRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset.zero, width: 18, height: 40),
      const Radius.circular(9),
    );
    canvas.drawRRect(pillRect, pillPaint);
    canvas.drawLine(const Offset(-9, 0), const Offset(9, 0), pillPaint);
    canvas.restore();

    // Leaf shape — green
    final leafPaint = Paint()
      ..color = AppColors.success
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final leafPath = Path();
    leafPath.moveTo(center.dx + 8, center.dy + 12);
    leafPath.quadraticBezierTo(
      center.dx + 30,
      center.dy - 15,
      center.dx + 15,
      center.dy - 25,
    );
    leafPath.quadraticBezierTo(
      center.dx - 2,
      center.dy - 12,
      center.dx + 8,
      center.dy + 12,
    );
    canvas.drawPath(leafPath, leafPaint);

    // Leaf stem
    canvas.drawLine(
      Offset(center.dx + 8, center.dy + 12),
      Offset(center.dx + 18, center.dy - 12),
      leafPaint,
    );

    // Circuit dots — small teal circles on shield
    final dotPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    // Three circuit dots on right side
    canvas.drawCircle(Offset(center.dx + 20, center.dy + 10), 2.5, dotPaint);
    canvas.drawCircle(Offset(center.dx + 25, center.dy + 20), 2.5, dotPaint);
    canvas.drawCircle(Offset(center.dx + 15, center.dy + 25), 2.5, dotPaint);

    // Connecting lines for circuit dots
    final circuitPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawLine(
      Offset(center.dx + 20, center.dy + 10),
      Offset(center.dx + 25, center.dy + 20),
      circuitPaint,
    );
    canvas.drawLine(
      Offset(center.dx + 25, center.dy + 20),
      Offset(center.dx + 15, center.dy + 25),
      circuitPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
