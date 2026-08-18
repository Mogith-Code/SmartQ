import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../core/theme/app_theme.dart';
import '../widgets/glass_container.dart';

enum UserRole { customer, staff }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Screen States
  UserRole _selectedRole = UserRole.customer;
  bool _isSignUp = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _rememberMe = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulate Network Request
    await Future.delayed(const Duration(milliseconds: 1800));

    if (!mounted) return;

    setState(() => _isLoading = false);

    final action = _isSignUp ? 'Account created successfully!' : 'Signed in successfully!';
    final roleName = _selectedRole == UserRole.customer ? 'Customer' : 'Counter Staff';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.surfaceLight,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.primaryCyan, width: 1),
        ),
        content: Row(
          children: [
            const Icon(LucideIcons.checkCircle, color: AppColors.primaryCyan, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '$action Welcome ($roleName)',
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showForgotPasswordSheet() {
    final resetController = TextEditingController();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textMuted.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Reset Password',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Enter your email address to receive password reset instructions.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: resetController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(
                hintText: 'Enter your registered email',
                prefixIcon: Icon(LucideIcons.mail, color: AppColors.primaryCyan, size: 20),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: AppColors.surfaceLight,
                      content: Text(
                        'Password reset link sent to ${resetController.text.isEmpty ? "your email" : resetController.text}',
                        style: const TextStyle(color: AppColors.textPrimary),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryCyan,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Send Reset Link',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // -------------------------------------------------------------------
          // Ambient Animated Glow Background Mesh
          // -------------------------------------------------------------------
          Positioned(
            top: -size.height * 0.15,
            right: -size.width * 0.2,
            child: Container(
              width: size.width * 0.8,
              height: size.width * 0.8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primaryCyan.withOpacity(0.25),
                    AppColors.accentPurple.withOpacity(0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ).animate(onPlay: (controller) => controller.repeat(reverse: true))
           .scale(duration: 4.seconds, begin: const Offset(0.9, 0.9), end: const Offset(1.1, 1.1)),

          Positioned(
            bottom: -size.height * 0.1,
            left: -size.width * 0.2,
            child: Container(
              width: size.width * 0.85,
              height: size.width * 0.85,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.accentPurple.withOpacity(0.25),
                    AppColors.primaryBlue.withOpacity(0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ).animate(onPlay: (controller) => controller.repeat(reverse: true))
           .scale(duration: 5.seconds, begin: const Offset(1.0, 1.0), end: const Offset(1.25, 1.25)),

          // -------------------------------------------------------------------
          // Main Body Content
          // -------------------------------------------------------------------
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 12),

                      // 1. Logo & SmartQ Header
                      _buildHeaderSection(),

                      const SizedBox(height: 28),

                      // 2. User Role Switcher (Customer vs Staff)
                      _buildRoleSelector(),

                      const SizedBox(height: 20),

                      // 3. Auth Form Glass Card
                      GlassContainer(
                        borderRadius: 28,
                        padding: const EdgeInsets.all(28),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Auth Mode Switcher (Sign In vs Register)
                              _buildAuthTabSwitcher(),

                              const SizedBox(height: 24),

                              // Register Full Name Field
                              if (_isSignUp) ...[
                                _buildTextField(
                                  controller: _nameController,
                                  label: 'Full Name',
                                  hint: 'John Doe',
                                  icon: LucideIcons.user,
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) {
                                      return 'Please enter your full name';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                              ],

                              // Email / Phone Field
                              _buildTextField(
                                controller: _emailController,
                                label: 'Email or Mobile',
                                hint: 'name@example.com',
                                icon: LucideIcons.mail,
                                keyboardType: TextInputType.emailAddress,
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return 'Please enter your email or mobile';
                                  }
                                  if (!_isSignUp && !v.contains('@') && v.length < 10) {
                                    return 'Enter a valid email or phone number';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 16),

                              // Password Field
                              _buildTextField(
                                controller: _passwordController,
                                label: 'Password',
                                hint: '••••••••',
                                icon: LucideIcons.lock,
                                obscureText: _obscurePassword,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword ? LucideIcons.eyeOff : LucideIcons.eye,
                                    color: AppColors.textSecondary,
                                    size: 18,
                                  ),
                                  onPressed: () {
                                    setState(() => _obscurePassword = !_obscurePassword);
                                  },
                                ),
                                validator: (v) {
                                  if (v == null || v.isEmpty) {
                                    return 'Please enter password';
                                  }
                                  if (_isSignUp && v.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                              ),

                              // Confirm Password Field (Only for Sign Up)
                              if (_isSignUp) ...[
                                const SizedBox(height: 16),
                                _buildTextField(
                                  controller: _confirmPasswordController,
                                  label: 'Confirm Password',
                                  hint: '••••••••',
                                  icon: LucideIcons.shieldCheck,
                                  obscureText: _obscureConfirmPassword,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureConfirmPassword ? LucideIcons.eyeOff : LucideIcons.eye,
                                      color: AppColors.textSecondary,
                                      size: 18,
                                    ),
                                    onPressed: () {
                                      setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                                    },
                                  ),
                                  validator: (v) {
                                    if (v != _passwordController.text) {
                                      return 'Passwords do not match';
                                    }
                                    return null;
                                  },
                                ),
                              ],

                              const SizedBox(height: 14),

                              // Remember Me & Forgot Password Row
                              if (!_isSignUp) _buildOptionsRow(),

                              const SizedBox(height: 24),

                              // Primary Action CTA Button
                              _buildSubmitButton(),

                              const SizedBox(height: 24),

                              // Social Divider
                              _buildDivider(),

                              const SizedBox(height: 20),

                              // Social Login Buttons
                              _buildSocialButtons(),
                            ],
                          ),
                        ),
                      ).animate().fade(duration: 600.ms, delay: 200.ms).slideY(begin: 0.1, end: 0),

                      const SizedBox(height: 24),

                      // 4. Quick Guest Access Button
                      _buildGuestAccessButton(),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Widget Components
  // ---------------------------------------------------------------------------

  Widget _buildHeaderSection() {
    return Column(
      children: [
        // Glowing Logo Badge
        Container(
          width: 72,
          height: 72,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.primaryGradient,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryCyan.withOpacity(0.4),
                blurRadius: 24,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              LucideIcons.qrCode,
              color: Colors.black,
              size: 34,
            ),
          ),
        ).animate()
         .scale(duration: 600.ms, curve: Curves.easeOutBack)
         .shimmer(delay: 800.ms, duration: 1500.ms),

        const SizedBox(height: 16),

        // Brand Title
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds),
              child: Text(
                'SmartQ',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 34,
                  fontWeight: FontWeight.extrabold,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.primaryCyan.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primaryCyan.withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.sparkles, color: AppColors.primaryCyan, size: 12),
                  const SizedBox(width: 4),
                  Text(
                    'AI 2.0',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryCyan,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ).animate().fade(duration: 500.ms, delay: 100.ms),

        const SizedBox(height: 6),

        // Tagline
        Text(
          'Smart Virtual Queue & Real-Time Booking',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ).animate().fade(duration: 500.ms, delay: 150.ms),
      ],
    );
  }

  Widget _buildRoleSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildRoleChip(
              role: UserRole.customer,
              title: 'Customer',
              icon: LucideIcons.users,
            ),
          ),
          Expanded(
            child: _buildRoleChip(
              role: UserRole.staff,
              title: 'Counter Staff',
              icon: LucideIcons.badgeCheck,
            ),
          ),
        ],
      ),
    ).animate().fade(duration: 500.ms, delay: 200.ms);
  }

  Widget _buildRoleChip({
    required UserRole role,
    required String title,
    required IconData icon,
  }) {
    final isSelected = _selectedRole == role;
    return GestureDetector(
      onTap: () => setState(() => _selectedRole = role),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surfaceLight : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: AppColors.primaryCyan.withOpacity(0.5))
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? AppColors.primaryCyan : AppColors.textMuted,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppColors.textPrimary : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthTabSwitcher() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isSignUp = false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: !_isSignUp ? AppColors.primaryCyan : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    'Sign In',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: !_isSignUp ? Colors.black : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isSignUp = true),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: _isSignUp ? AppColors.primaryCyan : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    'Register',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _isSignUp ? Colors.black : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          style: GoogleFonts.plusJakartaSans(color: AppColors.textPrimary, fontSize: 15),
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 18),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }

  Widget _buildOptionsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: _rememberMe,
                activeColor: AppColors.primaryCyan,
                checkColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                side: const BorderSide(color: AppColors.textMuted, width: 1.5),
                onChanged: (val) {
                  if (val != null) setState(() => _rememberMe = val);
                },
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Remember me',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: _showForgotPasswordSheet,
          child: Text(
            'Forgot Password?',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryCyan,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: AppColors.buttonGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryCyan.withOpacity(0.35),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _isLoading
            ? const SpinKitThreeBounce(
                color: Colors.black,
                size: 20,
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isSignUp ? 'Create SmartQ Account' : 'Sign In to SmartQ',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(LucideIcons.arrowRight, color: Colors.black, size: 20),
                ],
              ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: AppColors.glassBorder, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textMuted,
            ),
          ),
        ),
        Expanded(child: Divider(color: AppColors.glassBorder, thickness: 1)),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildSocialCard(
            label: 'Google',
            icon: LucideIcons.chrome,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Google Authentication initiated...')),
              );
            },
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _buildSocialCard(
            label: 'Apple ID',
            icon: LucideIcons.apple,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Apple ID Authentication initiated...')),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSocialCard({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.inputFill,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.textPrimary, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestAccessButton() {
    return TextButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.surfaceLight,
            content: Text(
              'Entering SmartQ Virtual Queue as Guest...',
              style: GoogleFonts.plusJakartaSans(color: AppColors.primaryCyan),
            ),
          ),
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(LucideIcons.ticket, color: AppColors.textSecondary, size: 16),
          const SizedBox(width: 8),
          Text(
            'Join Queue as Quick Guest',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    ).animate().fade(duration: 500.ms, delay: 300.ms);
  }
}
