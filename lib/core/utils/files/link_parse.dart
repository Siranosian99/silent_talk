String extractPath(String url) {
  final uri = Uri.parse(url);

  final segments = uri.pathSegments;

  final bucketIndex = segments.indexOf('documents');

  final pathSegments = segments.sublist(bucketIndex + 1);

  return pathSegments.join('/');
}