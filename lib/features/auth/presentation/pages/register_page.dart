import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/social_login_button.dart';
import 'upload_photo_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isPasswordConfirmVisible = false;
  bool _isAgreementAccepted = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _togglePasswordConfirmVisibility() {
    setState(() {
      _isPasswordConfirmVisible = !_isPasswordConfirmVisible;
    });
  }

  void _toggleAgreement() {
    setState(() {
      _isAgreementAccepted = !_isAgreementAccepted;
    });
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_isAgreementAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('auth.agreement_required'.tr()),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Implement actual register logic
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('auth.register_success'.tr()),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to upload photo page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const UploadPhotoPage()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('auth.register_error'.tr()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handleSocialRegister(String provider) {
    // TODO: Implement social register
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$provider ile kayıt olunuyor...'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  void _handleAgreementLink() {
    // TODO: Navigate to agreement page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kullanıcı sözleşmesi sayfasına yönlendiriliyorsunuz...'),
      ),
    );
  }

  void _handleLogin() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),

                // Welcome Text
                Text(
                  'auth.register_welcome'.tr(),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryColor,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.3),

                const SizedBox(height: 16),

                Text(
                      'auth.register_subtitle'.tr(),
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppTheme.textSecondaryColor,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    )
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 600.ms)
                    .slideY(begin: -0.3),

                const SizedBox(height: 48),

                // Full Name Field
                CustomTextField(
                      controller: _fullNameController,
                      hintText: 'auth.full_name'.tr(),
                      prefixIcon: Icons.person_add_outlined,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'auth.full_name_required'.tr();
                        }
                        return null;
                      },
                    )
                    .animate()
                    .fadeIn(delay: 400.ms, duration: 600.ms)
                    .slideX(begin: -0.3),

                const SizedBox(height: 16),

                // Email Field
                CustomTextField(
                      controller: _emailController,
                      hintText: 'auth.email'.tr(),
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'auth.email_required'.tr();
                        }
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return 'auth.email_invalid'.tr();
                        }
                        return null;
                      },
                    )
                    .animate()
                    .fadeIn(delay: 600.ms, duration: 600.ms)
                    .slideX(begin: -0.3),

                const SizedBox(height: 16),

                // Password Field
                CustomTextField(
                      controller: _passwordController,
                      hintText: 'auth.password'.tr(),
                      prefixIcon: Icons.lock_outlined,
                      obscureText: !_isPasswordVisible,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppTheme.textSecondaryColor,
                        ),
                        onPressed: _togglePasswordVisibility,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'auth.password_required'.tr();
                        }
                        if (value.length < 6) {
                          return 'auth.password_min_length'.tr();
                        }
                        return null;
                      },
                    )
                    .animate()
                    .fadeIn(delay: 800.ms, duration: 600.ms)
                    .slideX(begin: -0.3),

                const SizedBox(height: 16),

                // Password Confirm Field
                CustomTextField(
                      controller: _passwordConfirmController,
                      hintText: 'auth.password_confirm'.tr(),
                      prefixIcon: Icons.lock_outlined,
                      obscureText: !_isPasswordConfirmVisible,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordConfirmVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppTheme.textSecondaryColor,
                        ),
                        onPressed: _togglePasswordConfirmVisibility,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'auth.password_confirm_required'.tr();
                        }
                        if (value != _passwordController.text) {
                          return 'auth.password_mismatch'.tr();
                        }
                        return null;
                      },
                    )
                    .animate()
                    .fadeIn(delay: 1000.ms, duration: 600.ms)
                    .slideX(begin: -0.3),

                const SizedBox(height: 24),

                // Agreement Checkbox
                Row(
                  children: [
                    Checkbox(
                      value: _isAgreementAccepted,
                      onChanged: (value) => _toggleAgreement(),
                      activeColor: AppTheme.primaryColor,
                      checkColor: AppTheme.textPrimaryColor,
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppTheme.textSecondaryColor,
                            height: 1.4,
                          ),
                          children: [
                            TextSpan(
                              text: 'auth.user_agreement'.tr().split(
                                'okudum ve kabul ediyorum',
                              )[0],
                            ),
                            TextSpan(
                              text: 'auth.agreement_link'.tr(),
                              style: const TextStyle(
                                color: AppTheme.textPrimaryColor,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w600,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = _handleAgreementLink,
                            ),
                            TextSpan(
                              text: 'auth.user_agreement'.tr().split(
                                'okudum ve kabul ediyorum',
                              )[1],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 1200.ms, duration: 600.ms),

                const SizedBox(height: 32),

                // Register Button
                ElevatedButton(
                      onPressed: _isLoading ? null : _handleRegister,
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.textPrimaryColor,
                                ),
                              ),
                            )
                          : Text('auth.register_now'.tr()),
                    )
                    .animate()
                    .fadeIn(delay: 1400.ms, duration: 600.ms)
                    .slideY(begin: 0.3),

                const SizedBox(height: 32),

                // Social Register
                Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SocialLoginButton(
                          icon: FontAwesomeIcons.google,
                          onPressed: () => _handleSocialRegister('Google'),
                        ),
                        SocialLoginButton(
                          icon: FontAwesomeIcons.apple,
                          onPressed: () => _handleSocialRegister('Apple'),
                        ),
                        SocialLoginButton(
                          icon: FontAwesomeIcons.facebook,
                          onPressed: () => _handleSocialRegister('Facebook'),
                        ),
                      ],
                    )
                    .animate()
                    .fadeIn(delay: 1600.ms, duration: 600.ms)
                    .slideY(begin: 0.3),

                const SizedBox(height: 32),

                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'auth.has_account'.tr(),
                      style: const TextStyle(
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                    TextButton(
                      onPressed: _handleLogin,
                      child: Text(
                        'auth.login'.tr(),
                        style: const TextStyle(
                          color: AppTheme.textPrimaryColor,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 1800.ms, duration: 600.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
