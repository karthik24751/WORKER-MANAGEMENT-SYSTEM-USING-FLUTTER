import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../../app/routes/app_router.dart';
import '../../../../app/theme/app_theme.dart';

class WorkerDashboardPage extends StatefulWidget {
  const WorkerDashboardPage({super.key});

  @override
  State<WorkerDashboardPage> createState() => _WorkerDashboardPageState();
}

class _WorkerDashboardPageState extends State<WorkerDashboardPage> {
  bool _isCheckedIn = false;
  String _currentLocation = 'Fetching location...';
  bool _isLocationValid = false;
  File? _attendancePhoto;
  final ImagePicker _picker = ImagePicker();
  DateTime? _checkInTime;
  Duration _workDuration = Duration.zero;

  // Centurion University Vizianagram coordinates
  static const double _universityLat = 18.1124;
  static const double _universityLng = 83.4316;
  static const double _allowedRadius = 50.0; // 50 meters

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    _startWorkTimer();
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _currentLocation = 'Location services disabled';
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _currentLocation = 'Location permission denied';
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _currentLocation = 'Location permission permanently denied';
      });
      return;
    }

    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      double distance = _calculateDistance(
        position.latitude,
        position.longitude,
        _universityLat,
        _universityLng,
      );

      setState(() {
        _currentLocation = 'Distance from university: ${distance.toStringAsFixed(1)}m';
        _isLocationValid = distance <= _allowedRadius;
      });
    } catch (e) {
      setState(() {
        _currentLocation = 'Error getting location: $e';
      });
    }
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }

  Future<void> _takeSelfie() async {
    if (!_isLocationValid) {
      _showLocationError();
      return;
    }

    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        maxWidth: 800,
        maxHeight: 600,
        imageQuality: 80,
      );

      if (photo != null) {
        setState(() {
          _attendancePhoto = File(photo.path);
        });
        _markAttendance();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error taking photo: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _markAttendance() {
    setState(() {
      _isCheckedIn = !_isCheckedIn;
      if (_isCheckedIn) {
        _checkInTime = DateTime.now();
        _startWorkTimer();
      } else {
        _checkInTime = null;
        _workDuration = Duration.zero;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isCheckedIn 
            ? '✅ Attendance marked successfully with selfie!'
            : '✅ Checked out successfully!',
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showLocationError() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Required'),
        content: Text(
          'You must be within ${_allowedRadius.toInt()} meters of Centurion University Vizianagram to mark attendance.\n\n'
          'Current status: $_currentLocation',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _getCurrentLocation();
            },
            child: const Text('Refresh Location'),
          ),
        ],
      ),
    );
  }

  void _startWorkTimer() {
    if (_isCheckedIn && _checkInTime != null) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted && _isCheckedIn) {
          setState(() {
            _workDuration = DateTime.now().difference(_checkInTime!);
          });
          _startWorkTimer();
        }
      });
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Worker Dashboard'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => AppRouter.goToNotifications(context),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => AppRouter.goToSettings(context),
          ),
        ],
      ),
      backgroundColor: theme.colorScheme.surface,
      body: RefreshIndicator(
        onRefresh: _getCurrentLocation,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(AppTheme.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(theme),
              const SizedBox(height: 24),

              // GPS Selfie Attendance Card
              _buildGPSSelfieAttendanceCard(theme),
              const SizedBox(height: 20),

              // Quick Actions
              _buildQuickActions(theme),
              const SizedBox(height: 20),

              // Today's Tasks
              _buildTodaysTasks(theme),
              const SizedBox(height: 20),

              // Recent Activity
              _buildRecentActivity(theme),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(theme),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good Morning,',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              Text(
                'John Worker',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => AppRouter.goToProfile(context),
          icon: CircleAvatar(
            radius: 20,
            backgroundColor: theme.colorScheme.primary,
            child: Text(
              'JW',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    ).animate().fadeIn().slideX(begin: -0.3);
  }

  Widget _buildGPSSelfieAttendanceCard(ThemeData theme) {
    return Container(
      width: double.infinity,
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
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _isLocationValid 
                    ? Colors.green.withOpacity(0.2)
                    : Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _isLocationValid ? Icons.location_on : Icons.location_off,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isCheckedIn ? 'Checked In' : 'GPS Selfie Attendance',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _isCheckedIn 
                          ? 'Working for ${_formatDuration(_workDuration)}'
                          : _currentLocation,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          if (_attendancePhoto != null) ...[
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white, width: 3),
                image: DecorationImage(
                  image: FileImage(_attendancePhoto!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _takeSelfie,
              icon: Icon(_isCheckedIn ? Icons.logout : Icons.camera_alt),
              label: Text(
                _isCheckedIn ? 'Check Out' : 'Take Selfie & Check In',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isCheckedIn ? Colors.red : Colors.white,
                foregroundColor: _isCheckedIn ? Colors.white : theme.colorScheme.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          Text(
            'Must be within 50m of Centurion University Vizianagram',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3);
  }

  Widget _buildQuickActions(ThemeData theme) {
    final actions = [
      {'icon': Icons.task_alt, 'label': 'Tasks', 'onTap': () => AppRouter.goToTasks(context)},
      {'icon': Icons.chat, 'label': 'Chat', 'onTap': () => AppRouter.goToChat(context)},
      {'icon': Icons.calendar_today, 'label': 'Attendance', 'onTap': () => AppRouter.goToAttendance(context)},
      {'icon': Icons.settings, 'label': 'Settings', 'onTap': () => AppRouter.goToSettings(context)},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
          ),
          itemCount: actions.length,
          itemBuilder: (context, index) {
            final action = actions[index];
            return GestureDetector(
              onTap: action['onTap'] as VoidCallback,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                  border: Border.all(
                    color: theme.colorScheme.outline.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      action['icon'] as IconData,
                      size: 32,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      action['label'] as String,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ).animate(delay: Duration(milliseconds: 400 + (index * 100)))
                .fadeIn()
                .scale(begin: const Offset(0.8, 0.8));
          },
        ),
      ],
    );
  }

  Widget _buildTodaysTasks(ThemeData theme) {
    final tasks = [
      {'title': 'Complete safety inspection', 'time': '09:00 AM', 'status': 'pending'},
      {'title': 'Equipment maintenance', 'time': '11:30 AM', 'status': 'in_progress'},
      {'title': 'Team meeting', 'time': '02:00 PM', 'status': 'completed'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Today\'s Tasks',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            TextButton(
              onPressed: () => AppRouter.goToTasks(context),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            final status = task['status'] as String;
            Color statusColor = status == 'completed' 
                ? Colors.green 
                : status == 'in_progress' 
                    ? Colors.orange 
                    : Colors.grey;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: EdgeInsets.all(AppTheme.paddingMedium),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task['title'] as String,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          task['time'] as String,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                ],
              ),
            ).animate(delay: Duration(milliseconds: 600 + (index * 100)))
                .fadeIn()
                .slideX(begin: 0.3);
          },
        ),
      ],
    );
  }

  Widget _buildRecentActivity(ThemeData theme) {
    final activities = [
      {'action': 'Checked in', 'time': '8:30 AM', 'icon': Icons.login},
      {'action': 'Completed task', 'time': '10:15 AM', 'icon': Icons.check_circle},
      {'action': 'Break started', 'time': '12:00 PM', 'icon': Icons.coffee},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: activities.length,
          itemBuilder: (context, index) {
            final activity = activities[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                child: Icon(
                  activity['icon'] as IconData,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
              ),
              title: Text(
                activity['action'] as String,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(activity['time'] as String),
              contentPadding: EdgeInsets.zero,
            ).animate(delay: Duration(milliseconds: 800 + (index * 100)))
                .fadeIn()
                .slideX(begin: -0.3);
          },
        ),
      ],
    );
  }

  Widget _buildBottomNavBar(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.dashboard, 'Dashboard', true, theme, () {}),
          _buildNavItem(Icons.task_alt, 'Tasks', false, theme, () => AppRouter.goToTasks(context)),
          _buildNavItem(Icons.chat, 'Chat', false, theme, () => AppRouter.goToChat(context)),
          _buildNavItem(Icons.person, 'Profile', false, theme, () => AppRouter.goToProfile(context)),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive, ThemeData theme, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? theme.colorScheme.primary : theme.colorScheme.onSurface.withOpacity(0.6),
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isActive ? theme.colorScheme.primary : theme.colorScheme.onSurface.withOpacity(0.6),
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
