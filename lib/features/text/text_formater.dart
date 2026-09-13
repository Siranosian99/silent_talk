String cleanMarkdown(String text) {
  return text
      .replaceAll(RegExp(r'#{1,6}\s*'), '')
      .replaceAll('**', '')
      .replaceAll('__', '')
      .replaceAll('---', '')
      .replaceAll(RegExp(r'\|'), ' ')
      .replaceAll(RegExp(r'^\s*[-*]\s+', multiLine: true), '');
}