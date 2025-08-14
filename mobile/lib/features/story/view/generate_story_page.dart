import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanca/core/core.dart';
import 'package:kanca/features/story/story.dart';
import 'package:kanca/gen/assets.gen.dart';
import 'package:kanca/utils/extensions/extensions.dart';

class GenerateStoryPage extends StatefulWidget {
  const GenerateStoryPage({super.key});

  @override
  State<GenerateStoryPage> createState() => _GenerateStoryPageState();
}

class _GenerateStoryPageState extends State<GenerateStoryPage> {
  final _textController = TextEditingController();
  int _selectedStory = -1;
  int _selectedMoral = -1;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;

    // Check if user has provided valid input
    final hasTextInput = _textController.text.trim().isNotEmpty;
    final hasStoryAndMoral = _selectedStory != -1 && _selectedMoral != -1;
    final isButtonEnabled = hasTextInput || hasStoryAndMoral;

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 24,
          top: MediaQuery.of(context).padding.top,
          right: 24,
          bottom: 24,
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () {
                  context.pop();
                },
                borderRadius: BorderRadius.circular(28),
                child: Assets.icons.back.image(
                  width: 56,
                  height: 56,
                ),
              ),
            ),
            12.vertical,
            Assets.mascots.thinking.image(
              width: 90,
              height: 120,
            ),
            4.vertical,
            RichText(
              text: TextSpan(
                style: textTheme.h4.copyWith(
                  color: colors.grey[500],
                  fontWeight: FontWeight.w600,
                ),
                text: 'Yuk Buat ',
                children: [
                  TextSpan(
                    text: 'Ceritamu!',
                    style: TextStyle(
                      color: colors.primary[500],
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            24.vertical,
            GenerateStoryTextField(
              label: 'Ketik ide cerita kamu di sini...',
              controller: _textController,
              onChanged: (value) {
                setState(() {
                  // Trigger rebuild when text changes
                });
                return null;
              },
            ),
            16.vertical,
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Atau Pilih Ide Cerita:',
                style: textTheme.lexendLargeBody.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            16.vertical,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Material(
                  color: colors.primary[500],
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedStory = _selectedStory == 0 ? -1 : 0;
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    splashColor: Colors.black.withOpacity(0.2),
                    highlightColor: Colors.black.withOpacity(0.1),
                    child: Container(
                      width: 88,
                      height: 88,
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _selectedStory == 0
                              ? colors.primary[50]
                              : colors.primary[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Assets.icons.school.image(
                              width: 40,
                              height: 40,
                            ),
                            6.vertical,
                            Text(
                              'Sekolah',
                              style: textTheme.lexendBody.copyWith(
                                color: colors.primary[800],
                                fontWeight: FontWeight.w400,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Material(
                  color: colors.secondary[500],
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedStory = _selectedStory == 1 ? -1 : 1;
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    splashColor: Colors.black.withOpacity(0.2),
                    highlightColor: Colors.black.withOpacity(0.1),
                    child: Container(
                      width: 88,
                      height: 88,
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _selectedStory == 1
                              ? colors.secondary[50]
                              : colors.secondary[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Assets.icons.fantasy.image(
                              width: 40,
                              height: 40,
                            ),
                            6.vertical,
                            Text(
                              'Fantasi',
                              style: textTheme.lexendBody.copyWith(
                                color: colors.secondary[800],
                                fontWeight: FontWeight.w400,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Material(
                  color: colors.darkAccent[500],
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedStory = _selectedStory == 2 ? -1 : 2;
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    splashColor: Colors.black.withOpacity(0.2),
                    highlightColor: Colors.black.withOpacity(0.1),
                    child: Container(
                      width: 88,
                      height: 88,
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _selectedStory == 2
                              ? const Color(0xFFF8F7FB)
                              : const Color(0xFFEBEAEF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Assets.icons.shopping.image(
                              width: 40,
                              height: 40,
                            ),
                            6.vertical,
                            Text(
                              'Belanja',
                              style: textTheme.lexendBody.copyWith(
                                color: colors.darkAccent[800],
                                fontWeight: FontWeight.w400,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Material(
                  color: const Color(0xFF52BC00),
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedStory = _selectedStory == 3 ? -1 : 3;
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    splashColor: Colors.black.withOpacity(0.2),
                    highlightColor: Colors.black.withOpacity(0.1),
                    child: Container(
                      width: 88,
                      height: 88,
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _selectedStory == 3
                              ? const Color(0xFFF0F8E8)
                              : const Color(0XFFDFF1D1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Assets.icons.explore.image(
                              width: 40,
                              height: 40,
                            ),
                            6.vertical,
                            Text(
                              'Jelajah',
                              style: textTheme.lexendBody.copyWith(
                                color: const Color(0XFF2F6C00),
                                fontWeight: FontWeight.w400,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            16.vertical,
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Nilai Moral:',
                style: textTheme.lexendLargeBody.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            16.vertical,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Material(
                      color: _selectedMoral == 0
                          ? colors.primary[50]
                          : colors.primary[100],
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedMoral = _selectedMoral == 0 ? -1 : 0;
                          });
                        },
                        borderRadius: BorderRadius.circular(12),
                        splashColor: Colors.grey.withOpacity(0.2),
                        highlightColor: Colors.grey.withOpacity(0.1),
                        child: Container(
                          height: 48,
                          constraints: const BoxConstraints(
                            minWidth: 186,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: colors.primary[500]!,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Assets.icons.saving.image(
                                width: 24,
                                height: 24,
                              ),
                              10.horizontal,
                              Text(
                                'Menabung',
                                style: GoogleFonts.fredoka(
                                  color: colors.primary[800],
                                  fontSize: 21,
                                  fontWeight: FontWeight.w500, // SemiBold
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    10.vertical,
                    Material(
                      color: _selectedMoral == 1
                          ? colors.secondary[50]
                          : colors.secondary[100],
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedMoral = _selectedMoral == 1 ? -1 : 1;
                          });
                        },
                        borderRadius: BorderRadius.circular(12),
                        splashColor: Colors.grey.withOpacity(0.2),
                        highlightColor: Colors.grey.withOpacity(0.1),
                        child: Container(
                          height: 48,
                          constraints: const BoxConstraints(
                            minWidth: 186,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: colors.secondary[500]!,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Assets.icons.honesty.image(
                                width: 24,
                                height: 24,
                              ),
                              10.horizontal,
                              Text(
                                'Kejujuran',
                                style: GoogleFonts.fredoka(
                                  color: colors.secondary[800],
                                  fontSize: 21,
                                  fontWeight: FontWeight.w500, // SemiBold
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Material(
                  color: _selectedMoral == 2
                      ? const Color(0xFFF8F7FB)
                      : const Color(0xFFEBEAEF),
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedMoral = _selectedMoral == 2 ? -1 : 2;
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    splashColor: Colors.grey.withOpacity(0.2),
                    highlightColor: Colors.grey.withOpacity(0.1),
                    child: Container(
                      constraints: const BoxConstraints(
                        minWidth: 86,
                        minHeight: 106,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: colors.darkAccent[400]!,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Assets.icons.wise.image(
                            width: 32,
                            height: 32,
                          ),
                          10.vertical,
                          Text(
                            'Bijak',
                            style: GoogleFonts.fredoka(
                              color: colors.darkAccent[800],
                              fontSize: 21,
                              fontWeight: FontWeight.w500, // SemiBold
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Material(
                  color: _selectedMoral == 3
                      ? colors.support[50]
                      : colors.support[100],
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedMoral = _selectedMoral == 3 ? -1 : 3;
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    splashColor: Colors.grey.withOpacity(0.2),
                    highlightColor: Colors.grey.withOpacity(0.1),
                    child: Container(
                      constraints: const BoxConstraints(
                        minWidth: 86,
                        minHeight: 106,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: colors.support[700]!,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Assets.icons.sharing.image(
                            width: 32,
                            height: 32,
                          ),
                          10.vertical,
                          Text(
                            'Berbagi',
                            style: GoogleFonts.fredoka(
                              color: colors.support[800],
                              fontSize: 21,
                              fontWeight: FontWeight.w500, // SemiBold
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            40.vertical,
            ElevatedButton(
              onPressed: isButtonEnabled
                  ? () {
                      context.push(const GenerateStoryLoadingPage());
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(
                  140,
                  56,
                ),
                textStyle: GoogleFonts.lexend(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
              child: const Text('Buat Cerita Sekarang!'),
            ),
          ],
        ),
      ),
    );
  }
}

class GenerateStoryTextField extends StatefulWidget {
  const GenerateStoryTextField({
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
  State<GenerateStoryTextField> createState() => _GenerateStoryTextFieldState();
}

class _GenerateStoryTextFieldState extends State<GenerateStoryTextField> {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.textInputType,
      maxLines: widget.maxLines,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
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
          color: colors.grey[300],
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
          vertical: 34,
        ),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Assets.icons.mic.svg(
            width: 48,
            height: 48,
          ),
        ),
        suffixIconConstraints: const BoxConstraints(
          minHeight: 48,
          maxHeight: 48,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colors.grey[50] ?? const Color(0xFFEBEBEB),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colors.primary[500] ?? const Color(0xFFFF9F00),
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
      ),
    );
  }
}
