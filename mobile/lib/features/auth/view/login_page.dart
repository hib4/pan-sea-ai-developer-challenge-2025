import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kanca/core/core.dart';
import 'package:kanca/features/auth/auth.dart';
import 'package:kanca/features/dashboard/dashboard.dart';
import 'package:kanca/gen/assets.gen.dart';
import 'package:kanca/utils/extensions/extensions.dart';
import 'package:kanca/widgets/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() => _isLoading = true);
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    await context.pushAndRemoveUntil(
      const DashboardPage(),
      (route) => false,
    );

    setState(() => _isLoading = false);
  }

  Future<void> _loginWithGoogle() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
  }

  void _goToRegister() {
    context.push(const RegisterPage());
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;
    return Scaffold(
      backgroundColor: colors.primary[500],
      body: Stack(
        children: [
          Center(
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      'LOGIN',
                      style: textTheme.h1.copyWith(
                        color: Colors.white,
                        fontSize: 105,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    decoration: BoxDecoration(
                      color: colors.neutral[500],
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email',
                          style: textTheme.caption,
                        ),
                        4.vertical,
                        KancaTextField(
                          controller: _emailController,
                          textInputType: TextInputType.emailAddress,
                          label: 'example@mail.com',
                        ),
                        16.vertical,
                        Text(
                          'Password',
                          style: textTheme.caption,
                        ),
                        4.vertical,
                        KancaTextField(
                          controller: _passwordController,
                          textInputType: TextInputType.visiblePassword,
                          label: 'Enter your password',
                          isPassword: true,
                        ),
                        12.vertical,
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {},
                            child: Text(
                              'Forgot Password?',
                              style: textTheme.lexendCaption.copyWith(
                                color: colors.primary[500],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        32.vertical,
                        ElevatedButton(
                          onPressed: _login,
                          child: const Text('Continue'),
                        ),
                        16.vertical,
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.black.withOpacity(0.4),
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Text(
                                'Or',
                                style: textTheme.caption,
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.black.withOpacity(0.4),
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                        24.vertical,
                        ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Assets.icons.google.svg(
                                width: 24,
                                height: 24,
                              ),
                              10.horizontal,
                              const Text('Continue with Google'),
                            ],
                          ),
                        ),
                        32.vertical,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don’t have an account?',
                              style: textTheme.caption.copyWith(
                                fontSize: 14,
                              ),
                            ),
                            4.horizontal,
                            InkWell(
                              onTap: _goToRegister,
                              child: Text(
                                'Sign up now!',
                                style: textTheme.lexendCaption.copyWith(
                                  color: colors.primary[500],
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: textTheme.lexendCaption.copyWith(
                                  color: colors.grey[300],
                                  fontSize: 14,
                                ),
                                children: [
                                  const TextSpan(
                                    text: 'By using Kanca, you agree to our ',
                                  ),
                                  TextSpan(
                                    text: 'Terms of Service',
                                    style: textTheme.lexendCaption.copyWith(
                                      fontWeight: FontWeight.w700,
                                      decoration: TextDecoration.underline,
                                      color: Colors.black,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        // TODO: Open Terms of Service link
                                      },
                                  ),
                                  const TextSpan(
                                    text: ' and ',
                                  ),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: textTheme.lexendCaption.copyWith(
                                      fontWeight: FontWeight.w700,
                                      decoration: TextDecoration.underline,
                                      color: Colors.black,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        // TODO: Open Privacy Policy link
                                      },
                                  ),
                                  const TextSpan(
                                    text: '.',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 205,
            left: 0,
            right: 0,
            child: Assets.mascots.auth.image(
              width: 200,
              height: 200,
            ),
          ),
        ],
      ),
    );
  }
}
