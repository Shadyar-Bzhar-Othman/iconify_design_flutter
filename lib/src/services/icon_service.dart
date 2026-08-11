import 'package:iconify_design_flutter/src/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Loads Iconify SVGs with memory cache, disk cache, and in-flight dedupe.
class IconService {
  IconService._();

  static final Map<String, String> _memoryCache = <String, String>{};
  static final Map<String, Future<String?>> _inflight =
      <String, Future<String?>>{};

  static String _prefsKey(String icon) => 'icon:$icon';

  /// Returns SVG markup for [icon] (`prefix:name`), or null if unavailable.
  static Future<String?> getIcon(String icon) {
    final cached = _memoryCache[icon];
    if (cached != null) {
      return Future<String?>.value(cached);
    }

    final pending = _inflight[icon];
    if (pending != null) {
      return pending;
    }

    final future = _loadIcon(icon);
    _inflight[icon] = future;
    future.whenComplete(() {
      _inflight.remove(icon);
    });
    return future;
  }

  static Future<String?> _loadIcon(String icon) async {
    final parts = icon.split(':');
    if (parts.length != 2 || parts[0].isEmpty || parts[1].isEmpty) {
      return null;
    }

    final prefs = await SharedPreferences.getInstance();
    final key = _prefsKey(icon);
    final diskCached = prefs.getString(key);
    if (diskCached != null && diskCached.isNotEmpty) {
      _memoryCache[icon] = diskCached;
      return diskCached;
    }

    final svg = await APIService.getSvg('${parts[0]}/${parts[1]}.svg');
    if (svg == null || svg.isEmpty) {
      return null;
    }

    _memoryCache[icon] = svg;
    await prefs.setString(key, svg);
    return svg;
  }

  /// Clears memory and in-flight caches. Disk entries remain.
  static void clearMemoryCache() {
    _memoryCache.clear();
    _inflight.clear();
  }

  /// Clears memory, in-flight, and SharedPreferences icon entries.
  static Future<void> clearAllCaches() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((k) => k.startsWith('icon:')).toList();
    for (final key in keys) {
      await prefs.remove(key);
    }
    clearMemoryCache();
  }
}
