# Iconify Design Flutter

`iconify_design_flutter` lets you use icons from [Iconify](https://icon-sets.iconify.design) in Flutter. Icons are fetched once, cached in memory and on disk, then reused.

---

## Features

- Fetch SVG icons from Iconify by id (`prefix:name`)
- Memory + disk cache, with in-flight request dedupe
- Updates when `icon` changes at runtime
- Respects `IconTheme` for default color/size
- Optional `strokeWidth` for outline icon boldness (Tabler, Lucide, etc.)
- Optional accessibility label and loading placeholder

---

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  iconify_design_flutter: ^1.0.4
```

Run:

```sh
flutter pub get
```

---

## Usage

```dart
import 'package:iconify_design_flutter/iconify_design_flutter.dart';

IconifyIcon(
  icon: "mdi:home",
  color: Colors.black,
  size: 32,
  semanticsLabel: 'Home',
)
```

For outline icons, use `strokeWidth` to control boldness (typical range `1`–`2.5`):

```dart
IconifyIcon(
  icon: "tabler:home",
  size: 32,
  strokeWidth: 1.5,
)
```

Runtime icon changes work without restarting the app:

```dart
IconifyIcon(
  icon: isFavorite ? "mdi:heart" : "mdi:heart-outline",
)
```

Optional loading placeholder:

```dart
IconifyIcon(
  icon: "mdi:home",
  placeholder: SizedBox(
    width: 24,
    height: 24,
    child: CircularProgressIndicator(strokeWidth: 1),
  ),
)
```

Clear caches if needed:

```dart
IconService.clearMemoryCache();
await IconService.clearAllCaches();
```

---

## How it works

1. Validates `prefix:name`
2. Returns from memory cache when available
3. Otherwise checks SharedPreferences
4. Otherwise fetches from Iconify and stores in memory + disk
5. Concurrent requests for the same icon share one network call

---

## Dependencies

- [`dio`](https://pub.dev/packages/dio) – HTTP
- [`flutter_svg`](https://pub.dev/packages/flutter_svg) – SVG rendering
- [`shared_preferences`](https://pub.dev/packages/shared_preferences) – disk cache

---

## Links

- [Source Code](https://github.com/Shadyar-Bzhar-Othman/iconify_design_flutter)
- [Website](https://shadyarbzharothman.com)

---

## Contribution

- Report issues via [GitHub Issues](https://github.com/Shadyar-Bzhar-Othman/iconify_design_flutter/issues)
- Pull requests welcome

---

## License

MIT – see [LICENSE](https://github.com/Shadyar-Bzhar-Othman/iconify_design_flutter/blob/main/LICENSE)
