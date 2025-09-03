import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kanca/core/core.dart';
import 'package:kanca/features/dashboard/dashboard.dart';
import 'package:kanca/gen/assets.gen.dart';
import 'package:kanca/l10n/l10n.dart';
import 'package:kanca/utils/extensions/extensions.dart';
import 'package:kanca/widgets/widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _goToLogin() {
    Navigator.of(context).pop();
  }

  Future<void> _register() async {
    setState(() => _isLoading = true);
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    await context.pushAndRemoveUntil(
      const DashboardPage(),
      (route) => false,
    );

    setState(() => _isLoading = false);
  }

  Future<void> _registerWithGoogle() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colors.primary[500],
      body: Stack(
        children: [
          Center(
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      l10n.registerTitle,
                      style: textTheme.h1.copyWith(
                        color: Colors.white,
                        fontSize: 90,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
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
                          l10n.emailText,
                          style: textTheme.caption,
                        ),
                        4.vertical,
                        KancaTextField(
                          controller: _emailController,
                          textInputType: TextInputType.emailAddress,
                          label: l10n.emailLabel,
                        ),
                        16.vertical,
                        Text(
                          l10n.passwordText,
                          style: textTheme.caption,
                        ),
                        4.vertical,
                        KancaTextField(
                          controller: _passwordController,
                          textInputType: TextInputType.visiblePassword,
                          label: l10n.passwordLabel,
                          isPassword: true,
                        ),
                        16.vertical,
                        Text(
                          l10n.confirmPasswordText,
                          style: textTheme.caption,
                        ),
                        4.vertical,
                        KancaTextField(
                          controller: _confirmPasswordController,
                          textInputType: TextInputType.visiblePassword,
                          label: l10n.confirmPasswordLabel,
                          isPassword: true,
                        ),
                        32.vertical,
                        ElevatedButton(
                          onPressed: _register,
                          child: Text(l10n.startNowButton),
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
                                l10n.orText,
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
                          onPressed: _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Colors.black.withOpacity(0.1),
                              ),
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Assets.icons.google.svg(
                                width: 24,
                                height: 24,
                              ),
                              10.horizontal,
                              Text(l10n.continueWithGoogleButton),
                            ],
                          ),
                        ),
                        32.vertical,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              l10n.alreadyHaveAccountText,
                              style: textTheme.lexendCaption.copyWith(
                                fontSize: 14,
                              ),
                            ),
                            4.horizontal,
                            InkWell(
                              onTap: _goToLogin,
                              child: Text(
                                l10n.loginNowText,
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
                                  TextSpan(
                                    text: l10n.ruleText1,
                                  ),
                                  TextSpan(
                                    text: l10n.ruleText2,
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
                                  TextSpan(
                                    text: l10n.ruleText3,
                                  ),
                                  TextSpan(
                                    text: l10n.ruleText4,
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
            top: 145,
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
