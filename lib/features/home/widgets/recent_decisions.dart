import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:worthitapp/data/models/saved_decision_model.dart';
import 'package:worthitapp/features/home/controllers/home_controller.dart';

class RecentDecisions extends StatelessWidget {
  const RecentDecisions({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final theme = Theme.of(context);

    return Obx(() {
      final decisions = controller.savedLists.take(3).toList();

      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.025),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: theme.colorScheme.surface,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: BorderSide(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.45),
            ),
          ),
          child: decisions.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'No decisions yet.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium,
                  ),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (int i = 0; i < decisions.length; i++) ...[
                      _DecisionTile(decision: decisions[i]),
                      if (i < decisions.length - 1)
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: theme.colorScheme.outlineVariant.withValues(
                            alpha: 0.45,
                          ),
                        ),
                    ],
                  ],
                ),
        ),
      );
    });
  }
}

class _DecisionTile extends StatelessWidget {
  const _DecisionTile({required this.decision});

  final SavedDecisionModel decision;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        // Add navigation later.
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isVeryCompact = constraints.maxWidth < 320;
            final badge = _VerdictBadge(verdict: decision.verdict);

            return Row(
              children: [
                _ProductImage(path: decision.imagePath),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        decision.productName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        decision.productPrice,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 13.5,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (isVeryCompact) ...[
                        const SizedBox(height: 6),
                        badge,
                      ],
                    ],
                  ),
                ),
                if (!isVeryCompact) ...[
                  const SizedBox(width: 10),
                  badge,
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ProductImage extends StatefulWidget {
  const _ProductImage({required this.path});

  final String? path;

  @override
  State<_ProductImage> createState() => _ProductImageState();
}

class _ProductImageState extends State<_ProductImage> {
  Future<Uint8List>? _imageBytes;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(covariant _ProductImage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.path != widget.path) {
      _loadImage();
    }
  }

  void _loadImage() {
    final path = widget.path;
    _imageBytes = path == null || path.trim().isEmpty
        ? null
        : XFile(path).readAsBytes();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final placeholder = Center(
      child: Icon(
        Icons.shopping_bag_outlined,
        size: 22,
        color: colors.onSurfaceVariant,
      ),
    );

    return ClipOval(
      child: SizedBox(
        width: 46,
        height: 46,
        child: ColoredBox(
          color: colors.surfaceContainerHighest,
          child: _imageBytes == null
              ? placeholder
              : FutureBuilder<Uint8List>(
                  future: _imageBytes,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done ||
                        !snapshot.hasData) {
                      return placeholder;
                    }

                    return Image.memory(
                      snapshot.data!,
                      width: 46,
                      height: 46,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => placeholder,
                    );
                  },
                ),
        ),
      ),
    );
  }
}

class _VerdictBadge extends StatelessWidget {
  const _VerdictBadge({required this.verdict});

  final String verdict;

  @override
  Widget build(BuildContext context) {
    final normalized = verdict.trim().toLowerCase().replaceAll(
      RegExp(r"[\s_'’\-]+"),
      '',
    );

    final (label, color) = switch (normalized) {
      'buy' => ('BUY', const Color(0xFF009E78)),
      'wait' => ('WAIT', const Color(0xFFFF8A24)),
      'dontbuy' => ("DON'T BUY", const Color(0xFFDC1717)),
      _ => ('UNKNOWN', Theme.of(context).colorScheme.onSurfaceVariant),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withValues(alpha: 0.38), width: 0.8),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium
            ?.copyWith(fontSize: 12, fontWeight: FontWeight.w700, color: color),
      ),
    );
  }
}
