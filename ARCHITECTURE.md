# Only Law App - Architecture Guide

## Overview

This document establishes the architectural rules and patterns that **must** be followed when developing this application. These guidelines ensure consistency, maintainability, and scalability.

---

## Core Principles

### 1. Single Responsibility Principle (SRP)
- **One file = One purpose**
- **Maximum 150 lines per file** (excluding imports and comments)
- **Maximum 3-5 public methods/functions per class**
- If a file exceeds these limits, it must be refactored into smaller units

### 2. Feature-First Architecture
We use a **feature-first** folder structure, not a type-first structure.

```
lib/
├── core/                    # Shared app-wide utilities
│   ├── config/              # App configuration (env, constants)
│   ├── theme/               # Theming (colors, typography, spacing)
│   ├── router/              # Navigation configuration
│   ├── utils/               # Pure utility functions
│   ├── extensions/          # Dart extensions
│   └── errors/              # Error handling, exceptions
│
├── features/                # Feature modules (the heart of the app)
│   └── [feature_name]/
│       ├── data/            # Data layer
│       │   ├── models/      # Data models (DTOs, entities)
│       │   ├── repositories/ # Repository implementations
│       │   └── datasources/ # API clients, local storage
│       ├── domain/          # Business logic layer
│       │   ├── entities/    # Business entities
│       │   ├── repositories/ # Repository interfaces (contracts)
│       │   └── usecases/    # Use cases (one per file)
│       └── presentation/    # UI layer
│           ├── screens/     # Full page widgets
│           ├── widgets/     # Feature-specific widgets
│           ├── providers/   # State management (Provider/Riverpod)
│           └── controllers/ # Screen controllers/view models
│
├── shared/                  # Shared across features
│   ├── widgets/             # Reusable UI components
│   ├── constants/           # App-wide constants
│   └── services/            # Shared services (analytics, logging)
│
└── main.dart                # App entry point (minimal code)
```

---

## File Organization Rules

### Rule 1: One Class Per File
```dart
// WRONG - Multiple classes in one file
// law_stuff.dart
class Law { }
class LawRepository { }
class LawService { }
class LawWidget { }

// CORRECT - Separate files
// models/law.dart
class Law { }

// repositories/law_repository.dart
class LawRepository { }

// services/law_service.dart
class LawService { }

// widgets/law_card.dart
class LawCard extends StatelessWidget { }
```

### Rule 2: Private Helper Classes Exception
Private helper classes (`_ClassName`) used only within one file may stay in that file:
```dart
// home_screen.dart - This is acceptable
class HomeScreen extends StatelessWidget { }

class _ServiceItem {  // Private, only used in this file
  final IconData icon;
  final String label;
}
```

### Rule 3: File Naming Convention
- Use `snake_case` for all file names
- Name files after the primary class they contain
- Suffix files by their type:
  - `*_screen.dart` - Full page screens
  - `*_widget.dart` - Reusable widgets
  - `*_model.dart` - Data models
  - `*_repository.dart` - Repositories
  - `*_service.dart` - Services
  - `*_provider.dart` - State providers
  - `*_controller.dart` - Controllers
  - `*_usecase.dart` - Use cases

---

## Layer Separation Rules

### Data Layer (`data/`)
- **Purpose**: External data handling (API, database, cache)
- **Dependencies**: Can depend on external packages
- **Contains**:
  - Models (JSON serialization)
  - Repository implementations
  - Data sources (API clients, local DB)

```dart
// data/models/statute_model.dart
class StatuteModel {
  final String id;
  final String title;
  final String content;

  StatuteModel({required this.id, required this.title, required this.content});

  factory StatuteModel.fromJson(Map<String, dynamic> json) => StatuteModel(
    id: json['id'],
    title: json['title'],
    content: json['content'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
  };
}
```

### Domain Layer (`domain/`)
- **Purpose**: Business logic, pure Dart
- **Dependencies**: NO external packages (except core Dart)
- **Contains**:
  - Entities (business objects)
  - Repository interfaces (abstract classes)
  - Use cases (one action per class)

```dart
// domain/usecases/search_laws_usecase.dart
abstract class UseCase<T, Params> {
  Future<T> call(Params params);
}

class SearchLawsUseCase implements UseCase<List<Law>, SearchParams> {
  final LawRepository repository;

  SearchLawsUseCase(this.repository);

  @override
  Future<List<Law>> call(SearchParams params) => repository.searchLaws(params.query);
}
```

### Presentation Layer (`presentation/`)
- **Purpose**: UI and state management
- **Dependencies**: Flutter, state management packages
- **Contains**:
  - Screens (pages)
  - Widgets (UI components)
  - Providers/Controllers (state)

---

## Widget Organization Rules

### Rule 4: Extract Widgets at 50+ Lines
If a widget's `build` method exceeds 50 lines, extract parts into separate widgets.

```dart
// WRONG - Monolithic build method
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 200 lines of nested widgets...
    );
  }
}

// CORRECT - Extracted widgets
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const HomeWelcomeCard(),
          const ServicesGrid(),
          const LatestUpdatesList(),
        ],
      ),
    );
  }
}
```

### Rule 5: Widget Extraction Locations
- **Feature-specific widgets**: `features/[feature]/presentation/widgets/`
- **Shared widgets**: `shared/widgets/`

### Rule 6: Widget Naming
- Prefix with feature name if feature-specific: `HomeServicesGrid`
- Use descriptive names: `LawCard`, `StatuteListTile`
- Avoid generic names: `MyWidget`, `CustomContainer`

---

## State Management Rules

### Rule 7: Provider Structure
```dart
// providers/laws_provider.dart
class LawsProvider extends ChangeNotifier {
  final SearchLawsUseCase _searchLawsUseCase;

  List<Law> _laws = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Law> get laws => _laws;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Actions (max 5 per provider)
  Future<void> searchLaws(String query) async { }
  Future<void> loadPopularLaws() async { }
  void clearResults() { }
}
```

### Rule 8: One Provider Per Feature Domain
- `LawsProvider` - handles law search and display
- `BookmarksProvider` - handles saved items
- `AuthProvider` - handles authentication

---

## Import Rules

### Rule 9: Import Order
```dart
// 1. Dart imports
import 'dart:async';
import 'dart:convert';

// 2. Flutter imports
import 'package:flutter/material.dart';

// 3. Package imports (alphabetical)
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// 4. Project imports (alphabetical)
import 'package:only_law_app/core/config/env_config.dart';
import 'package:only_law_app/features/home/presentation/widgets/home_header.dart';
```

### Rule 10: No Relative Imports
```dart
// WRONG
import '../../../core/theme/app_theme.dart';

// CORRECT
import 'package:only_law_app/core/theme/app_theme.dart';
```

---

## Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Files | snake_case | `law_repository.dart` |
| Classes | PascalCase | `LawRepository` |
| Variables | camelCase | `statuteTitle` |
| Constants | camelCase or SCREAMING_SNAKE_CASE | `maxResults` or `MAX_RESULTS` |
| Private | Prefix with `_` | `_privateMethod()` |
| Widgets | PascalCase + descriptive | `StatuteDetailCard` |

---

## Code Quality Checklist

Before committing any code, verify:

- [ ] File has single responsibility
- [ ] File is under 150 lines
- [ ] Class has max 5 public methods
- [ ] Build method is under 50 lines
- [ ] Imports are ordered correctly
- [ ] No relative imports used
- [ ] Naming conventions followed
- [ ] Widget extracted if reusable

---

## Refactoring Triggers

**Immediately refactor when:**
1. A file exceeds 150 lines
2. A class has more than 5 public methods
3. A build method exceeds 50 lines
4. You copy-paste code (extract to shared)
5. A widget is used in 2+ places (move to shared)

---

## Environment Configuration

All environment-specific values must be in `.env`:

```env
APP_NAME=Only Law
APP_VERSION=1.0.0
API_BASE_URL=https://api.example.com
```

Access via `EnvConfig`:
```dart
final appName = EnvConfig.appName;
```

**Never hardcode:**
- API URLs
- API keys
- Feature flags
- App metadata

---

## Example: Adding a New Feature

When adding a new feature (e.g., "Bookmarks"):

```
1. Create feature folder structure:
   features/bookmarks/
   ├── data/
   │   ├── models/bookmark_model.dart
   │   ├── repositories/bookmark_repository_impl.dart
   │   └── datasources/bookmark_local_storage.dart
   ├── domain/
   │   ├── entities/bookmark.dart
   │   ├── repositories/bookmark_repository.dart
   │   └── usecases/
   │       ├── get_bookmarks_usecase.dart
   │       ├── add_bookmark_usecase.dart
   │       └── remove_bookmark_usecase.dart
   └── presentation/
       ├── screens/bookmarks_screen.dart
       ├── widgets/
       │   ├── bookmark_card.dart
       │   └── bookmark_list.dart
       └── providers/bookmarks_provider.dart

2. Register routes in core/router/app_router.dart
3. Register providers in main.dart or a providers file
4. Add any shared widgets to shared/widgets/
```

---

## Anti-Patterns to Avoid

1. **God Classes**: Classes that do everything
2. **Spaghetti Imports**: Circular or tangled dependencies
3. **Magic Numbers**: Use constants instead
4. **Deep Nesting**: Max 3-4 levels of widget nesting
5. **Business Logic in Widgets**: Keep in domain/usecases
6. **Direct API Calls in Widgets**: Use repositories

---

## Questions?

If unsure about architecture decisions:
1. Check if similar pattern exists in codebase
2. Follow the principle of least surprise
3. Prefer simplicity over cleverness
4. When in doubt, extract and separate

**Remember**: Good architecture is invisible. If you're fighting the structure, it's wrong.
