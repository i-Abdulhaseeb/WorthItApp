import 'package:flutter/material.dart';

/// Selectable question option card widget
class QuestionOptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData? icon;
  final String? trailingLabel;
  final bool isSelected;
  final VoidCallback? onTap;

  final Widget? expandedChild;

  const QuestionOptionCard({
    super.key,
    required this.title,
    this.subtitle = '',
    this.icon,
    this.trailingLabel,
    this.isSelected = false,
    this.onTap,
    this.expandedChild,
  });

  static const _green = Color(0xFF0E6E4E);
  static const _border = Color(0xFFE2DED8);
  static const _chipBg = Color(0xFFF1EEE8);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isSelected ? _green.withOpacity(0.06) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected ? _green : _border,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? _green.withOpacity(0.12)
                              : _chipBg,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          icon,
                          size: 20,
                          color: isSelected ? _green : Colors.black54,
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? _green : Colors.black87,
                            ),
                          ),
                          if (subtitle.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              subtitle,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (trailingLabel != null) ...[
                      const SizedBox(width: 8),
                      _Chip(text: trailingLabel!, highlighted: isSelected),
                    ],
                    const SizedBox(width: 8),
                    Icon(
                      isSelected ? Icons.check_circle : Icons.circle_outlined,
                      color: isSelected ? _green : const Color(0xFFCFC9C0),
                      size: 22,
                    ),
                  ],
                ),
                if (isSelected && expandedChild != null) ...[
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  expandedChild!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String text;
  final bool highlighted;
  const _Chip({required this.text, this.highlighted = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: highlighted ? const Color(0xFFE1F2E8) : const Color(0xFFF1EEE8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: highlighted ? const Color(0xFF0E6E4E) : Colors.black54,
        ),
      ),
    );
  }
}
