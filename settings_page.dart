import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../app/theme/app_theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _locationEnabled = true;
  bool _biometricEnabled = false;
  bool _darkModeEnabled = false;
  String _selectedLanguage = 'English';
  String _selectedTheme = 'System';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        title: Text(
          'Settings',
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppTheme.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileSection(theme),
            const SizedBox(height: 24),
            _buildNotificationSettings(theme),
            const SizedBox(height: 24),
            _buildSecuritySettings(theme),
            const SizedBox(height: 24),
            _buildAppearanceSettings(theme),
            const SizedBox(height: 24),
            _buildPrivacySettings(theme),
            const SizedBox(height: 24),
            _buildSupportSection(theme),
            const SizedBox(height: 24),
            _buildAboutSection(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(ThemeData theme) {
    return _buildSection(
      'Profile',
      [
        _buildProfileCard(theme),
        _buildSettingsTile(
          'Edit Profile',
          'Update your personal information',
          Icons.edit,
          () => _showEditProfileDialog(context),
        ),
        _buildSettingsTile(
          'Change Password',
          'Update your account password',
          Icons.lock,
          () => _showChangePasswordDialog(context),
        ),
      ],
    ).animate().fadeIn().slideY(begin: 0.3);
  }

  Widget _buildProfileCard(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(AppTheme.paddingLarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: Text(
              'JD',
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'John Doe',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'john.doe@company.com',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                Text(
                  'Worker • ID: W001',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _showEditProfileDialog(context),
            icon: const Icon(Icons.edit, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSettings(ThemeData theme) {
    return _buildSection(
      'Notifications',
      [
        _buildSwitchTile(
          'Push Notifications',
          'Receive notifications when app is closed',
          Icons.notifications,
          _notificationsEnabled,
          (value) => setState(() => _notificationsEnabled = value),
        ),
        _buildSettingsTile(
          'Notification Preferences',
          'Customize notification types',
          Icons.tune,
          () => _showNotificationPreferences(context),
        ),
        _buildSettingsTile(
          'Do Not Disturb',
          'Set quiet hours',
          Icons.do_not_disturb,
          () => _showDoNotDisturbSettings(context),
        ),
      ],
    ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.3);
  }

  Widget _buildSecuritySettings(ThemeData theme) {
    return _buildSection(
      'Security',
      [
        _buildSwitchTile(
          'Biometric Login',
          'Use fingerprint or face ID',
          Icons.fingerprint,
          _biometricEnabled,
          (value) => setState(() => _biometricEnabled = value),
        ),
        _buildSwitchTile(
          'Location Services',
          'Allow location tracking for attendance',
          Icons.location_on,
          _locationEnabled,
          (value) => setState(() => _locationEnabled = value),
        ),
        _buildSettingsTile(
          'Two-Factor Authentication',
          'Add extra security to your account',
          Icons.security,
          () => _showTwoFactorSettings(context),
        ),
        _buildSettingsTile(
          'App Lock',
          'Lock app with PIN or biometric',
          Icons.lock_outline,
          () => _showAppLockSettings(context),
        ),
      ],
    ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.3);
  }

  Widget _buildAppearanceSettings(ThemeData theme) {
    return _buildSection(
      'Appearance',
      [
        _buildDropdownTile(
          'Theme',
          'Choose app appearance',
          Icons.palette,
          _selectedTheme,
          ['System', 'Light', 'Dark'],
          (value) => setState(() => _selectedTheme = value),
        ),
        _buildDropdownTile(
          'Language',
          'Select app language',
          Icons.language,
          _selectedLanguage,
          ['English', 'Spanish', 'French', 'German'],
          (value) => setState(() => _selectedLanguage = value),
        ),
        _buildSettingsTile(
          'Font Size',
          'Adjust text size',
          Icons.text_fields,
          () => _showFontSizeSettings(context),
        ),
      ],
    ).animate(delay: 300.ms).fadeIn().slideY(begin: 0.3);
  }

  Widget _buildPrivacySettings(ThemeData theme) {
    return _buildSection(
      'Privacy',
      [
        _buildSettingsTile(
          'Data Usage',
          'View and manage your data',
          Icons.data_usage,
          () => _showDataUsageSettings(context),
        ),
        _buildSettingsTile(
          'Privacy Policy',
          'Read our privacy policy',
          Icons.privacy_tip,
          () => _showPrivacyPolicy(context),
        ),
        _buildSettingsTile(
          'Clear Cache',
          'Free up storage space',
          Icons.cleaning_services,
          () => _showClearCacheDialog(context),
        ),
      ],
    ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.3);
  }

  Widget _buildSupportSection(ThemeData theme) {
    return _buildSection(
      'Support',
      [
        _buildSettingsTile(
          'Help Center',
          'Get help and support',
          Icons.help,
          () => _showHelpCenter(context),
        ),
        _buildSettingsTile(
          'Contact Support',
          'Get in touch with our team',
          Icons.support_agent,
          () => _showContactSupport(context),
        ),
        _buildSettingsTile(
          'Report Issue',
          'Report bugs or problems',
          Icons.bug_report,
          () => _showReportIssue(context),
        ),
        _buildSettingsTile(
          'Rate App',
          'Rate us on the app store',
          Icons.star,
          () => _rateApp(),
        ),
      ],
    ).animate(delay: 500.ms).fadeIn().slideY(begin: 0.3);
  }

  Widget _buildAboutSection(ThemeData theme) {
    return _buildSection(
      'About',
      [
        _buildSettingsTile(
          'App Version',
          '2.1.0 (Build 210)',
          Icons.info,
          null,
        ),
        _buildSettingsTile(
          'Terms of Service',
          'Read our terms and conditions',
          Icons.description,
          () => _showTermsOfService(context),
        ),
        _buildSettingsTile(
          'Licenses',
          'Open source licenses',
          Icons.code,
          () => _showLicenses(context),
        ),
        _buildSettingsTile(
          'Sign Out',
          'Sign out of your account',
          Icons.logout,
          () => _showSignOutDialog(context),
          isDestructive: true,
        ),
      ],
    ).animate(delay: 600.ms).fadeIn().slideY(begin: 0.3);
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSettingsTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback? onTap, {
    bool isDestructive = false,
  }) {
    final theme = Theme.of(context);
    
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : theme.colorScheme.primary,
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: isDestructive ? Colors.red : theme.colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
      trailing: onTap != null ? const Icon(Icons.chevron_right) : null,
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    final theme = Theme.of(context);
    
    return SwitchListTile(
      secondary: Icon(icon, color: theme.colorScheme.primary),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildDropdownTile(
    String title,
    String subtitle,
    IconData icon,
    String value,
    List<String> options,
    ValueChanged<String> onChanged,
  ) {
    final theme = Theme.of(context);
    
    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
      trailing: DropdownButton<String>(
        value: value,
        underline: const SizedBox(),
        items: options.map((option) => 
          DropdownMenuItem(
            value: option,
            child: Text(option),
          ),
        ).toList(),
        onChanged: (newValue) => onChanged(newValue!),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    final nameController = TextEditingController(text: 'John Doe');
    final emailController = TextEditingController(text: 'john.doe@company.com');
    final phoneController = TextEditingController(text: '+1 234 567 8900');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar('Profile updated successfully');
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm New Password',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar('Password changed successfully');
            },
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }

  void _showNotificationPreferences(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(AppTheme.paddingLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Notification Preferences',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Task Notifications'),
              value: true,
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: const Text('Chat Messages'),
              value: true,
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: const Text('Attendance Reminders'),
              value: false,
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: const Text('System Updates'),
              value: true,
              onChanged: (value) {},
            ),
          ],
        ),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out of your account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar('Signed out successfully');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Sign Out', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showDoNotDisturbSettings(BuildContext context) {
    _showSnackBar('Do Not Disturb settings opened');
  }

  void _showTwoFactorSettings(BuildContext context) {
    _showSnackBar('Two-Factor Authentication settings opened');
  }

  void _showAppLockSettings(BuildContext context) {
    _showSnackBar('App Lock settings opened');
  }

  void _showFontSizeSettings(BuildContext context) {
    _showSnackBar('Font size settings opened');
  }

  void _showDataUsageSettings(BuildContext context) {
    _showSnackBar('Data usage settings opened');
  }

  void _showPrivacyPolicy(BuildContext context) {
    _showSnackBar('Privacy policy opened');
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text('This will clear temporary files and free up storage space. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar('Cache cleared successfully');
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showHelpCenter(BuildContext context) {
    _showSnackBar('Help center opened');
  }

  void _showContactSupport(BuildContext context) {
    _showSnackBar('Contact support opened');
  }

  void _showReportIssue(BuildContext context) {
    _showSnackBar('Report issue opened');
  }

  void _rateApp() {
    _showSnackBar('App store opened for rating');
  }

  void _showTermsOfService(BuildContext context) {
    _showSnackBar('Terms of service opened');
  }

  void _showLicenses(BuildContext context) {
    showLicensePage(context: context);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
