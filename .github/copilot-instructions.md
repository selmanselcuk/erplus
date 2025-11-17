# ERPlus - AI Coding Agent Instructions

## Project Overview
ERPlus is a Flutter ERP application with responsive design supporting desktop and mobile. The app uses a shell-based navigation architecture with feature-based organization.

## Architecture

### Shell Pattern
- **Shell**: `lib/src/shell/erplus_shell.dart` - Main navigation container
  - Adaptive UI: Desktop (≥900px) shows sidebar, mobile shows AppBar + Drawer
  - State management: StatefulWidget with `_selectedIndex` for navigation
  - Pages rendered via indexed list: `_pages[_selectedIndex]`

### Feature Organization
- **Structure**: `lib/src/features/<feature_name>/<feature_name>_page.dart`
- **Current features**:
  - `dashboard/` - Dashboard view
  - `customers/` - Customer management
- **Pattern**: Each feature is a self-contained directory with page widgets

### App Entry Points
- `lib/main.dart` → `lib/src/erplus_app.dart` → `lib/src/shell/erplus_shell.dart`
- Theme defined in `ERPlusApp` (Material 3, dark mode with blue accent `0xFF2563EB`)

## Development Workflow

### Running the App
```bash
flutter run -d <device>          # Run on specific device
flutter run -d windows           # Windows desktop
flutter run -d chrome            # Web
```

### Code Quality
```bash
flutter analyze                  # Run linter (uses package:flutter_lints)
dart format lib/                 # Format code
flutter pub get                  # Install dependencies
```

### Project Structure Conventions
- Entry point: `lib/main.dart`
- App widget: `lib/src/erplus_app.dart`
- Shell/navigation: `lib/src/shell/`
- Features: `lib/src/features/<feature>/`
- No tests currently exist in the codebase

## Coding Conventions

### UI Patterns
- **Color scheme**: Dark theme (`0xFF0F172A` scaffold, `0xFF020617` containers)
- **Spacing**: Consistent use of `EdgeInsets.all(16)` for main padding
- **Responsive breakpoint**: 900px width (`MediaQuery.of(context).size.width >= 900`)
- **Navigation items**: Pills with rounded borders (`BorderRadius.circular(999)`)

### Widget Organization
- Use `const` constructors wherever possible (already applied consistently)
- StatelessWidget for simple pages, StatefulWidget for interactive components
- Extract methods for reusable UI components (e.g., `_buildSidebar()`, `_buildMenuItem()`)

### Adding New Features
1. Create directory: `lib/src/features/<feature_name>/`
2. Create page: `<feature_name>_page.dart` extending `StatelessWidget`
3. Import in `erplus_shell.dart` and add to `_pages` list
4. Add navigation item via `_buildMenuItem()`

## Dependencies
- **Flutter SDK**: 3.10.0-290.4.beta (beta channel)
- **Material 3**: Enabled via `useMaterial3: true`
- **Cupertino Icons**: 1.0.8
- **Linter**: flutter_lints 6.0.0

## Key Design Decisions
- **No state management library**: Using built-in StatefulWidget for navigation
- **No routing package**: Simple indexed page switching instead of named routes
- **Responsive over adaptive**: Same codebase for all platforms with breakpoint logic
- **Feature isolation**: Each feature is self-contained for easy addition/removal
