import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerNotificationsList extends StatelessWidget {
  final int childrenCount;
  const ShimmerNotificationsList({super.key, required this.childrenCount});

  Widget _shimmerBox({
    double height = 14,
    double width = double.infinity,
    BorderRadius? borderRadius,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(6),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: childrenCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),

          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon placeholder
                _shimmerBox(
                  height: 40,
                  width: 40,
                  borderRadius: BorderRadius.circular(20),
                ),
                const SizedBox(width: 12),

                // Text placeholders
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _shimmerBox(height: 14, width: double.infinity),
                      const SizedBox(height: 6),
                      _shimmerBox(height: 14, width: double.infinity),
                      const SizedBox(height: 12),
                      _shimmerBox(height: 12, width: 120),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Small dot placeholder (unread indicator)
                _shimmerBox(
                    height: 8,
                    width: 8,
                    borderRadius: BorderRadius.circular(4)),
              ],
            ),
          ),
        );
      },
    );
  }
}
