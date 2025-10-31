import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/theme_provider.dart';
import '../../settings/riverpod/settings_provider.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailAsync = ref.watch(userEmailProvider);
    final themeMode = ref.watch(themeNotifierProvider);

    // final logoutUseCase = ref.read(logoutUseCaseProvider);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.person, size: 48, color: Colors.white),
                const SizedBox(height: 8),
                Text(
                  emailAsync.when(
                    data: (email) => email ?? 'User',
                    loading: () => 'Loading...',
                    error: (_, __) => 'User',
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Theme'),
            subtitle: Text(
              themeMode == ThemeMode.dark ? 'Dark Mode' : 'Light Mode',
            ),
            trailing: Switch(
              value: themeMode == ThemeMode.dark,
              onChanged: (value) {
                final themeNotifier = ref.read(themeNotifierProvider.notifier);
                themeNotifier.toggleTheme();
              },
            ),
            onTap: () {
              final themeNotifier = ref.read(themeNotifierProvider.notifier);
              themeNotifier.toggleTheme();
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout'),
            onTap: () async {
              // Show confirmation dialog
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );

              // if (shouldLogout == true) {
              //   await logoutUseCase.execute();
              //   // Clear all providers
              //   ref.invalidate(cacheServiceProvider);
              //   // Navigate to login
              //   if (context.mounted) {
              //     context.go('/login'); // Adjust route as needed
              //   }
              // }
            },
          ),
        ],
      ),
    );
  }
}
