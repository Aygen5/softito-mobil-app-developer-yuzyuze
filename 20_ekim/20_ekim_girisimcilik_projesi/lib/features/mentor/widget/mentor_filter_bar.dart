import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/context_extensions.dart';

class MentorFilterBar extends StatefulWidget {
  final List<String> sektorler;
  final String? seciliSektor;
  final String aramaMetni;
  final ValueChanged<String?> onSektorSelected;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearAll;

  const MentorFilterBar({
    super.key,
    required this.sektorler,
    required this.seciliSektor,
    required this.aramaMetni,
    required this.onSektorSelected,
    required this.onSearchChanged,
    required this.onClearAll,
  });

  @override
  State<MentorFilterBar> createState() => _MentorFilterBarState();
}

class _MentorFilterBarState extends State<MentorFilterBar> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.aramaMetni);
  }

  @override
  void didUpdateWidget(covariant MentorFilterBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.aramaMetni != _textController.text) {
      _textController.text = widget.aramaMetni;
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSearchField(context),
        const SizedBox(height: 8),
        _buildChips(context),
      ],
    );
  }

  Widget _buildSearchField(BuildContext context) {
    final colors = context.spaceColors;
    final hasText = _textController.text.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: _textController,
        onChanged: widget.onSearchChanged,
        style: TextStyle(color: colors.textPrimary),
        decoration: InputDecoration(
          hintText: 'Mentor, uzmanlık veya sektör ara...',
          hintStyle: TextStyle(color: colors.textMuted),
          prefixIcon:
              Icon(Icons.search_rounded, size: 20, color: colors.nebulaCyan),
          suffixIcon: hasText
              ? IconButton(
                  icon: Icon(Icons.cancel_rounded,
                      size: 18, color: colors.textMuted),
                  onPressed: () {
                    _textController.clear();
                    widget.onSearchChanged('');
                  },
                )
              : null,
          filled: true,
          fillColor: colors.surfaceSubtle,
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: colors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: colors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: colors.rocketFlame, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildChips(BuildContext context) {
    final colors = context.spaceColors;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          ChoiceChip(
            label: const Text(AppStrings.tumu),
            selected: widget.seciliSektor == null,
            selectedColor: colors.rocketFlame,
            labelStyle: TextStyle(
              color: widget.seciliSektor == null
                  ? Colors.white
                  : colors.textPrimary,
              fontWeight: widget.seciliSektor == null
                  ? FontWeight.bold
                  : FontWeight.normal,
              fontSize: 12,
            ),
            onSelected: (_) => widget.onSektorSelected(null),
          ),
          const SizedBox(width: 8),
          ...widget.sektorler.map(
            (sektor) {
              final isSelected = widget.seciliSektor == sektor;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(sektor),
                  selected: isSelected,
                  selectedColor: colors.rocketFlame.withValues(alpha: 0.25),
                  checkmarkColor: colors.rocketFlame,
                  labelStyle: TextStyle(
                    color: isSelected ? colors.rocketFlame : colors.textPrimary,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  ),
                  side: BorderSide(
                    color: isSelected ? colors.rocketFlame : colors.border,
                  ),
                  onSelected: (selected) {
                    widget.onSektorSelected(selected ? sektor : null);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
