import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:only_law_app/features/splash/presentation/splash_screen.dart';
import 'package:only_law_app/features/auth/presentation/screens/login_screen.dart';
import 'package:only_law_app/features/auth/presentation/screens/register_screen.dart';
import 'package:only_law_app/features/auth/presentation/screens/otp_screen.dart';
import 'package:only_law_app/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:only_law_app/features/auth/presentation/screens/profile_setup_screen.dart';
import 'package:only_law_app/features/main_shell/presentation/screens/main_shell_screen.dart';
import 'package:only_law_app/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:only_law_app/features/cases/presentation/screens/cases_screen.dart';
import 'package:only_law_app/features/cases/presentation/screens/case_detail_screen.dart';
import 'package:only_law_app/features/cases/presentation/screens/add_case_screen.dart';
import 'package:only_law_app/features/calendar/presentation/screens/calendar_screen.dart';
import 'package:only_law_app/features/calendar/presentation/screens/add_event_screen.dart';
import 'package:only_law_app/features/calendar/presentation/screens/calendar_sync_screen.dart';
import 'package:only_law_app/features/feed/presentation/screens/feed_screen.dart';
import 'package:only_law_app/features/feed/presentation/screens/post_detail_screen.dart';
import 'package:only_law_app/features/feed/presentation/screens/create_post_screen.dart';
import 'package:only_law_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:only_law_app/features/settings/presentation/screens/settings_screen.dart';
import 'package:only_law_app/features/settings/presentation/screens/notification_settings_screen.dart';
import 'package:only_law_app/features/settings/presentation/screens/security_settings_screen.dart';
import 'package:only_law_app/features/settings/presentation/screens/privacy_settings_screen.dart';
import 'package:only_law_app/features/settings/presentation/screens/appearance_settings_screen.dart';
import 'package:only_law_app/features/settings/presentation/screens/storage_settings_screen.dart';
import 'package:only_law_app/features/settings/presentation/screens/help_support_screen.dart';
import 'package:only_law_app/features/settings/presentation/screens/about_screen.dart';
import 'package:only_law_app/features/billing/presentation/screens/billing_screen.dart';
import 'package:only_law_app/features/billing/presentation/screens/create_invoice_screen.dart';
import 'package:only_law_app/features/clients/presentation/screens/clients_screen.dart';
import 'package:only_law_app/features/clients/presentation/screens/client_detail_screen.dart';
import 'package:only_law_app/features/clients/presentation/screens/add_client_screen.dart';
import 'package:only_law_app/features/documents/presentation/screens/documents_screen.dart';
import 'package:only_law_app/features/jobs/presentation/screens/jobs_screen.dart';
import 'package:only_law_app/features/jobs/presentation/screens/job_detail_screen.dart';
import 'package:only_law_app/features/jobs/presentation/screens/post_job_screen.dart';
import 'package:only_law_app/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:only_law_app/features/leads/presentation/screens/leads_screen.dart';
import 'package:only_law_app/features/leads/presentation/screens/lead_detail_screen.dart';
import 'package:only_law_app/features/network/presentation/screens/network_screen.dart';

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
      // Auth routes (public)
      GoRoute(
        path: '/login',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/otp',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return OtpScreen(
            phone: extra?['phone'] ?? '',
            isRegistration: extra?['isRegistration'] ?? false,
          );
        },
      ),
      GoRoute(
        path: '/forgot-password',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/profile-setup',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ProfileSetupScreen(),
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
        path: '/calendar/sync',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CalendarSyncScreen(),
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
      GoRoute(
        path: '/settings/notifications',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const NotificationSettingsScreen(),
      ),
      GoRoute(
        path: '/settings/security',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SecuritySettingsScreen(),
      ),
      GoRoute(
        path: '/settings/privacy',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const PrivacySettingsScreen(),
      ),
      GoRoute(
        path: '/settings/appearance',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AppearanceSettingsScreen(),
      ),
      GoRoute(
        path: '/settings/storage',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const StorageSettingsScreen(),
      ),
      GoRoute(
        path: '/settings/help',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const HelpSupportScreen(),
      ),
      GoRoute(
        path: '/settings/about',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AboutScreen(),
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
      // Notifications routes
      GoRoute(
        path: '/notifications',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const NotificationsScreen(),
      ),
      // Leads routes
      GoRoute(
        path: '/leads',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const LeadsScreen(),
      ),
      GoRoute(
        path: '/leads/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final leadId = state.pathParameters['id']!;
          return LeadDetailScreen(leadId: leadId);
        },
      ),
      // Network routes
      GoRoute(
        path: '/network',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const NetworkScreen(),
      ),
    ],
  );
}
