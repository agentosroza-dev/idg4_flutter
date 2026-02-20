import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

// Widget My3LineCard(BuildContext context, String imageUrl, String title, String subtitle, String footer) {
//   return Card(
//     elevation: 2,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(12),
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         // Image section
//         ClipRRect(
//           borderRadius: const BorderRadius.vertical(
//             top: Radius.circular(12),
//           ),
//           child: AspectRatio(
//             aspectRatio: 1 / 1, // Changed from 8/8 to 1/1 (square)
//             child: CachedNetworkImage(
//               imageUrl: imageUrl,
//               fit: BoxFit.cover,
//               placeholder: (context, url) => Container(
//                 color: Colors.grey[200], // Added missing color
//                 child: const Center(
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                   ),
//                 ),
//               ),
//               errorWidget: (context, url, error) => Container(
//                 color: Colors.grey[200], // Added missing color
//                 child: const Icon(
//                   Icons.broken_image,
//                   color: Colors.grey, // Added color
//                 ),
//               ),
//             ),
//           ),
//         ),

//         // Content section
//         Padding(
//           padding: const EdgeInsets.all(12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Title
//               Text(
//                 title,
//                 style: Theme.of(context).textTheme.titleSmall?.copyWith(
//                   fontWeight: FontWeight.bold,
//                 ),
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//               const SizedBox(height: 4),

//               // Footer and Subtitle row
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   // Footer (left side)
//                   Expanded(
//                     child: Text(
//                       footer,
//                       style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                         fontWeight: FontWeight.w600,
//                         color: Theme.of(context).colorScheme.onPrimary, // Added color for footer
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   // Subtitle badge (right side)
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 8,
//                       vertical: 4
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.red, // Moved color here
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                     child: Text(
//                       subtitle,
//                       style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                         fontWeight: FontWeight.w500,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }

Widget My3LineCard(
  BuildContext context,
  String imageUrl,
  String title,
  String subtitle,
  String footer,
) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;

  return Card(
    elevation: 0,
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: BorderSide(color: Colors.grey.shade100, width: 1.5),
    ),
    clipBehavior: Clip.antiAlias,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Clean image with subtle shadow
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: AspectRatio(
            aspectRatio: 1 / 1,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey.shade50,
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colorScheme.primary,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey.shade50,
                child: Icon(
                  Icons.image_outlined,
                  size: 40,
                  color: Colors.grey.shade300,
                ),
              ),
            ),
          ),
        ),

        // Content with improved spacing
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  height: 1.2,
                  letterSpacing: -0.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),

              // Subtitle
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                  height: 1.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              // Footer with chip design
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.tag_outlined,
                      size: 14,
                      color: colorScheme.primary,
                    ),

                    Text(
                      footer,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
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
