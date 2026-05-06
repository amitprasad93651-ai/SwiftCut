# SwiftCut

A powerful, modern Flutter video editing app for Android with a focus on high performance, low resource requirements, and a smooth user experience.

## Features
- Video timeline with scrubbing
- Trim, cut, merge videos
- Filters and transitions
- Add text overlay
- Add music/audio tracks
- Made in India badge (visible in UI and optionally watermark on exports)
- Hindi/English interface (fully localized)
- Optimized for low RAM devices — no hanging or lag
- Open, extendable architecture to surpass CapCut’s user experience

## Project Structure
```
lib/
  app.dart
  main.dart
  l10n/
    en.arb
    hi.arb
    l10n.dart
  pages/
    home_page.dart
    editor_page.dart
  widgets/
    made_in_india_badge.dart
    video_timeline.dart
```

## Getting Started
1. Install [Flutter](https://flutter.dev/docs/get-started/install) SDK.
2. Run `flutter pub get` to fetch dependencies.
3. Run `flutter pub run intl_utils:generate` to generate localization files.
4. Use `flutter run` to launch the app.

## Contributing
Pull requests are welcome! For major changes, please open an issue first.

## License
MIT

---
Made with ❤️ in India.
