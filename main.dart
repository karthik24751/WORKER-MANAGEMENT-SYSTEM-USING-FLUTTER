import 'package:flutter/material.dart';

void main() {
  runApp(const WorkerHubApp());
}

class WorkerHubApp extends StatelessWidget {
  const WorkerHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WorkerHub',
      theme: ThemeData(
        primaryColor: const Color(0xFF002B7F),
        scaffoldBackgroundColor: const Color(0xFF002B7F),
      ),
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF002B7F),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "WorkerHub",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              "Welcome to Centurion University",
              style: TextStyle(
                fontSize: 16,
                color: Colors.yellow,
              ),
            ),
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 35,
              backgroundColor: Colors.yellow,
              child: const Icon(
                Icons.school,
                color: Color(0xFF002B7F),
                size: 35,
              ),
            ),
            const SizedBox(height: 30),

            // Worker Button
            buildRoleButton(
              icon: Icons.build,
              text: "Worker",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoginScreen(
                        role: "Worker",
                        allowSignup: false,
                      )),
                );
              },
            ),
            const SizedBox(height: 15),

            // Manager Button
            buildRoleButton(
              icon: Icons.business_center,
              text: "Manager",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoginScreen(
                        role: "Manager",
                        allowSignup: false,
                      )),
                );
              },
            ),
            const SizedBox(height: 15),

            // General User Button
            buildRoleButton(
              icon: Icons.group,
              text: "General User",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoginScreen(
                        role: "General User",
                        allowSignup: true,
                      )),
                );
              },
            ),
            const SizedBox(height: 30),

            const Text(
              "Select your role to continue",
              style: TextStyle(color: Colors.white70),
            )
          ],
        ),
      ),
    );
  }

  Widget buildRoleButton(
      {required IconData icon,
        required String text,
        required VoidCallback onPressed}) {
    return SizedBox(
      width: 250,
      height: 50,
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Color(0xFF002B7F)),
        label: Text(
          text,
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF002B7F)),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.yellow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  final String role;
  final bool allowSignup;

  const LoginScreen({super.key, required this.role, this.allowSignup = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF002B7F),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Login as $role",
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF002B7F)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Email field
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email_outlined),
                    labelText: "Email or User ID",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 15),

                // Password field
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: const Icon(Icons.visibility_off),
                    labelText: "Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(value: false, onChanged: (val) {}),
                        const Text("Remember Me"),
                      ],
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(color: Colors.orange),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "Login",
                      style: TextStyle(
                          color: Color(0xFF002B7F),
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Signup link (only for general user)
                if (allowSignup)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                  const GeneralUserSignupScreen()));
                        },
                        child: const Text(
                          "Sign up here",
                          style: TextStyle(color: Colors.orange),
                        ),
                      )
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GeneralUserSignupScreen extends StatelessWidget {
  const GeneralUserSignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF002B7F),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "General User Signup",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF002B7F)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Name
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person_outline),
                    labelText: "Full Name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 15),

                // Email
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email_outlined),
                    labelText: "Email",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 15),

                // Password
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: const Icon(Icons.visibility_off),
                    labelText: "Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 15),

                // Confirm Password
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: const Icon(Icons.visibility_off),
                    labelText: "Confirm Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                    ),
                    onPressed: () {
                      Navigator.pop(context); // Back after signup
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                          color: Color(0xFF002B7F),
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
