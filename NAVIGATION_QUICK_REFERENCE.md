# 🚀 GoRouter Quick Reference

## Import This

```dart
import 'package:go_router/go_router.dart';
import 'package:lost_n_found/app/routes/route_constants.dart';
import 'package:lost_n_found/app/routes/router_extensions.dart'; // For extensions
```

---

## Basic Navigation

| Action | Code |
|--------|------|
| Go to route (replace stack) | `context.go(RouteConstants.dashboard)` |
| Push route (add to stack) | `context.push(RouteConstants.reportItem)` |
| Go back | `context.pop()` |
| Pop with result | `context.pop(result)` |
| Check if can pop | `if (context.canPop()) ...` |

---

## Extension Methods (Recommended)

| Destination | Code |
|-------------|------|
| Login | `context.goToLogin()` |
| Signup | `context.goToSignup()` |
| Dashboard | `context.goToDashboard()` |
| Onboarding | `context.goToOnboarding()` |
| Report Item | `context.goToReportItem()` |
| Batches | `context.goToBatches()` |

### Item Detail (with data)

```dart
context.goToItemDetail(
  id: '123',
  title: 'Lost Wallet',
  location: 'Library',
  category: 'Personal',
  isLost: true,
  reportedBy: 'John Doe',
  imageUrl: 'https://...',
);
```

---

## Route Constants

```dart
RouteConstants.splash        // '/'
RouteConstants.onboarding    // '/onboarding'
RouteConstants.login         // '/login'
RouteConstants.signup        // '/signup'
RouteConstants.dashboard     // '/dashboard'
RouteConstants.reportItem    // '/report-item'
RouteConstants.batches       // '/batches'
RouteConstants.itemDetail    // '/item/:id'

// Helper methods
RouteConstants.itemDetailWithId('123') // '/item/123'
```

---

## Common Patterns

### Navigate after async operation

```dart
Future<void> _doSomething() async {
  await someAsyncOperation();

  if (!mounted) return; // ← Important!

  context.goToDashboard();
}
```

### Navigate based on condition

```dart
if (isSuccess) {
  context.goToDashboard();
} else {
  context.goToLogin();
}
```

### Pass data between pages

```dart
// Using extra parameter
context.push(
  RouteConstants.itemDetail,
  extra: {
    'title': 'Lost Wallet',
    'location': 'Library',
  },
);

// In destination page
final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
final title = extra?['title'] ?? 'Unknown';
```

---

## Replacing Old Code

### Before (Navigator 1.0)
```dart
import '../../../../app/routes/app_routes.dart';

AppRoutes.push(context, ItemDetailPage(...));
AppRoutes.pushReplacement(context, DashboardPage());
AppRoutes.pushAndRemoveUntil(context, LoginPage());
Navigator.pop(context);
```

### After (GoRouter)
```dart
import 'package:go_router/go_router.dart';
import '../../../../app/routes/router_extensions.dart';

context.push(RouteConstants.itemDetail, extra: {...});
context.go(RouteConstants.dashboard);  // Replaces stack
context.go(RouteConstants.login);      // Replaces stack
context.pop();
```

---

## Protected Routes

These routes **require authentication**:
- `/dashboard`
- `/report-item`
- `/item/:id`
- `/batches`

If user is not authenticated → **Auto-redirect to `/login`**

---

## Debugging

### Check current route
```dart
final currentRoute = context.currentRoute;
print('Current route: $currentRoute');
```

### Check if on specific page
```dart
if (context.isOnLoginPage) {
  // Do something
}

if (context.isOnDashboard) {
  // Do something
}
```

---

## Error Handling

### 404 - Route Not Found
- Automatically shows error page
- "Go to Home" button navigates to dashboard

---

## Pro Tips

1. ✅ Always use `if (!mounted) return;` before navigation in async functions
2. ✅ Use `context.go()` to replace navigation stack
3. ✅ Use `context.push()` to add to navigation stack
4. ✅ Use extension methods for cleaner code
5. ✅ Use route constants to avoid typos

---

## Need Help?

- Full Guide: `GOROUTER_IMPLEMENTATION.md`
- Route Constants: `lib/app/routes/route_constants.dart`
- Router Config: `lib/app/routes/app_router.dart`
- Extensions: `lib/app/routes/router_extensions.dart`
