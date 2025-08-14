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
                  fontSize: 34,
                  fontWeight: FontWeight.w600,
                ),
                text: 'Let’s Create ',
                children: [
                  TextSpan(
                    text: 'Your Story!',
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
              label: 'Type your story idea here...',
              controller: _textController,
              onChanged: (value) {
                setState(() {});
                return null;
              },
            ),
            16.vertical,
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Or Choose a Story Idea:',
                style: textTheme.lexendLargeBody.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            16.vertical,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _storyOption(
                  index: 0,
                  selectedIndex: _selectedStory,
                  onTap: () {
                    setState(() {
                      _selectedStory = _selectedStory == 0 ? -1 : 0;
                    });
                  },
                  color: colors.primary[500]!,
                  bgSelected: colors.primary[50]!,
                  bgUnselected: colors.primary[100]!,
                  icon: Assets.icons.school.image(width: 40, height: 40),
                  label: 'School',
                  labelColor: colors.primary[800]!,
                ),
                _storyOption(
                  index: 1,
                  selectedIndex: _selectedStory,
                  onTap: () {
                    setState(() {
                      _selectedStory = _selectedStory == 1 ? -1 : 1;
                    });
                  },
                  color: colors.secondary[500]!,
                  bgSelected: colors.secondary[50]!,
                  bgUnselected: colors.secondary[100]!,
                  icon: Assets.icons.fantasy.image(width: 40, height: 40),
                  label: 'Fantasy',
                  labelColor: colors.secondary[800]!,
                ),
                _storyOption(
                  index: 2,
                  selectedIndex: _selectedStory,
                  onTap: () {
                    setState(() {
                      _selectedStory = _selectedStory == 2 ? -1 : 2;
                    });
                  },
                  color: colors.darkAccent[500]!,
                  bgSelected: const Color(0xFFF8F7FB),
                  bgUnselected: const Color(0xFFEBEAEF),
                  icon: Assets.icons.shopping.image(width: 40, height: 40),
                  label: 'Shopping',
                  labelColor: colors.darkAccent[800]!,
                ),
                _storyOption(
                  index: 3,
                  selectedIndex: _selectedStory,
                  onTap: () {
                    setState(() {
                      _selectedStory = _selectedStory == 3 ? -1 : 3;
                    });
                  },
                  color: const Color(0xFF52BC00),
                  bgSelected: const Color(0xFFF0F8E8),
                  bgUnselected: const Color(0XFFDFF1D1),
                  icon: Assets.icons.explore.image(width: 40, height: 40),
                  label: 'Explore',
                  labelColor: const Color(0XFF2F6C00),
                ),
              ],
            ),
            16.vertical,
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Moral Value:',
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
                    _moralOption(
                      index: 0,
                      selectedIndex: _selectedMoral,
                      onTap: () {
                        setState(() {
                          _selectedMoral = _selectedMoral == 0 ? -1 : 0;
                        });
                      },
                      color: colors.primary[500]!,
                      bgSelected: colors.primary[50]!,
                      bgUnselected: colors.primary[100]!,
                      icon: Assets.icons.saving.image(width: 24, height: 24),
                      label: 'Saving',
                      labelColor: colors.primary[800]!,
                    ),
                    10.vertical,
                    _moralOption(
                      index: 1,
                      selectedIndex: _selectedMoral,
                      onTap: () {
                        setState(() {
                          _selectedMoral = _selectedMoral == 1 ? -1 : 1;
                        });
                      },
                      color: colors.secondary[500]!,
                      bgSelected: colors.secondary[50]!,
                      bgUnselected: colors.secondary[100]!,
                      icon: Assets.icons.honesty.image(width: 24, height: 24),
                      label: 'Honesty',
                      labelColor: colors.secondary[800]!,
                    ),
                  ],
                ),
                _moralOptionVertical(
                  index: 2,
                  selectedIndex: _selectedMoral,
                  onTap: () {
                    setState(() {
                      _selectedMoral = _selectedMoral == 2 ? -1 : 2;
                    });
                  },
                  borderColor: colors.darkAccent[400]!,
                  bgSelected: const Color(0xFFF8F7FB),
                  bgUnselected: const Color(0xFFEBEAEF),
                  icon: Assets.icons.wise.image(width: 32, height: 32),
                  label: 'Wisdom',
                  labelColor: colors.darkAccent[800]!,
                ),
                _moralOptionVertical(
                  index: 3,
                  selectedIndex: _selectedMoral,
                  onTap: () {
                    setState(() {
                      _selectedMoral = _selectedMoral == 3 ? -1 : 3;
                    });
                  },
                  borderColor: colors.support[700]!,
                  bgSelected: colors.support[50]!,
                  bgUnselected: colors.support[100]!,
                  icon: Assets.icons.sharing.image(width: 32, height: 32),
                  label: 'Sharing',
                  labelColor: colors.support[800]!,
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
                minimumSize: const Size(140, 56),
                textStyle: GoogleFonts.lexend(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
              child: const Text('Create Story Now!'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _storyOption({
    required int index,
    required int selectedIndex,
    required VoidCallback onTap,
    required Color color,
    required Color bgSelected,
    required Color bgUnselected,
    required Widget icon,
    required String label,
    required Color labelColor,
  }) {
    final colors = context.colors;
    final textTheme = context.textTheme;
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: Colors.black.withOpacity(0.2),
        highlightColor: Colors.black.withOpacity(0.1),
        child: Container(
          width: 88,
          height: 88,
          padding: const EdgeInsets.only(bottom: 4),
          child: Container(
            decoration: BoxDecoration(
              color: selectedIndex == index ? bgSelected : bgUnselected,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                6.vertical,
                Text(
                  label,
                  style: textTheme.lexendBody.copyWith(
                    color: labelColor,
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _moralOption({
    required int index,
    required int selectedIndex,
    required VoidCallback onTap,
    required Color color,
    required Color bgSelected,
    required Color bgUnselected,
    required Widget icon,
    required String label,
    required Color labelColor,
  }) {
    return Material(
      color: selectedIndex == index ? bgSelected : bgUnselected,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: Colors.grey.withOpacity(0.2),
        highlightColor: Colors.grey.withOpacity(0.1),
        child: Container(
          height: 48,
          constraints: const BoxConstraints(minWidth: 186),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: color, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              10.horizontal,
              Text(
                label,
                style: GoogleFonts.fredoka(
                  color: labelColor,
                  fontSize: 21,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _moralOptionVertical({
    required int index,
    required int selectedIndex,
    required VoidCallback onTap,
    required Color borderColor,
    required Color bgSelected,
    required Color bgUnselected,
    required Widget icon,
    required String label,
    required Color labelColor,
  }) {
    return Material(
      color: selectedIndex == index ? bgSelected : bgUnselected,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: Colors.grey.withOpacity(0.2),
        highlightColor: Colors.grey.withOpacity(0.1),
        child: Container(
          constraints: const BoxConstraints(minWidth: 86, minHeight: 106),
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              10.vertical,
              Text(
                label,
                style: GoogleFonts.fredoka(
                  color: labelColor,
                  fontSize: 21,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ),
            ],
          ),
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
