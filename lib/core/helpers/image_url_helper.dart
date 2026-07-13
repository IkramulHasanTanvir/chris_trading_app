class ImageUrlHelper {
  ImageUrlHelper._();

  static const _imageExtensions = {
    '.jpg',
    '.jpeg',
    '.png',
    '.gif',
    '.webp',
    '.bmp',
    '.svg',
  };

  static const _blockedHosts = {
    'tradingview.com',
    'www.tradingview.com',
    'youtube.com',
    'www.youtube.com',
    'youtu.be',
    'vimeo.com',
  };

  /// Returns true only when [url] is safe to load with an image widget.
  static bool isLoadableImageUrl(String? url) {
    final trimmed = url?.trim() ?? '';
    if (trimmed.isEmpty) return false;

    final uri = Uri.tryParse(trimmed);
    if (uri == null || !uri.hasScheme) return false;
    if (uri.scheme != 'http' && uri.scheme != 'https') return false;
    if (uri.host.isEmpty) return false;

    final host = uri.host.toLowerCase();
    if (_blockedHosts.any((h) => host == h || host.endsWith('.$h'))) {
      return false;
    }

    final path = uri.path.toLowerCase();
    if (path.contains('/chart/')) return false;

    final hasImageExt = _imageExtensions.any(path.endsWith);
    if (hasImageExt) return true;

    // Allow common upload/CDN image paths without extension.
    if (path.contains('/upload') ||
        path.contains('/uploads') ||
        path.contains('/image') ||
        path.contains('/images') ||
        path.contains('/media')) {
      return true;
    }

    // Unknown page-like URLs (e.g. tradingview) — do not load as image.
    if (!path.contains('.') || path.endsWith('/')) return false;

    return false;
  }
}
