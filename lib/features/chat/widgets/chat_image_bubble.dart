import 'package:flutter/material.dart';

class ChatImage extends StatelessWidget {
  final String imageUrl;
  final bool isMe;

  const ChatImage({
    super.key,
    required this.imageUrl,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 10,
        bottom: 12,
        left: isMe ? 0 : 12,
        right: isMe ? 12 : 0,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          imageUrl,
          width: 250,
          height: 250,
          fit: BoxFit.cover,
          loadingBuilder: (
              context,
              child,
              loadingProgress,
              ) {
            if (loadingProgress == null) {
              return child;
            }

            return SizedBox(
              width: 250,
              height: 250,
              child: Center(
                child: CircularProgressIndicator(
                  value:
                  loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 250,
              height: 250,
              color: Colors.grey.shade300,
              child: const Center(
                child: Icon(
                  Icons.broken_image,
                  size: 40,
                  color: Colors.grey,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}