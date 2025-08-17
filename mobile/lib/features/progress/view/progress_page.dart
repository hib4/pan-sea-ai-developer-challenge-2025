import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanca/core/theme/app_theme.dart';
import 'package:kanca/data/data.dart';
import 'package:kanca/features/progress/widgets/chat_message_widget.dart';
import 'package:kanca/gen/assets.gen.dart';
import 'package:kanca/utils/utils.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  final _scrollController = ScrollController();
  final _messageController = TextEditingController();
  final List<ChatModel> _conversations = [];

  final List<List<String>> _suggestions = [
    [
      'Today’s Target',
      'Did the child complete their mission?',
    ],
    [
      'View Progress',
      'Summary of the child’s activities today',
    ],
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialMessages();
  }

  void _loadInitialMessages() {
    _conversations.add(
      const ChatModel(
        message:
            'Hello! Kanca here—I accompanied your child while playing and learning today. Would you like to know what they learned? ✨',
        isAnswer: true,
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _onSendResult(String text) async {
    if (text.isEmpty) return;

    // add user message
    _addMessage(text, false);

    // show typing indicator
    _addMessage('typingMessage', true);

    // Simulate AI response delay
    await Future<void>.delayed(const Duration(seconds: 2));

    // Remove typing indicator
    _removeTyping();

    // Add AI response (dummy response for now)
    final responses = [
      'Thank you for your question! Your child has shown good progress in learning today. 😊',
      'I understand your concern. Based on today’s observation, your child showed enthusiasm for learning.',
      'That’s a great question! Your child completed several activities well today.',
      'I’m glad you asked! Your child’s cognitive development showed positive results today.',
    ];

    final randomResponse =
        responses[DateTime.now().millisecond % responses.length];
    _addMessage(randomResponse, true);
  }

  void _addMessage(String msg, bool isAnswer) {
    setState(() {
      _conversations.add(
        ChatModel(message: msg, isAnswer: isAnswer),
      );
    });
    // Add a small delay to ensure the widget is built before scrolling
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _removeTyping() {
    setState(() {
      _conversations.removeWhere((m) => m.message == 'typingMessage');
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 24,
              top: MediaQuery.of(context).padding.top,
              right: 24,
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    // InkWell(
                    //   onTap: () {
                    //     context.pop();
                    //   },
                    //   borderRadius: BorderRadius.circular(28),
                    //   child: Assets.icons.back.image(
                    //     width: 56,
                    //     height: 56,
                    //   ),
                    // ),
                    SizedBox(
                      height: 48,
                      child: Center(
                        child: Assets.icons.kancaText.image(
                          width: 125,
                          height: 32,
                        ),
                      ),
                    ),
                  ],
                ),
                16.vertical,
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    controller: _scrollController,
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewPadding.bottom + 208,
                    ),
                    itemCount: _conversations.length,
                    itemBuilder: (context, index) => ChatMessageWidget(
                      chat: _conversations[index],
                      isFirst: index == 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  color: colors.neutral[500],
                  child: SizedBox(
                    height: 52,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: _suggestions.length,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemBuilder: (context, index) {
                        final suggestion = _suggestions[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: Material(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              onTap: () {
                                _onSendResult(suggestion[1]);
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      suggestion[0],
                                      style: textTheme.lexendCaption.copyWith(
                                        color: colors.secondary[900],
                                        fontWeight: FontWeight.w500,
                                        height: 1.2,
                                      ),
                                    ),
                                    4.vertical,
                                    Text(
                                      suggestion[1],
                                      style: textTheme.lexendCaption.copyWith(
                                        color: colors.grey[300],
                                        fontWeight: FontWeight.w300,
                                        height: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: 24,
                    top: 24,
                    right: 24,
                    bottom: MediaQuery.of(context).padding.bottom + 24,
                  ),
                  color: Colors.white,
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          label: 'Type here...',
                          controller: _messageController,
                        ),
                      ),
                      12.horizontal,
                      Material(
                        color: colors.primary[500],
                        shape: const CircleBorder(),
                        child: InkWell(
                          onTap: () {
                            final text = _messageController.text.trim();
                            if (text.isNotEmpty) {
                              _onSendResult(text);
                              _messageController.clear();
                            }
                          },
                          borderRadius: BorderRadius.circular(24),
                          child: Container(
                            width: 48,
                            height: 48,
                            padding: const EdgeInsets.all(12),
                            child: Assets.icons.send.svg(
                              width: 24,
                              height: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    required this.label,
    required this.controller,
    this.textInputType = TextInputType.text,
    this.maxLines = 1,
    this.isPassword = false,
    this.validator,
    this.onChanged,
    super.key,
  });

  final String label;
  final TextInputType textInputType;
  final int maxLines;
  final bool isPassword;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String? Function(String?)? onChanged;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isPasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.textInputType,
      maxLines: widget.maxLines,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: widget.isPassword && _isPasswordVisible,
      autocorrect: !widget.isPassword,
      enableSuggestions: !widget.isPassword,
      onChanged: widget.onChanged,
      style: GoogleFonts.lexend(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        hintText: widget.label,
        hintStyle: GoogleFonts.lexend(
          color: colors.grey[100],
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        errorStyle: GoogleFonts.lexend(
          color: Colors.red,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: Colors.white,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
                icon: _isPasswordVisible
                    ? Assets.icons.eyeSlash.svg()
                    : Assets.icons.eye.svg(),
              )
            : null,
        suffixIconConstraints: const BoxConstraints(
          minHeight: 24,
          maxHeight: 24,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(
            color: colors.grey[50] ?? const Color(0xFFEBEBEB),
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(
            color: colors.primary[500] ?? const Color(0xFFFF9F00),
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
      ),
    );
  }
}
