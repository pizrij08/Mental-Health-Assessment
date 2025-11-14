# MindWell Clinic – Flutter App

Modernised Flutter implementation of the MindWell Clinic experience. The project is
structured for sustainable growth with a feature-first layout, shared design
system, and Riverpod-driven state management.

## Project Layout

```
lib/
├── core/
│   ├── config/          # Environment metadata & build-time flags
│   └── providers/       # Global Riverpod providers (repository, config)
├── data/                # In-memory repositories (replaceable with real APIs)
├── design_system/
│   ├── tokens/          # Color, typography tokens
│   └── components/      # Shared UI building blocks (cards, sections, network image)
├── features/
│   ├── auth/            # Role selection, login flows
│   ├── landing/         # Marketing landing page and hero sections
│   ├── clinic/          # Clinic-side dashboards
│   ├── admin/           # Admin console
│   └── user/            # Logged-in user hub
└── pages/               # Legacy screens pending migration
```

## State Management

- [flutter_riverpod](https://pub.dev/packages/flutter_riverpod) wraps the app via
  `ProviderScope` in `main.dart`.
- `mindWellRepositoryProvider` exposes the `MindWellRepository` change notifier.
- Additional providers (configuration, future API clients) live under
  `lib/core/providers`.

## Configuration

- Build-time environment flag `APP_ENV` controls the active `AppConfig`
  (`lib/core/config/app_config.dart`).
- Add `--dart-define=APP_ENV=staging` (or `production`) to switch endpoints.

## Assets

- Place product imagery and brand assets under `assets/images/`.
- Registered in `pubspec.yaml` for offline reliability.

## Testing

- Widget suites live in `test/`, using helpers from `test/helpers/` to wrap test
  widgets with `ProviderScope`.
- Run the full suite: `flutter test`.

## Development Commands

```bash
flutter pub get          # Install dependencies
flutter analyze          # Static analysis
flutter test             # Run automated tests
flutter run              # Launch on connected device / simulator
```

## Next Steps

- Swap the in-memory repository for real data sources via repository interfaces.
- Expand Riverpod providers to cover authentication and journalling flows.
- Extend CI with format/analyse/test checks (e.g. GitHub Actions).
