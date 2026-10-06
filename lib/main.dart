import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';

import 'services/api_service.dart';

void main() {
  runApp(const EpcstApp());
}

// Global Course Data Store
List<Map<String, String>> globalChedCourses = [
  {
    'title': 'B.S in COMPUTER SCIENCE',
    'subtitle':
        'Focuses on computation, algorithms, data structures, software design, and artificial intelligence.',
    'image': 'assets/images/cs.png',
    'miscFee': '2,950',
    'labFee': '2,600',
    'labLabel': 'Computer Lab / LMS',
  },
  {
    'title': 'B.S in COMPUTER ENGINEERING',
    'subtitle':
        'Combines electrical engineering and computer science to focus on hardware and software integration.',
    'image': 'assets/images/ComputerEngineering.png',
    'miscFee': '2,950',
    'labFee': '5,200',
    'labLabel': 'Computer Lab / LMS',
  },
  {
    'title': 'B.S in HOSPITALITY MANAGEMENT',
    'subtitle':
        'Covers operational and managerial practices in the service industry.',
    'image': 'assets/images/hrm.jpg',
    'miscFee': '2,950',
    'labFee': '8,800',
    'labLabel': 'Non-Computer Lab',
  },
  {
    'title': 'B.S in ENTREPRENEURSHIP',
    'subtitle':
        'Teaches principles of founding, managing, and scaling new business ventures.',
    'image': 'assets/images/entre.jpg',
    'miscFee': '2,950',
    'labFee': '2,600',
    'labLabel': 'Computer Lab / LMS',
  },
  {
    'title': 'B.S in INFORMATION TECHNOLOGY',
    'subtitle':
        'Focuses on managing and innovating digital systems to connect people and organizations worldwide.',
    'image': 'assets/images/it.jpg',
    'miscFee': '2,950',
    'labFee': '2,600',
    'labLabel': 'Computer Lab / LMS',
  },
];

List<Map<String, String>> globalTesdaCourses = [
  {
    'title': 'DIPLOMA in COMPUTER ENGINEERING',
    'subtitle':
        'Hands-on practical program focused on installing, maintaining, and repairing hardware & networks.',
    'image': 'assets/images/ComputerEngineering.png',
    'miscFee': '2,950',
    'labFee': '5,200',
    'labLabel': 'Computer Lab / LMS',
  },
  {
    'title': 'DIPLOMA in HOSPITALITY MANAGEMENT',
    'subtitle':
        'Provides practical skills in food production, front-office operations, and guest management.',
    'image': 'assets/images/hrm.jpg',
    'miscFee': '2,950',
    'labFee': '8,800',
    'labLabel': 'Non-Computer Lab',
  },
  {
    'title': 'DIPLOMA in INFORMATION TECHNOLOGY',
    'subtitle':
        'Focuses on digital system administration, software tools, and basic network setup.',
    'image': 'assets/images/it.jpg',
    'miscFee': '2,950',
    'labFee': '2,600',
    'labLabel': 'Computer Lab / LMS',
  },
];

// Global Announcements Store
List<Map<String, dynamic>> globalAnnouncements = [];

class UserProfile {
  static String name = 'Estudyante';
  static String email = '';
  static String? photoUrl;
  static String role = '';
  static String course = '';
  static bool isAdmin = false;
}

class EpcstApp extends StatelessWidget {
  const EpcstApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EPCST App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF14819B)),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/ee.jpg',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 32.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: Colors.black.withValues(alpha: 0.8),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 6,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Click to Continue',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final String? _emailError = null;
  final String? _passwordError = null;
  bool _obscurePassword = true;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showAdminPasswordDialog() {
    final TextEditingController adminPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.admin_panel_settings, color: Color(0xFF0C5063)),
            SizedBox(width: 8),
            Text(
              'Admin Authentication',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0C5063)),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Enter Admin Password to access system control interface:',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: adminPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Admin Password',
                hintText: 'Enter password ',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: const Icon(Icons.lock),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0C5063),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              if (adminPasswordController.text == 'admin123') {
                UserProfile.name = 'System Administrator';
                UserProfile.email = 'admin@epcst.edu.ph';
                UserProfile.role = 'ADMINISTRATOR';
                UserProfile.isAdmin = true;

                Navigator.pop(dialogContext);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Invalid Admin Password!')),
                );
              }
            },
            child: const Text('Access Admin Panel'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both email and password')),
      );
      return;
    }

    try {
      final response = await ApiService.login(email, password);
      debugPrint('Login Success: $response');

      if (mounted) {
        UserProfile.email = email;
        UserProfile.isAdmin = false;
        if (response['user'] != null && response['user']['username'] != null) {
          UserProfile.name = response['user']['username'];
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
        );
      }
    }
  }

  void _showCreateAccountDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController ageController = TextEditingController();
    final TextEditingController signUpEmailController = TextEditingController();
    final TextEditingController signUpPasswordController = TextEditingController();

    int currentStep = 1;
    String selectedRole = '';
    String selectedCourse = '';
    bool isLoading = false;

    final List<String> courseOptions = [
      'DIPLOMA IN COMPUTER ENGINEERING',
      'DIPLOMA IN HOSPITALITY MANAGEMENT',
      'DIPLOMA IN INFORMATION TECHNOLOGY',
      'BS IN COMPUTER ENGINEERING',
      'BS IN HOSPITALITY MANAGEMENT',
      'BS IN ENTREPRENEURSHIP',
      'BS IN INFORMATION TECHNOLOGY',
    ];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(
              currentStep == 1
                  ? 'Sign Up Info (1/3)'
                  : currentStep == 2
                      ? (selectedRole == 'COLLEGE STUDENT' ? 'Select Course (2/3)' : 'Visitor Notice (2/3)')
                      : 'Account Credentials (3/3)',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF0C5063),
              ),
            ),
            content: SingleChildScrollView(
              child: SizedBox(
                width: 340,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (currentStep == 1) ...[
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'NAME',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          prefixIcon: const Icon(Icons.person),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: ageController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'AGE',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          prefixIcon: const Icon(Icons.cake),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Select Category:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0C5063)),
                      ),
                      const SizedBox(height: 8),
                      ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: selectedRole == 'COLLEGE STUDENT' ? const Color(0xFF0C5063) : Colors.grey.shade300,
                            width: 2,
                          ),
                        ),
                        title: const Text('COLLEGE STUDENT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        leading: Radio<String>(
                          value: 'COLLEGE STUDENT',
                          groupValue: selectedRole,
                          onChanged: (val) {
                            if (val != null) setDialogState(() => selectedRole = val);
                          },
                        ),
                        onTap: () => setDialogState(() => selectedRole = 'COLLEGE STUDENT'),
                      ),
                      const SizedBox(height: 8),
                      ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: selectedRole == 'VISITOR' ? const Color(0xFF0C5063) : Colors.grey.shade300,
                            width: 2,
                          ),
                        ),
                        title: const Text('Visitors', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        leading: Radio<String>(
                          value: 'VISITOR',
                          groupValue: selectedRole,
                          onChanged: (val) {
                            if (val != null) setDialogState(() => selectedRole = val);
                          },
                        ),
                        onTap: () => setDialogState(() => selectedRole = 'VISITOR'),
                      ),
                    ],
                    if (currentStep == 2) ...[
                      if (selectedRole == 'COLLEGE STUDENT') ...[
                        const Text('Select your Program/Course:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0C5063))),
                        const SizedBox(height: 8),
                        ...courseOptions.map(
                          (course) => Container(
                            margin: const EdgeInsets.only(bottom: 6),
                            child: RadioListTile<String>(
                              dense: true,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(color: selectedCourse == course ? const Color(0xFF0C5063) : Colors.grey.shade300),
                              ),
                              title: Text(course, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                              value: course,
                              groupValue: selectedCourse,
                              onChanged: (val) {
                                if (val != null) setDialogState(() => selectedCourse = val);
                              },
                            ),
                          ),
                        ),
                      ] else ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1995AD).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFF1995AD)),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.info_outline, color: Color(0xFF0C5063), size: 30),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'You are registered as a Visitor.\nYou will have guest access to basic portal services.',
                                  style: TextStyle(fontSize: 13, color: Color(0xFF0C5063), fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                    if (currentStep == 3) ...[
                      TextField(
                        controller: signUpEmailController,
                        decoration: InputDecoration(
                          labelText: 'Gmail Address',
                          hintText: 'example@gmail.com',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          prefixIcon: const Icon(Icons.email),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: signUpPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          prefixIcon: const Icon(Icons.lock),
                        ),
                      ),
                    ],
                    if (isLoading) ...[
                      const SizedBox(height: 16),
                      const Center(child: CircularProgressIndicator(color: Color(0xFF0C5063))),
                    ],
                  ],
                ),
              ),
            ),
            actions: [
              if (currentStep > 1 && !isLoading)
                TextButton(
                  onPressed: () => setDialogState(() => currentStep--),
                  child: const Text('Back'),
                ),
              if (!isLoading)
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0C5063),
                  foregroundColor: Colors.white,
                ),
                onPressed: isLoading
                    ? null
                    : () async {
                        if (currentStep == 1) {
                          if (nameController.text.trim().isEmpty || ageController.text.trim().isEmpty || selectedRole.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please fill name, age, and select a role.')),
                            );
                            return;
                          }
                          setDialogState(() => currentStep = 2);
                        } else if (currentStep == 2) {
                          if (selectedRole == 'COLLEGE STUDENT' && selectedCourse.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please select a course to continue.')),
                            );
                            return;
                          }
                          setDialogState(() => currentStep = 3);
                        } else if (currentStep == 3) {
                          final email = signUpEmailController.text.trim();
                          final password = signUpPasswordController.text.trim();
                          final fullName = nameController.text.trim();

                          if (email.isEmpty || password.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please enter Gmail and password.')),
                            );
                            return;
                          }

                          setDialogState(() => isLoading = true);

                          try {
                            await ApiService.register(
                              studentId: 'STU-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                              fullName: fullName,
                              email: email,
                              password: password,
                            );

                            UserProfile.name = fullName;
                            UserProfile.email = email;
                            UserProfile.role = selectedRole;
                            UserProfile.course = selectedCourse;
                            UserProfile.isAdmin = false;

                            if (mounted) {
                              Navigator.pop(dialogContext);
                              setState(() => _emailController.text = email);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Account successfully created! You can now log in.')),
                              );
                            }
                          } catch (e) {
                            setDialogState(() => isLoading = false);
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
                              );
                            }
                          }
                        }
                      },
                child: Text(currentStep == 3 ? 'Finish & Sign Up' : 'Next'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1995AD), Color(0xFF0C5063)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/epcst_logo.png',
                      height: 360,
                      width: 680,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 6),
                    InkWell(
                      onTap: _showAdminPasswordDialog,
                      borderRadius: BorderRadius.circular(8),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                        child: Text(
                          'Sign In to Account',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Enter your Gmail & Password to Access Portal',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, color: Colors.white70),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Gmail Account',
                        labelStyle: const TextStyle(color: Colors.white70),
                        hintText: 'username@gmail.com',
                        hintStyle: const TextStyle(color: Colors.white38),
                        filled: true,
                        fillColor: Colors.black.withValues(alpha: 0.2),
                        errorText: _emailError,
                        errorStyle: const TextStyle(color: Colors.yellowAccent),
                        prefixIcon: const Icon(Icons.email, color: Colors.white70),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.white30),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: const TextStyle(color: Colors.white70),
                        hintText: 'Enter Password',
                        hintStyle: const TextStyle(color: Colors.white38),
                        filled: true,
                        fillColor: Colors.black.withValues(alpha: 0.2),
                        errorText: _passwordError,
                        errorStyle: const TextStyle(color: Colors.yellowAccent),
                        prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: Colors.white70,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.white30),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _handleLogin,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(44),
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Log In',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      children: [
                        Expanded(child: Divider(color: Colors.white30)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'or',
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.white30)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: _showCreateAccountDialog,
                      icon: const Icon(
                        Icons.person_add_outlined,
                        size: 20,
                        color: Colors.black87,
                      ),
                      label: const Text('Create Account'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(44),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  void _showAddEditCourseDialog({Map<String, String>? existingCourse, bool isChed = true, int? index}) {
    final titleController = TextEditingController(text: existingCourse?['title'] ?? '');
    final subtitleController = TextEditingController(text: existingCourse?['subtitle'] ?? '');
    final miscFeeController = TextEditingController(text: existingCourse?['miscFee'] ?? '');
    final labFeeController = TextEditingController(text: existingCourse?['labFee'] ?? '');
    final labLabelController = TextEditingController(text: existingCourse?['labLabel'] ?? 'Computer Lab / LMS');

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          existingCourse == null ? 'Add New Course' : 'Edit Course & Fees',
          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0C5063)),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Course Title (e.g., B.S in IT)'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: subtitleController,
                decoration: const InputDecoration(labelText: 'Course Description / Subtitle'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: miscFeeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Miscellaneous Fee (₱)'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: labFeeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Laboratory Fee (₱)'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: labLabelController,
                decoration: const InputDecoration(labelText: 'Lab Category Label'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0C5063), foregroundColor: Colors.white),
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                final courseData = {
                  'title': titleController.text.trim(),
                  'subtitle': subtitleController.text.trim(),
                  'image': existingCourse?['image'] ?? 'assets/images/epcst_logo.png',
                  'miscFee': miscFeeController.text.trim(),
                  'labFee': labFeeController.text.trim(),
                  'labLabel': labLabelController.text.trim(),
                };

                setState(() {
                  final targetList = isChed ? globalChedCourses : globalTesdaCourses;
                  if (existingCourse == null) {
                    targetList.add(courseData);
                  } else if (index != null) {
                    targetList[index] = courseData;
                  }
                });

                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Course & Fees updated successfully!')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showPostAdminAnnouncementDialog() {
    final TextEditingController postController = TextEditingController();
    String? selectedFileName;
    Uint8List? selectedFileBytes;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Post Admin Dashboard Announcement',
            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0C5063)),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: postController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Type official admin announcement...',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () async {
                    FilePickerResult? result = await FilePicker.platform.pickFiles(
                      type: FileType.image,
                      withData: true,
                    );

                    if (result != null && result.files.single.name.isNotEmpty) {
                      setDialogState(() {
                        selectedFileName = result.files.single.name;
                        selectedFileBytes = result.files.single.bytes;
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[50],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.image, color: Color(0xFF0C5063)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            selectedFileName ?? 'Attach Image / Picture (Optional)',
                            style: TextStyle(
                              fontSize: 13,
                              color: selectedFileName != null ? Colors.black87 : Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (selectedFileName != null)
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 18,
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0C5063),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (postController.text.trim().isNotEmpty) {
                  setState(() {
                    globalAnnouncements.insert(0, {
                      'author': 'EPCST Admin Portal',
                      'role': 'OFFICIAL ADMIN',
                      'date': 'Just now',
                      'timestamp': DateTime.now(),
                      'content': postController.text.trim(),
                      'imageBytes': selectedFileBytes,
                      'imageName': selectedFileName ?? '',
                      'likes': 0,
                      'isLiked': false,
                      'comments': <Map<String, String>>[],
                    });
                  });
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Announcement posted to Dashboard!')),
                  );
                }
              },
              child: const Text('Post Announcement'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Full Control Dashboard', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor: const Color(0xFF0C5063),
          actions: [
            IconButton(
              icon: const Icon(Icons.add_alert, color: Colors.white),
              tooltip: 'Post Official Announcement',
              onPressed: _showPostAdminAnnouncementDialog,
            ),
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () {
                UserProfile.isAdmin = false;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                );
              },
            ),
          ],
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Color(0xFFFFEB3B),
            tabs: [
              Tab(text: 'CHED Courses & Fees'),
              Tab(text: 'TESDA Courses & Fees'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildAdminCourseList(globalChedCourses, isChed: true),
            _buildAdminCourseList(globalTesdaCourses, isChed: false),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showAddEditCourseDialog(isChed: true),
          backgroundColor: const Color(0xFF0C5063),
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add),
          label: const Text('Add Course'),
        ),
      ),
    );
  }

  Widget _buildAdminCourseList(List<Map<String, String>> courses, {required bool isChed}) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(course['title']!, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0C5063))),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Misc Fee: ₱${course['miscFee']} | Lab Fee: ₱${course['labFee']}'),
                Text(course['subtitle']!, style: const TextStyle(fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _showAddEditCourseDialog(existingCourse: course, isChed: isChed, index: index),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      courses.removeAt(index);
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class AnimatedGreetingScreen extends StatefulWidget {
  const AnimatedGreetingScreen({super.key});

  @override
  State<AnimatedGreetingScreen> createState() => _AnimatedGreetingScreenState();
}

class _AnimatedGreetingScreenState extends State<AnimatedGreetingScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _floatController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _floatController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: 0.0, end: 12.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _fadeController.forward();

    Future.delayed(const Duration(milliseconds: 3500), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => UserProfile.isAdmin ? const AdminDashboardScreen() : const HomeScreen(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1995AD), Color(0xFF0C5063)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _floatAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, -_floatAnimation.value),
                            child: child,
                          );
                        },
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: UserProfile.photoUrl != null
                                ? Image.network(
                                    UserProfile.photoUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        'assets/images/epcst_logo.png',
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  )
                                : Image.asset(
                                    'assets/images/epcst_logo.png',
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Text(
                        '👋 Welcome, ${UserProfile.name}!',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        UserProfile.role.isNotEmpty
                            ? 'Role: ${UserProfile.role}${UserProfile.course.isNotEmpty ? ' (${UserProfile.course})' : ''}'
                            : 'Magandang araw kapwa Eastwoodiantes! Handa na ang iyong EPCST dashboard.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeView(),
    const SearchView(),
    const MessageView(),
    const ProfileView(),
  ];

  void _showNotifications(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 350,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0C5063),
                    ),
                  ),
                  Icon(Icons.notifications_active, color: Color(0xFF0C5063)),
                ],
              ),
              Divider(),
              SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Color(0xFF1995AD),
                          child: Icon(Icons.campaign, color: Colors.white),
                        ),
                        title: Text(
                          'Enrollment is Now Ongoing!',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Text(
                          'Check out the banner for JHS, SHS, and College registration details.',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      Divider(),
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Color(0xFF0C5063),
                          child: Icon(Icons.school, color: Colors.white),
                        ),
                        title: Text(
                          'Welcome Eastwoodiantes!',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Text(
                          'Have a great semester ahead in your portal dashboard.',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            CircleAvatar(
              radius: 50,
              backgroundImage: UserProfile.photoUrl != null
                  ? NetworkImage(UserProfile.photoUrl!) as ImageProvider
                  : const AssetImage('assets/images/epcst_logo.png'),
            ),
            const SizedBox(height: 16),
            Text(
              UserProfile.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0C5063),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              UserProfile.email.isNotEmpty
                  ? UserProfile.email
                  : 'Student Portal Account',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            if (UserProfile.course.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                UserProfile.course,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1995AD),
                ),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0C5063),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: Column(
        children: [
          Container(
            color: const Color(0xFF0C5063),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => _showProfileDialog(context),
                      borderRadius: BorderRadius.circular(30),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: const BoxDecoration(shape: BoxShape.circle),
                              child: ClipOval(
                                child: UserProfile.photoUrl != null
                                    ? Image.network(
                                        UserProfile.photoUrl!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Image.asset(
                                            'assets/images/epcst_logo.png',
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      )
                                    : Image.asset(
                                        'assets/images/epcst_logo.png',
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Welcome,',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.white70,
                                  ),
                                ),
                                SizedBox(
                                  width: 150,
                                  child: Text(
                                    UserProfile.name,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(
                        Icons.notifications_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () => _showNotifications(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: _screens[_currentIndex],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF0C5063),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Message'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class CommunityBoardScreen extends StatefulWidget {
  const CommunityBoardScreen({super.key});

  @override
  State<CommunityBoardScreen> createState() => _CommunityBoardScreenState();
}

class _CommunityBoardScreenState extends State<CommunityBoardScreen> {
  List<Map<String, dynamic>> get _activeAnnouncements {
    final now = DateTime.now();
    return globalAnnouncements.where((item) {
      final DateTime postDate = item['timestamp'] as DateTime;
      final difference = now.difference(postDate).inDays;
      return difference < 7;
    }).toList();
  }

  void _showAddAnnouncementDialog() {
    final TextEditingController postController = TextEditingController();
    String? selectedFileName;
    Uint8List? selectedFileBytes;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Create Thread / Announcement',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0C5063),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: postController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Isulat ang iyong anunsyo o mensahe rito...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () async {
                    FilePickerResult? result = await FilePicker.platform.pickFiles(
                      type: FileType.image,
                      withData: true,
                    );

                    if (result != null && result.files.single.name.isNotEmpty) {
                      setDialogState(() {
                        selectedFileName = result.files.single.name;
                        selectedFileBytes = result.files.single.bytes;
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[50],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.image, color: Color(0xFF0C5063)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            selectedFileName ?? 'Pindutin para pumili ng larawan mula sa Device',
                            style: TextStyle(
                              fontSize: 13,
                              color: selectedFileName != null ? Colors.black87 : Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (selectedFileName != null)
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 18,
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1995AD),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (postController.text.trim().isNotEmpty) {
                  setState(() {
                    globalAnnouncements.insert(0, {
                      'author': UserProfile.name,
                      'role': UserProfile.isAdmin ? 'OFFICIAL ADMIN' : 'Verified Member',
                      'date': 'Ngayon lang',
                      'timestamp': DateTime.now(),
                      'content': postController.text.trim(),
                      'imageBytes': selectedFileBytes,
                      'imageName': selectedFileName ?? '',
                      'likes': 0,
                      'isLiked': false,
                      'comments': <Map<String, String>>[],
                    });
                  });
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Matagumpay na na-publish ang iyong anunsyo!'),
                    ),
                  );
                }
              },
              child: const Text('Post'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCommentsDialog(Map<String, dynamic> item) {
    final TextEditingController commentController = TextEditingController();
    final List<Map<String, String>> comments = (item['comments'] as List).cast<Map<String, String>>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: SizedBox(
            height: 450,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Comments & Discussion',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0C5063),
                  ),
                ),
                const Divider(),
                Expanded(
                  child: comments.isEmpty
                      ? const Center(
                          child: Text(
                            'Wala pang komento. Maging una na mag-reply!',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        )
                      : ListView.builder(
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            final comment = comments[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    comment['author']!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Color(0xFF0C5063),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    comment['text']!,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: commentController,
                        decoration: InputDecoration(
                          hintText: 'Mag-iwan ng komento...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.send, color: Color(0xFF0C5063)),
                      onPressed: () {
                        if (commentController.text.trim().isNotEmpty) {
                          setModalState(() {
                            comments.add({
                              'author': UserProfile.name,
                              'text': commentController.text.trim(),
                            });
                          });
                          commentController.clear();
                          setState(() {});
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activePosts = _activeAnnouncements;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text(
          'Community Board',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: const Color(0xFF0C5063),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          if (UserProfile.isAdmin)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _showAddAnnouncementDialog,
                    icon: const Icon(Icons.add_comment, size: 18),
                    label: const Text(
                      'Add Admin Announcement',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1995AD),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const Divider(height: 1),
          Expanded(
            child: activePosts.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.forum_outlined, size: 64, color: Colors.grey),
                        SizedBox(height: 12),
                        Text(
                          'Wala pang aktibong anunsyo.',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: activePosts.length,
                    itemBuilder: (context, index) {
                      final item = activePosts[index];
                      final Uint8List? imageBytes = item['imageBytes'] as Uint8List?;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: const Color(0xFF0C5063),
                                  child: Text(
                                    (item['author'] as String)[0],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['author'] as String,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Color(0xFF0C5063),
                                      ),
                                    ),
                                    Text(
                                      '${item['role']} • ${item['date']}',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              item['content'] as String,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black87,
                                height: 1.4,
                              ),
                            ),
                           if (imageBytes != null) ...[
  const SizedBox(height: 12),
  ConstrainedBox(
    constraints: const BoxConstraints(
      maxHeight: 350, // Prevents huge vertical overflow
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.memory(
        imageBytes,
        width: double.infinity,
        fit: BoxFit.contain, // Ensures the entire image is visible
      ),
    ),
  ),
],
                            const SizedBox(height: 12),
                            const Divider(height: 1),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                TextButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      if (item['isLiked'] as bool) {
                                        item['isLiked'] = false;
                                        item['likes'] = (item['likes'] as int) - 1;
                                      } else {
                                        item['isLiked'] = true;
                                        item['likes'] = (item['likes'] as int) + 1;
                                      }
                                    });
                                  },
                                  icon: Icon(
                                    item['isLiked'] as bool ? Icons.favorite : Icons.favorite_border,
                                    color: item['isLiked'] as bool ? Colors.red : Colors.grey,
                                    size: 18,
                                  ),
                                  label: Text(
                                    '${item['likes']} Support',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: item['isLiked'] as bool ? Colors.red : Colors.grey[700],
                                    ),
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: () => _showCommentsDialog(item),
                                  icon: const Icon(
                                    Icons.mode_comment_outlined,
                                    color: Color(0xFF0C5063),
                                    size: 18,
                                  ),
                                  label: Text(
                                    '${(item['comments'] as List).length} Comments',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF0C5063),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class EnrollmentScreen extends StatelessWidget {
  const EnrollmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F9FC),
        appBar: AppBar(
          title: const Text(
            'Available Courses & Enrollment',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          backgroundColor: const Color(0xFF0C5063),
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Color(0xFFFFEB3B),
            indicatorWeight: 3,
            tabs: [
              Tab(text: 'College CHED Courses'),
              Tab(text: 'College TESDA Courses'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildCourseList(context, globalChedCourses),
            _buildCourseList(context, globalTesdaCourses),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseList(
    BuildContext context,
    List<Map<String, String>> courses,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.asset(
                        course['image']!,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/epcst_logo.png',
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: 90,
                      child: Column(
                        children: [
                          const Text(
                            'Fees:',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0C5063),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Misc: ₱${course['miscFee']}',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            'Lab:   ₱${course['labFee']}',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course['title']!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0C5063),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${course['labLabel']} & Miscellaneous Fees displayed below icon',
                        style: const TextStyle(
                          fontSize: 10,
                          fontStyle: FontStyle.italic,
                          color: Color(0xFF1995AD),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        course['subtitle']!,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text(course['title']!),
                                content: Text(
                                  'Would you like to proceed with the online application or scholarship slot reservation for this course?\n\nFees Breakdown:\n• Miscellaneous Fee: ₱${course['miscFee']}\n• ${course['labLabel']}: ₱${course['labFee']}',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(ctx);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Application submitted for ${course['title']}!',
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF0C5063),
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('Apply Now'),
                                  ),
                                ],
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1995AD),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(100, 32),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Enroll / Apply',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allCourses = [...globalChedCourses, ...globalTesdaCourses];
    final filteredCourses = allCourses.where((course) {
      final title = course['title']!.toLowerCase();
      final subtitle = course['subtitle']!.toLowerCase();
      return title.contains(_searchQuery.toLowerCase()) || subtitle.contains(_searchQuery.toLowerCase());
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Search subjects, schedule, events...',
              prefixIcon: const Icon(Icons.search, color: Color(0xFF0C5063)),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _searchQuery = '';
                        });
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: filteredCourses.length,
              itemBuilder: (context, index) {
                final course = filteredCourses[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.asset(
                            course['image']!,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Image.asset(
                              'assets/images/epcst_logo.png',
                              width: 60,
                              height: 60,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                course['title']!,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0C5063),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                course['subtitle']!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MessageView extends StatelessWidget {
  const MessageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text(
          'Messages',
          style: TextStyle(
            color: Color(0xFF0C5063),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildMessageItem(
            context,
            name: 'EPCST Registrar',
            message: 'Your enrollment requirements have been verified.',
            time: '10:45 AM',
            unread: true,
          ),
          _buildMessageItem(
            context,
            name: 'Prof. Santos (CS Dept)',
            message: 'Please check your portal for the project guidelines.',
            time: 'Yesterday',
            unread: false,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageItem(
    BuildContext context, {
    required String name,
    required String message,
    required String time,
    required bool unread,
  }) {
    return Card(
      elevation: unread ? 2 : 0,
      color: unread ? Colors.white : Colors.white70,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF1995AD),
          child: Text(
            name[0],
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          name,
          style: TextStyle(
            fontWeight: unread ? FontWeight.bold : FontWeight.normal,
            color: const Color(0xFF0C5063),
          ),
        ),
        subtitle: Text(message, maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: Text(
          time,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(name),
              content: Text(message),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 190,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: const DecorationImage(
                image: AssetImage('assets/images/banner.jpg'),
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.25,
            children: [
              _buildMenuCard(
                context,
                title: 'ENROLLMENT',
                subtitle: 'Courses, Online application, scholarship slot',
                icon: Icons.school,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EnrollmentScreen(),
                    ),
                  );
                },
              ),
              _buildMenuCard(
                context,
                title: 'SCHOOL MERCH',
                subtitle: 'View items, Reserve',
                icon: Icons.shopping_bag,
                onTap: () {
                  _showFeatureDialog(
                    context,
                    'School Merch',
                    'Wala pa nga nii nilalagay.',
                  );
                },
              ),
              _buildMenuCard(
                context,
                title: 'BILLING & FEES',
                subtitle: 'Check balance, Make payments',
                icon: Icons.account_balance_wallet,
                onTap: () {
                  _showFeatureDialog(
                    context,
                    'Billing & Fees',
                    'Wala pa nga nii nilalagay.',
                  );
                },
              ),
              _buildMenuCard(
                context,
                title: 'COMMUNITY BOARD',
                subtitle: 'Announcement, Discussion',
                icon: Icons.forum,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CommunityBoardScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFEB3B),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: const Color(0xFF0C5063), size: 22),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0C5063),
                    decoration: TextDecoration.underline,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showFeatureDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const SizedBox(height: 10),
          CircleAvatar(
            radius: 50,
            backgroundImage: UserProfile.photoUrl != null
                ? NetworkImage(UserProfile.photoUrl!) as ImageProvider
                : const AssetImage('assets/images/epcst_logo.png'),
          ),
          const SizedBox(height: 16),
          Text(
            UserProfile.name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0C5063),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            UserProfile.email.isNotEmpty ? UserProfile.email : 'Student Portal Account',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          if (UserProfile.role.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              'Status: ${UserProfile.role}${UserProfile.course.isNotEmpty ? ' • ${UserProfile.course}' : ''}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1995AD),
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 10),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person_outline, color: Color(0xFF1995AD)),
                  title: const Text('Personal Information', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _showPersonalInformation(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.lock_outline, color: Color(0xFF1995AD)),
                  title: const Text('Privacy & Security', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _showPrivacySecurity(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.perm_device_information, color: Color(0xFF1995AD)),
                  title: const Text('Contact Us', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _showContactUs(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
              );
            },
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            label: const Text(
              'Log Out',
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              backgroundColor: Colors.red.withValues(alpha: 0.1),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPersonalInformation(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Personal Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0C5063),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.person, color: Color(0xFF1995AD)),
              title: const Text('Full Name'),
              subtitle: Text(UserProfile.name),
            ),
            ListTile(
              leading: const Icon(Icons.email, color: Color(0xFF1995AD)),
              title: const Text('Email Address'),
              subtitle: Text(
                UserProfile.email.isNotEmpty ? UserProfile.email : 'Not set',
              ),
            ),
            if (UserProfile.course.isNotEmpty)
              ListTile(
                leading: const Icon(Icons.school, color: Color(0xFF1995AD)),
                title: const Text('Enrolled Program'),
                subtitle: Text(UserProfile.course),
              ),
          ],
        ),
      ),
    );
  }

  void _showPrivacySecurity(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Privacy & Security',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0C5063),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.lock_reset, color: Color(0xFF1995AD)),
              title: const Text('Change Password'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Password reset link sent to your email.'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showContactUs(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0C5063),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.email, color: Colors.red),
              title: const Text('Official Email'),
              subtitle: const Text('eastwoodsprofessional@epcst.edu.ph'),
              onTap: () async {
                final Uri emailUri = Uri(
                  scheme: 'mailto',
                  path: 'eastwoodsprofessional@epcst.edu.ph',
                );
                if (await canLaunchUrl(emailUri)) await launchUrl(emailUri);
              },
            ),
            const ListTile(
              leading: Icon(Icons.phone, color: Color(0xFF1995AD)),
              title: Text('(047) 791 2791'),
            ),
          ],
        ),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/build.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/epcst_logo.png',
                width: 650,
                height: 450,
              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ],
      ),
    );
  }
}