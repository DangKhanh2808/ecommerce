import 'package:ecommerce/common/widgets/appbar/app_bar.dart';
import 'package:flutter/material.dart';

class PrivacySettingsPage extends StatefulWidget {
  const PrivacySettingsPage({super.key});

  @override
  State<PrivacySettingsPage> createState() => _PrivacySettingsPageState();
}

class _PrivacySettingsPageState extends State<PrivacySettingsPage> {
  bool _showEmail = true;
  bool _showPhone = false;
  bool _showAddress = false;
  bool _notifications = true;
  bool _marketingEmails = false;
  bool _dataSharing = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: const BasicAppbar(
        title: Text('Privacy Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      Icons.privacy_tip,
                      size: 48,
                      color: theme.primaryColor,
                    ),
                    const SizedBox(height: 16),
                                          Text(
                        'Privacy Management',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Control your personal information and privacy settings',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Profile Visibility
            Text(
              'Information Visibility',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Show Email'),
                    subtitle: const Text('Allow others to see your email'),
                    value: _showEmail,
                    onChanged: (value) {
                      setState(() {
                        _showEmail = value;
                      });
                    },
                    secondary: const Icon(Icons.email),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Show Phone Number'),
                    subtitle: const Text('Allow others to see your phone number'),
                    value: _showPhone,
                    onChanged: (value) {
                      setState(() {
                        _showPhone = value;
                      });
                    },
                    secondary: const Icon(Icons.phone),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Show Address'),
                    subtitle: const Text('Allow others to see your address'),
                    value: _showAddress,
                    onChanged: (value) {
                      setState(() {
                        _showAddress = value;
                      });
                    },
                    secondary: const Icon(Icons.location_on),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Notifications
            Text(
              'Notifications',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Push Notifications'),
                    subtitle: const Text('Receive notifications about orders and updates'),
                    value: _notifications,
                    onChanged: (value) {
                      setState(() {
                        _notifications = value;
                      });
                    },
                    secondary: const Icon(Icons.notifications),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Marketing Emails'),
                    subtitle: const Text('Receive emails about new products and promotions'),
                    value: _marketingEmails,
                    onChanged: (value) {
                      setState(() {
                        _marketingEmails = value;
                      });
                    },
                    secondary: const Icon(Icons.campaign),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Data Sharing
            Text(
              'Data Sharing',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Anonymous Data Sharing'),
                    subtitle: const Text('Allow sharing data to improve service'),
                    value: _dataSharing,
                    onChanged: (value) {
                      setState(() {
                        _dataSharing = value;
                      });
                    },
                    secondary: const Icon(Icons.share),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Privacy Policy
            Card(
              child: ListTile(
                leading: const Icon(Icons.description),
                title: const Text('Privacy Policy'),
                subtitle: const Text('Read our privacy policy'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // TODO: Navigate to privacy policy
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Privacy policy will be opened'),
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Save privacy settings
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Privacy settings saved'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Save Settings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Reset Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _showEmail = true;
                    _showPhone = false;
                    _showAddress = false;
                    _notifications = true;
                    _marketingEmails = false;
                    _dataSharing = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Settings reset to default'),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Reset to Default',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 