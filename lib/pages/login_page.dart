import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../routes.dart';
import '../theme/app_color.dart';
import '../theme/app_text.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan password tidak boleh kosong')),
      );
      return;
    }

    if (!email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Format email tidak valid')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } on FirebaseAuthException catch (e) {
      String message = "Login gagal";
      switch (e.code) {
        case 'user-not-found':
          message = "User tidak ditemukan";
          break;
        case 'wrong-password':
          message = "Password salah";
          break;
        case 'invalid-email':
          message = "Email tidak valid";
          break;
        case 'network-request-failed':
          message = "Tidak ada koneksi internet";
          break;
        default:
          message = "Login gagal: ${e.message}";
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Terjadi kesalahan: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
      isDark ? AppColor.darkBackground : AppColor.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 12),

                /// LOGO
                Image.asset(
                  'assets/images/aebbbec190680b790fb1afab99e36740075f92f4.png',
                  width: 260,
                ),

                const SizedBox(height: 8),

                /// REGISTER TEXT
                Text(
                  "Didn't have account?",
                  style: AppText.caption(context)
                      .copyWith(color: AppColor.black),
                ),
                const SizedBox(height: 4),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.register);
                  },
                  child: Text(
                    'Create one here!',
                    style: AppText.link(context),
                  ),
                ),

                const SizedBox(height: 32),

                /// EMAIL FIELD
                _EmailField(controller: emailController),

                const SizedBox(height: 16),

                /// PASSWORD FIELD
                _PasswordField(controller: passwordController),

                const SizedBox(height: 16),

                /// LOGIN BUTTON
                _PrimaryButton(
                  text: isLoading ? 'Loading...' : 'Login',
                  onPressed: isLoading ? () {} : _login,
                ),

                const SizedBox(height: 24),

                /// OR DIVIDER
                const _OrDivider(),

                const SizedBox(height: 16),

                /// SOCIAL BUTTONS
                const _SocialButton(
                  text: 'Continue with Google',
                  icon: Icons.g_mobiledata,
                  iconSize: 34,
                ),
                const SizedBox(height: 12),
                const _SocialButton(
                  text: 'Continue with Apple',
                  icon: Icons.apple,
                  iconSize: 30,
                ),

                const SizedBox(height: 20),

                /// TERMS
                const _TermsText(),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// EMAIL FIELD
class _EmailField extends StatelessWidget {
  final TextEditingController controller;

  const _EmailField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      style: AppText.body(context),
      decoration: InputDecoration(
        hintText: 'email@domain.com',
        hintStyle: const TextStyle(
          color: AppColor.black38,
          fontFamily: 'Urbanist',
        ),
        filled: true,
        fillColor: AppColor.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

/// PASSWORD FIELD
class _PasswordField extends StatelessWidget {
  final TextEditingController controller;

  const _PasswordField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: true,
      style: AppText.body(context),
      decoration: InputDecoration(
        hintText: 'Password',
        hintStyle: const TextStyle(
          color: AppColor.black38,
          fontFamily: 'Urbanist',
        ),
        filled: true,
        fillColor: AppColor.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

/// PRIMARY BUTTON
class _PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _PrimaryButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: AppText.button(context),
        ),
      ),
    );
  }
}

/// SOCIAL BUTTON
class _SocialButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final double iconSize;

  const _SocialButton({
    required this.text,
    required this.icon,
    this.iconSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColor.white,
          foregroundColor: AppColor.black,
          side: BorderSide(
            color: AppColor.grey.shade300,
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: iconSize),
            const SizedBox(width: 12),
            Text(
              text,
              style: AppText.body(context),
            ),
          ],
        ),
      ),
    );
  }
}

/// DIVIDER OR
class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: Divider(color: AppColor.grey),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text('or'),
        ),
        Expanded(
          child: Divider(color: AppColor.grey),
        ),
      ],
    );
  }
}

/// TERMS TEXT
class _TermsText extends StatelessWidget {
  const _TermsText();

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: AppText.caption(context),
        children: const [
          TextSpan(text: 'By clicking continue, you agree to our '),
          TextSpan(
            text: 'Terms of Service\n',
            style: TextStyle(color: Colors.black),
          ),
          TextSpan(text: 'and '),
          TextSpan(
            text: 'Privacy Policy',
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}