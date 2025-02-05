# Iconify Design Flutter 🚀

`iconify_design_flutter` is a Flutter package that allows you to use icons from [Iconify](https://icon-sets.iconify.design). It caches icons locally after the first fetch, making subsequent loads instant.

---

## 📌 Features

- Fetches SVG icons dynamically from Iconify.
- Caches icons locally for faster future loads.
- Supports custom size and color.

---

## 📦 Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  iconify_design_flutter: ^1.0.2
```

Run:

```sh
flutter pub get
```

---

## 🚀 Usage

Import the package:

```dart
import 'package:iconify_design_flutter/iconify_design_flutter.dart';
```

Use the `IconifyIcon` widget:

```dart
IconifyIcon(
  icon: "mdi:home",
  color: Colors.black,
  size: 32,
)
```

---

## ⚙️ How It Works

- Extracts the prefix and icon name from the provided string (e.g., `"mdi:home"`).
- Checks if the icon is already cached locally.
- If not cached, fetches the SVG from Iconify and stores it.
- On subsequent renders, loads the cached icon instead of fetching it again.

---

## 🔗 Dependencies

- **[`dio`](https://pub.dev/packages/dio)** – For making HTTP requests to fetch icons.
- **[`flutter_svg`](https://pub.dev/packages/flutter_svg)** – For rendering SVG icons.
- **[`shared_preferences`](https://pub.dev/packages/shared_preferences)** – For local caching.
- **[`fpdart`](https://pub.dev/packages/fpdart)** – For functional programming utilities.

---

## 🔗 Links

- 📦 [Source Code](https://github.com/Shadyar-Bzhar-Othman/iconify_design_flutter)
- 🌍 [Website](https://shadyarbzharothman.com)

---

## 🤝 Contribution

We welcome contributions! You can:

- Report issues via [GitHub Issues](https://github.com/Shadyar-Bzhar-Othman/iconify_design_flutter/issues).
- Submit a pull request if you'd like to improve the package.

---

## 🐜 License

This project is licensed under the **MIT License** – see the [LICENSE](https://github.com/Shadyar-Bzhar-Othman/iconify_design_flutter/blob/main/LICENSE) file for details.

---

If you appreciate my work, please don't forget to ⭐ star the repo to show your support!
