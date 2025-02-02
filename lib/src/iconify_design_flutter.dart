import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconify_design_flutter/src/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IconifyIcon extends StatefulWidget {
  final String icon;
  final double? size;
  final Color? color;

  const IconifyIcon({
    super.key,
    required this.icon,
    this.size = 24,
    this.color = Colors.black,
  });

  @override
  State<IconifyIcon> createState() => _IconifyIconState();
}

class _IconifyIconState extends State<IconifyIcon> {
  Future<String?> getIcon() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if the icon is already cached
    if (prefs.containsKey('icon:${widget.icon}')) {
      return prefs.getString('icon:${widget.icon}');
    }

    // Split the icon string to get prefix and icon name
    final parts = widget.icon.split(":");
    if (parts.length != 2) throw ArgumentError("Invalid icon format");
    final prefix = parts[0];
    final icon = parts[1];

    // Fetch the icon from the API
    final response = await APIService.getRequest('$prefix/$icon.svg');

    return await response.fold(
      (l) {
        return null;
      },
      (r) async {
        // Cache the fetched icon
        await prefs.setString('icon:${widget.icon}', r.data);
        return r.data;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getIcon(),
      builder: (_, AsyncSnapshot<String?> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.waiting:
            // Show a loading indicator while fetching the icon
            return Container(
              width: widget.size,
              padding: const EdgeInsets.all(2.0),
              child: AspectRatio(
                aspectRatio: 1,
                child: CircularProgressIndicator(
                  color: widget.color,
                  strokeWidth: 1,
                ),
              ),
            );
          case ConnectionState.none:
            return const SizedBox.shrink();
          case ConnectionState.done:
            if (snapshot.data == null) {
              return const SizedBox.shrink();
            }

            // Display the fetched SVG icon
            return SvgPicture.string(
              snapshot.data!,
              width: widget.size,
              height: widget.size,
              theme: SvgTheme(currentColor: widget.color!),
            );
        }
      },
    );
  }
}
