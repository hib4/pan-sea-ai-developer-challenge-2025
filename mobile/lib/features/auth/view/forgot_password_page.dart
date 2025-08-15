import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kanca/core/core.dart';
import 'package:kanca/gen/assets.gen.dart';
import 'package:kanca/utils/extensions/extensions.dart';
import 'package:kanca/widgets/widgets.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetEmail() async {
    setState(() => _isLoading = true);
    final email = _emailController.text.trim();

    // Simulate API call
    await Future<void>.delayed(const Duration(seconds: 1));

    // TODO: Implement actual password reset API call with email
    if (email.isNotEmpty) {
      setState(() {
        _isLoading = false;
        _emailSent = true;
      });
    }
  }

  Future<void> _resendEmail() async {
    setState(() => _isLoading = true);

    // Simulate API call
    await Future<void>.delayed(const Duration(seconds: 1));

    setState(() => _isLoading = false);

    // Show success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reset email sent again!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _goBack() {
    Navigator.of(context).pop();
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
                  flex: 10,
                  child: Center(
                    child: Text(
                      'FORGOT\nPASSWORD',
                      textAlign: TextAlign.center,
                      style: textTheme.h1.copyWith(
                        color: Colors.white,
                        fontSize: 80,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 9,
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
                        if (!_emailSent) ...[
                          12.vertical,
                          Text(
                            "Don't worry! It happens. Please enter the email address associated with your account.",
                            style: textTheme.largeBody.copyWith(
                              color: colors.grey[500],
                              fontSize: 14,
                            ),
                          ),
                          24.vertical,
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
                          32.vertical,
                          ElevatedButton(
                            onPressed: _isLoading ? null : _sendResetEmail,
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Text('Send Reset Link'),
                          ),
                        ] else ...[
                          Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.email_outlined,
                                  size: 64,
                                  color: colors.primary[500],
                                ),
                                16.vertical,
                                Text(
                                  'Check your email',
                                  style: textTheme.h4.copyWith(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                8.vertical,
                                Text(
                                  'We have sent a password reset link to',
                                  style: textTheme.body.copyWith(
                                    color: colors.grey[500],
                                    fontSize: 14,
                                  ),
                                ),
                                4.vertical,
                                Text(
                                  _emailController.text.trim(),
                                  style: textTheme.body.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                32.vertical,
                                ElevatedButton(
                                  onPressed: _goBack,
                                  child: const Text('Back to Login'),
                                ),
                                16.vertical,
                                TextButton(
                                  onPressed: _isLoading ? null : _resendEmail,
                                  child: _isLoading
                                      ? const SizedBox(
                                          height: 16,
                                          width: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Text(
                                          "Didn't receive the email? Resend",
                                          style: textTheme.lexendCaption
                                              .copyWith(
                                                color: colors.primary[500],
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const Spacer(),
                        if (!_emailSent) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Remember your password?',
                                style: textTheme.caption.copyWith(
                                  fontSize: 14,
                                ),
                              ),
                              4.horizontal,
                              InkWell(
                                onTap: _goBack,
                                child: Text(
                                  'Back to Login',
                                  style: textTheme.lexendCaption.copyWith(
                                    color: colors.primary[500],
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          16.vertical,
                        ],
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
            top: 325,
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
