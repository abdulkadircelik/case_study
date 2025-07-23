import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/di/injection.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/social_login_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../domain/models/login_request_model.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  late final AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = getIt<AuthBloc>();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _authBloc.close();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _handleLogin() {
    if (!_formKey.currentState!.validate()) return;

    final request = LoginRequestModel(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    _authBloc.add(LoginRequested(request));
  }

  void _handleSocialLogin(String provider) {
    // TODO: Implement social login
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$provider ile giriş yapılıyor...'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  void _handleForgotPassword() {
    // TODO: Navigate to forgot password page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Şifre sıfırlama sayfasına yönlendiriliyorsunuz...'),
      ),
    );
  }

  void _handleRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      bloc: _authBloc,
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('auth.login_success'.tr()),
              backgroundColor: Colors.green,
            ),
          );
          // Navigate to home page
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
                (route) => false,
              );
            }
          });
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 60),

                  // Welcome Text
                  Text(
                    'auth.welcome'.tr(),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.3),

                  const SizedBox(height: 16),

                  Text(
                        'auth.welcome_subtitle'.tr(),
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
                      .fadeIn(delay: 400.ms, duration: 600.ms)
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
                      .fadeIn(delay: 600.ms, duration: 600.ms)
                      .slideX(begin: -0.3),

                  const SizedBox(height: 16),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: _handleForgotPassword,
                      child: Text(
                        'auth.forgot_password'.tr(),
                        style: const TextStyle(
                          color: AppTheme.textPrimaryColor,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 800.ms, duration: 600.ms),

                  const SizedBox(height: 24),

                  // Login Button
                  BlocBuilder<AuthBloc, AuthState>(
                        bloc: _authBloc,
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: state is AuthLoading
                                ? null
                                : _handleLogin,
                            child: state is AuthLoading
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
                                : Text('auth.login'.tr()),
                          );
                        },
                      )
                      .animate()
                      .fadeIn(delay: 1000.ms, duration: 600.ms)
                      .slideY(begin: 0.3),

                  const SizedBox(height: 32),

                  // Social Login
                  Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SocialLoginButton(
                            icon: FontAwesomeIcons.google,
                            onPressed: () => _handleSocialLogin('Google'),
                          ),
                          SocialLoginButton(
                            icon: FontAwesomeIcons.apple,
                            onPressed: () => _handleSocialLogin('Apple'),
                          ),
                          SocialLoginButton(
                            icon: FontAwesomeIcons.facebook,
                            onPressed: () => _handleSocialLogin('Facebook'),
                          ),
                        ],
                      )
                      .animate()
                      .fadeIn(delay: 1200.ms, duration: 600.ms)
                      .slideY(begin: 0.3),

                  const SizedBox(height: 32),

                  // Register Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'auth.no_account'.tr(),
                        style: const TextStyle(
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                      TextButton(
                        onPressed: _handleRegister,
                        child: Text(
                          'auth.register'.tr(),
                          style: const TextStyle(
                            color: AppTheme.textPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 1400.ms, duration: 600.ms),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
