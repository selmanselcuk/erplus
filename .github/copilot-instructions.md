````instructions
# ERPlus - AI Coding Agent Instructions (updated)

## **Overview**
ERPlus is a Flutter-based ERP UI shell (desktop-first, responsive). Navigation is handled by a central shell widget (`lib/src/shell/erplus_shell.dart`) that opens feature pages as workspace "tabs". Features live under `lib/src/features/` and are mostly self-contained widgets.

## **Architecture (big picture)**
- **Shell**: `lib/src/shell/erplus_shell.dart` manages sidebar, workspace tabs and active page rendering. Wide screens (≥900px) use sidebar + panel; narrow screens use AppBar + Drawer.
- **App entry**: `lib/main.dart` → `lib/src/erplus_app.dart` (theme selection) → `ERPlusShell`.
- **Features**: Each feature folder contains its page widgets, e.g. `lib/src/features/dashboard/dashboard_page.dart`, `lib/src/features/customers/*`.
- **State & navigation patterns**: Shell keeps a `_tabs` list of `_WorkspaceTabItem` (id + builder). Pages are opened/closed by id strings (e.g. `module_0`, `customer_card`) and callbacks are used to request opening sub-pages (see `CustomersPage(onOpenCustomerCard: ...)`).

## **Key files to inspect**
- `lib/src/shell/erplus_shell.dart` : central navigation & UI shell (tabs, sidebar, responsive layout).
- `lib/src/erplus_app.dart` : theme definitions and chosen theme.
- `lib/src/features/` : feature modules; add new features here.
- `pubspec.yaml` : platform packages, assets/fonts configuration (assets commented out by default).

## **How to add a feature (concrete steps)**
1. Create `lib/src/features/<feature>/` and add `<feature>_page.dart` (StatelessWidget/StatefulWidget).
2. In `erplus_shell.dart`:
   - Add import for the page (top of file).
   - Update `_menuItems` if the feature needs a sidebar entry.
   - In `_buildModuleTab` switch-case, map a menu index to your page builder (return a `_WorkspaceTabItem` with `id: 'module_<index>'`).
3. If your feature must open a detail card (like customer card), provide a callback on the page constructor (pattern used by `CustomersPage` → `CustomerCardPage`).
4. If you add assets, register them in `pubspec.yaml` under `flutter.assets` and run `flutter pub get`.

## **Dev / build / debug commands (PowerShell examples)**
- Install deps: `flutter pub get`
- Run on Windows desktop: `flutter run -d windows`
- Run on web: `flutter run -d chrome`
- Analyze & format: `flutter analyze` and `dart format lib/`
- Verbose run (diagnostics): `flutter run -d windows -v`
- VS Code: run the `lib/main.dart` configuration or press F5; attach debugger to running `flutter run` when needed.

## **Project conventions & patterns**
- Responsive breakpoint: 900px (see `MediaQuery.of(context).size.width >= 900`).
- Theme selection: `ERPlusApp` defines several theme variants; change the `theme:` assignment to pick one (comments in `erplus_app.dart`).
- UI primitives: prefer `const` constructors where possible; use extracted helper builders (`_buildSidebarContent`, `_buildWorkspaceTabs`, etc.).
- Tabs: workspace tabs are lightweight descriptors that store a `WidgetBuilder` not a full instantiated widget — prefer builders to preserve lazy construction and keyed switching.

## **Integration points & notes**
- Native runners available: `windows/`, `linux/`, `macos/`, `ios/`, `android/` — platform-specific code will live under these folders if/when needed.
- Plugin registration files are generated under `build/` and platform `runner/` folders (no manual edits required normally).
- No external state-management library is used — features communicate via callbacks and shell-controlled tab ids.

## **Where to look when debugging common tasks**
- Navigation/tab issues: inspect `_tabs`, `_activeTabId` and `_openModuleFromSidebar` / `_openCustomerCardTab` in `erplus_shell.dart`.
- Theme / color problems: inspect `_corporateLightTheme`, `_appleLightTheme`, `_materialLightTheme` in `lib/src/erplus_app.dart`.
- Assets not loading: ensure `pubspec.yaml` has `flutter.assets` entries and run `flutter pub get`.

## **Quick examples (copy-paste)**
- Add import + tab mapping in `erplus_shell.dart`:
  ```dart
  import '../features/myfeature/myfeature_page.dart';

  // inside _buildModuleTab switch:
  case 4:
    builder = (ctx) => const MyFeaturePage();
    break;
  ```

## **Final notes**
- Tests: currently no unit/widget tests in the repo — prefer to add focused widget tests for new feature pages.
- Keep changes minimal: follow existing style (no trailing comments, use `const` where possible).

If any part is unclear or you want me to add examples for a specific feature (e.g. wiring a new feature + test), tell me which feature and I will update this file.

````
- **Cupertino Icons**: 1.0.8
