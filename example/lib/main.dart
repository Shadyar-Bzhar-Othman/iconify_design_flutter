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
      title: 'Iconify Design Fluter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurpleAccent,
          brightness: Brightness.light,
        ),
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
    "material-symbols:home-rounded",
    "material-symbols:settings-outline",
    "material-symbols:search",
    "material-symbols:favorite",
    "material-symbols:notifications",
    "material-symbols:share",
    "material-symbols:delete",
    "material-symbols:edit",
    "material-symbols:arrow-forward",
    "material-symbols:download",
    "material-symbols:mail",
    "material-symbols:phone",
    "material-symbols:info",
    "material-symbols:warning",
  ];

  final invalidIcons = ["invalid-icon-1", "invalid-icon-2", "invalid-icon-3"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iconify Design Fluter Demo'),
        centerTitle: true,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Icon Gallery'),
            const SizedBox(height: 16),
            _buildIconGrid(validIcons),
            const SizedBox(height: 32),
            _buildSectionTitle('Invalid Icons'),
            const SizedBox(height: 16),
            _buildIconGrid(invalidIcons),
            const SizedBox(height: 32),
            _buildSectionTitle('Customization Examples'),
            const SizedBox(height: 16),
            _buildCustomizationExamples(),
            const SizedBox(height: 32),
            _buildSectionTitle('Button Integration'),
            const SizedBox(height: 16),
            _buildButtonExamples(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade800,
      ),
    );
  }

  Widget _buildIconGrid(List<String> icons) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: icons.length,
      itemBuilder:
          (context, index) => Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
            child: IconifyIcon(
              icon: icons[index],
              color: Colors.grey.shade800,
              size: 32,
            ),
          ),
    );
  }

  Widget _buildCustomizationExamples() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ExampleCard(
          icon: "material-symbols:palette-outline",
          size: 64,
          color: Colors.blue,
          label: 'Custom Color',
        ),
        ExampleCard(
          icon: "material-symbols:format-size",
          size: 76,
          label: 'Large Size',
        ),
        ExampleCard(
          icon: "material-symbols:gradient",
          size: 64,
          color: Colors.purple,
          label: 'Different Style',
        ),
      ],
    );
  }

  Widget _buildButtonExamples() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: [
        FilledButton.icon(
          icon: const IconifyIcon(icon: "material-symbols:download", size: 20),
          label: const Text('Download'),
          onPressed: () {},
        ),
        FilledButton.tonalIcon(
          icon: const IconifyIcon(icon: "material-symbols:share", size: 20),
          label: const Text('Share'),
          onPressed: () {},
        ),
        IconButton.filled(
          icon: const IconifyIcon(icon: "material-symbols:favorite"),
          onPressed: () {},
        ),
        IconButton.filledTonal(
          icon: const IconifyIcon(icon: "material-symbols:settings"),
          onPressed: () {},
        ),
      ],
    );
  }
}

class ExampleCard extends StatelessWidget {
  final String icon;
  final double size;
  final Color? color;
  final String label;

  const ExampleCard({
    super.key,
    required this.icon,
    required this.size,
    this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            IconifyIcon(
              icon: icon,
              size: size,
              color: color ?? Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Text(label, style: Theme.of(context).textTheme.labelMedium),
          ],
        ),
      ),
    );
  }
}
