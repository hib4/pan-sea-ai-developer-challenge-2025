import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanca/core/core.dart';
import 'package:kanca/data/models/models.dart';
import 'package:kanca/gen/assets.gen.dart';

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
          child: chat.message != 'typingMessage'
              ? Text(
                  chat.message ?? '',
                  style: GoogleFonts.lexend(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                )
              : const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
