import 'package:flutter/material.dart';
import 'package:iconify_design_flutter/iconify_design_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Iconify Design',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TestScreen(),
    );
  }
}

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final validIcons = [
    "logos:flutter",
    "skill-icons:flutter-light",
    "skill-icons:flutter-dark",
    "logos:facebook",
    "line-md:facebook",
    "line-md:instagram",
    "skill-icons:instagram",
    "hugeicons:tiktok",
    "logos:reddit-icon",
    "icon-park-solid:one",
    "fluent:home-24-filled",
    "mage:phone-fill",
    "ic:twotone-computer",
    "material-symbols:hotel-class-rounded",
  ];

  final invalidIcons = ["thisisanicon", "crossicon", "whatisicon", "iconify"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Iconify design for flutter demo',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey.shade800,
        centerTitle: true,
      ),
      backgroundColor: Colors.grey.shade900,
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Valid icons :", style: TextStyle(color: Colors.white)),
            const SizedBox(height: 16),
            Center(
              child: GridView.count(
                crossAxisCount: 8,
                shrinkWrap: true,
                mainAxisSpacing: 28.0,
                crossAxisSpacing: 28.0,
                childAspectRatio: 2,
                children:
                    validIcons.map((icon) => IconifyIcon(icon: icon)).toList(),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              "Invalid icons : (There is no output in that case)",
              style: TextStyle(color: Colors.white),
            ),
            Center(
              child: GridView.count(
                crossAxisCount: 8,
                shrinkWrap: true,
                mainAxisSpacing: 28.0,
                crossAxisSpacing: 28.0,
                childAspectRatio: 2,
                children:
                    invalidIcons
                        .map((icon) => IconifyIcon(icon: icon))
                        .toList(),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              "Change icon color & width",
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(width: 1, color: Colors.white),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: const Column(
                    children: [
                      IconifyIcon(icon: "material-symbols:10k", size: 128),
                      Text(
                        "Size scaled to 128.0",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(width: 1, color: Colors.white),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: const Column(
                    children: [
                      IconifyIcon(
                        icon: "iconoir:fill-color-solid",
                        color: Colors.yellow,
                      ),
                      Text(
                        "Color changed to yellow",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              "Usage with buttons",
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade700,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {},
                  icon: const IconifyIcon(
                    icon: "mdi:refresh",
                    color: Colors.white,
                  ),
                  label: const Text("Reload"),
                ),
                const SizedBox(width: 8),
                IconButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade700,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(32, 32),
                    maximumSize: const Size(32, 32),
                  ),
                  onPressed: () {},
                  icon: const IconifyIcon(icon: "mdi:home", color: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
