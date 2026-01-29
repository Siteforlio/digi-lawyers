import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:only_law_app/features/splash/presentation/splash_screen.dart';
import 'package:only_law_app/features/main_shell/presentation/screens/main_shell_screen.dart';
import 'package:only_law_app/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:only_law_app/features/cases/presentation/screens/cases_screen.dart';
import 'package:only_law_app/features/cases/presentation/screens/case_detail_screen.dart';
import 'package:only_law_app/features/cases/presentation/screens/add_case_screen.dart';
import 'package:only_law_app/features/calendar/presentation/screens/calendar_screen.dart';
import 'package:only_law_app/features/calendar/presentation/screens/add_event_screen.dart';
import 'package:only_law_app/features/feed/presentation/screens/feed_screen.dart';
import 'package:only_law_app/features/feed/presentation/screens/post_detail_screen.dart';
import 'package:only_law_app/features/feed/presentation/screens/create_post_screen.dart';
import 'package:only_law_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:only_law_app/features/settings/presentation/screens/settings_screen.dart';
import 'package:only_law_app/features/billing/presentation/screens/billing_screen.dart';
import 'package:only_law_app/features/billing/presentation/screens/create_invoice_screen.dart';
import 'package:only_law_app/features/clients/presentation/screens/clients_screen.dart';
import 'package:only_law_app/features/clients/presentation/screens/client_detail_screen.dart';
import 'package:only_law_app/features/clients/presentation/screens/add_client_screen.dart';
import 'package:only_law_app/features/documents/presentation/screens/documents_screen.dart';
import 'package:only_law_app/features/jobs/presentation/screens/jobs_screen.dart';
import 'package:only_law_app/features/jobs/presentation/screens/job_detail_screen.dart';
import 'package:only_law_app/features/jobs/presentation/screens/post_job_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShellScreen(navigationShell: navigationShell);
        },
        branches: [
          // Dashboard Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard',
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          // Cases Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/cases',
                builder: (context, state) => const CasesScreen(),
              ),
            ],
          ),
          // Calendar Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/calendar',
                builder: (context, state) => const CalendarScreen(),
              ),
            ],
          ),
          // Feed Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/feed',
                builder: (context, state) => const FeedScreen(),
              ),
            ],
          ),
          // Profile Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      // Routes outside shell (full screen)
      GoRoute(
        path: '/cases/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final caseId = state.pathParameters['id']!;
          return CaseDetailScreen(caseId: caseId);
        },
      ),
      GoRoute(
        path: '/cases/add',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AddCaseScreen(),
      ),
      GoRoute(
        path: '/calendar/add',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AddEventScreen(),
      ),
      GoRoute(
        path: '/feed/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final postId = state.pathParameters['id']!;
          return PostDetailScreen(postId: postId);
        },
      ),
      GoRoute(
        path: '/feed/create',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CreatePostScreen(),
      ),
      GoRoute(
        path: '/settings',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SettingsScreen(),
      ),
      // Billing routes
      GoRoute(
        path: '/billing',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const BillingScreen(),
      ),
      GoRoute(
        path: '/billing/create',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CreateInvoiceScreen(),
      ),
      // Clients routes
      GoRoute(
        path: '/clients',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ClientsScreen(),
      ),
      GoRoute(
        path: '/clients/add',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AddClientScreen(),
      ),
      GoRoute(
        path: '/clients/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final clientId = state.pathParameters['id']!;
          return ClientDetailScreen(clientId: clientId);
        },
      ),
      // Documents routes
      GoRoute(
        path: '/documents',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const DocumentsScreen(),
      ),
      // Jobs routes
      GoRoute(
        path: '/jobs',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const JobsScreen(),
      ),
      GoRoute(
        path: '/jobs/post',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const PostJobScreen(),
      ),
      GoRoute(
        path: '/jobs/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final jobId = state.pathParameters['id']!;
          return JobDetailScreen(jobId: jobId);
        },
      ),
    ],
  );
}
