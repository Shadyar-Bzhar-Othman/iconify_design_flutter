import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconify_design_flutter/src/services/icon_service.dart';

export 'package:iconify_design_flutter/src/services/icon_service.dart'
    show IconService;

class IconifyIcon extends StatefulWidget {
  /// Iconify id in `prefix:name` form, e.g. `"mdi:home"`.
  final String icon;

  /// Icon size. Defaults to [IconThemeData.size], then `24`.
  final double? size;

  /// Icon color. Defaults to [IconThemeData.color], then black.
  final Color? color;

  /// Stroke thickness for outline icons (boldness).
  ///
  /// Only affects icons that use SVG `stroke-width` (e.g. Tabler, Lucide).
  /// Filled icons are unchanged. Typical values are around `1`–`2.5`.
  final double? strokeWidth;

  /// Optional accessibility label.
  final String? semanticsLabel;

  /// Shown while the SVG is loading. Defaults to an empty sized box.
  final Widget? placeholder;

  const IconifyIcon({
    super.key,
    required this.icon,
    this.size,
    this.color,
    this.strokeWidth,
    this.semanticsLabel,
    this.placeholder,
  });

  @override
  State<IconifyIcon> createState() => _IconifyIconState();
}

class _IconifyIconState extends State<IconifyIcon> {
  late Future<String?> _iconFuture;

  @override
  void initState() {
    super.initState();
    _iconFuture = IconService.getIcon(widget.icon);
  }

  @override
  void didUpdateWidget(covariant IconifyIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.icon != widget.icon) {
      _iconFuture = IconService.getIcon(widget.icon);
    }
  }

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);
    final size = widget.size ?? iconTheme.size ?? 24.0;
    final color = widget.color ?? iconTheme.color ?? Colors.black;

    return FutureBuilder<String?>(
      future: _iconFuture,
      builder: (_, AsyncSnapshot<String?> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.waiting:
            return widget.placeholder ?? SizedBox(width: size, height: size);
          case ConnectionState.none:
            return SizedBox(width: size, height: size);
          case ConnectionState.done:
            final data = snapshot.data;
            if (data == null) {
              return SizedBox(width: size, height: size);
            }

            final svg = widget.strokeWidth == null
                ? data
                : applyStrokeWidth(data, widget.strokeWidth!);

            return SvgPicture.string(
              svg,
              width: size,
              height: size,
              theme: SvgTheme(currentColor: color),
              semanticsLabel: widget.semanticsLabel,
            );
        }
      },
    );
  }
}

/// Rewrites `stroke-width` in [svg] so outline icons render thicker/thinner.
@visibleForTesting
String applyStrokeWidth(String svg, double strokeWidth) {
  final value = _formatStrokeWidth(strokeWidth);
  var result = svg.replaceAllMapped(
    RegExp(r'''stroke-width\s*=\s*(["'])[^"']*\1'''),
    (match) => 'stroke-width=${match[1]}$value${match[1]}',
  );
  result = result.replaceAllMapped(
    RegExp(r'stroke-width\s*:\s*[^;}"]+'),
    (_) => 'stroke-width:$value',
  );
  return result;
}

String _formatStrokeWidth(double value) {
  if (value == value.roundToDouble()) {
    return value.toInt().toString();
  }
  return value.toString();
}
