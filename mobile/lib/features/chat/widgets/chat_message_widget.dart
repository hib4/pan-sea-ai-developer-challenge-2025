import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanca/core/core.dart';
import 'package:kanca/data/models/models.dart';

class ChatMessageWidget extends StatelessWidget {
  const ChatMessageWidget({
    required this.chat,
    this.isFirst = false,
    super.key,
  });

  final ChatModel chat;
  final bool isFirst;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isAnswer = chat.isAnswer ?? false;
    return Padding(
      padding: const EdgeInsets.only(
        top: 12,
        bottom: 12,
      ),
      child: Align(
        alignment: isAnswer ? Alignment.topLeft : Alignment.topRight,
        child: Container(
          margin: isAnswer
              ? const EdgeInsets.only(right: 34)
              : const EdgeInsets.only(left: 34),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: isAnswer ? colors.primary[500] : colors.secondary[800],
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(12),
              topRight: const Radius.circular(12),
              bottomLeft: isAnswer ? Radius.zero : const Radius.circular(12),
              bottomRight: isAnswer ? const Radius.circular(12) : Radius.zero,
            ),
          ),
          child: chat.message != '**typingMessage**'
              ? Text(
                  chat.message ?? '',
                  style: GoogleFonts.lexend(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                )
              : const TypingIndicator(),
        ),
      ),
    );
  }
}

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation =
        Tween<double>(
          begin: 0,
          end: 1,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Kanca is typing',
              style: GoogleFonts.lexend(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(width: 8),
            ...List.generate(3, (index) {
              final delay = index * 0.2;
              final animationValue = (_animation.value - delay).clamp(0.0, 1.0);
              final opacity = (sin(animationValue * pi * 2) + 1) / 2;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(opacity * 0.8 + 0.2),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
