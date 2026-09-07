import 'package:flutter/material.dart';

/// 1-5 Star rating selector widget
class RatingSelector extends StatelessWidget {
  final int selectedRating;
  final ValueChanged<int>? onRatingChanged;

  const RatingSelector({
    super.key,
    this.selectedRating = 5,
    this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final starIndex = index + 1;
        return IconButton(
          icon: Icon(
            starIndex <= selectedRating ? Icons.star : Icons.star_border,
            color: Colors.amber,
          ),
          onPressed: () => onRatingChanged?.call(starIndex),
        );
      }),
    );
  }
}
