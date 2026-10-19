
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../home/home_screen.dart';
import 'login_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;
  final String phone;

  const OtpVerificationScreen({
    super.key,
    required this.email,
    required this.phone,
  });

  @override
  State<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  static const Color _navy = Color(0xFF102A43);
  static const Color _teal = Color(0xFF00A6A6);
  static const Color _cyan = Color(0xFF32C5D2);
  static const Color _background = Color(0xFFF2F8FC);

  bool _isChecking = false;
  bool _isResending = false;

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _checkEmailVerification() async {
    if (_isChecking) return;

    setState(() => _isChecking = true);

    try {
      debugPrint('MOVIRA: Checking email verification status.');

      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        debugPrint('MOVIRA: No signed-in Firebase user.');
        _showMessage('Please log in to continue verification.');
        return;
      }

      debugPrint('MOVIRA: Current user email: ${user.email}');

      await user.reload();

      final refreshedUser = FirebaseAuth.instance.currentUser;

      if (refreshedUser == null) {
        debugPrint('MOVIRA: User session is no longer available.');
        _showMessage('Your session expired. Please log in again.');
        return;
      }

      debugPrint(
        'MOVIRA: emailVerified = ${refreshedUser.emailVerified}',
      );

      if (!refreshedUser.emailVerified) {
        _showMessage(
          'Email not verified yet. Open the verification link in your email, '
              'then try again.',
        );
        return;
      }

      debugPrint('MOVIRA: Email verified successfully.');

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
            (route) => false,
      );
    } on FirebaseAuthException catch (error, stackTrace) {
      debugPrint(
        'MOVIRA verification-check Firebase error code: ${error.code}',
      );
      debugPrint(
        'MOVIRA verification-check error message: ${error.message}',
      );
      debugPrint('MOVIRA verification-check stack trace: $stackTrace');

      _showMessage(
        error.message ?? 'Could not check verification. Please try again.',
      );
    } catch (error, stackTrace) {
      debugPrint('MOVIRA verification-check error: $error');
      debugPrint('MOVIRA verification-check stack trace: $stackTrace');

      _showMessage('Something went wrong. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isChecking = false);
      }
    }
  }

  Future<void> _resendVerificationEmail() async {
    if (_isResending) return;

    setState(() => _isResending = true);

    try {
      debugPrint('MOVIRA: Starting verification email resend.');

      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        debugPrint('MOVIRA: Cannot resend; no signed-in user.');
        _showMessage('Please log in to request a verification email.');
        return;
      }

      debugPrint('MOVIRA: Resend recipient: ${user.email}');
      debugPrint('MOVIRA: Requesting Firebase verification email.');

      await user.sendEmailVerification();

      debugPrint(
        'MOVIRA: Firebase verification email request completed '
            'for ${user.email}. Inbox delivery has not been confirmed.',
      );

      _showMessage(
        'Firebase accepted the verification request. Check your inbox '
            'and spam folder.',
      );
    } on FirebaseAuthException catch (error, stackTrace) {
      debugPrint(
        'MOVIRA resend Firebase error code: ${error.code}',
      );
      debugPrint(
        'MOVIRA resend Firebase error message: ${error.message}',
      );
      debugPrint('MOVIRA resend stack trace: $stackTrace');

      switch (error.code) {
        case 'too-many-requests':
          _showMessage(
            'Too many requests. Please wait before trying again.',
          );
          break;
        case 'network-request-failed':
          _showMessage(
            'Check your internet connection and try again.',
          );
          break;
        case 'user-token-expired':
        case 'requires-recent-login':
          _showMessage(
            'Your session needs to be refreshed. Please log in again.',
          );
          break;
        default:
          _showMessage(
            error.message ?? 'Could not resend the email. Please try again.',
          );
      }
    } catch (error, stackTrace) {
      debugPrint('MOVIRA resend unexpected error: $error');
      debugPrint('MOVIRA resend stack trace: $stackTrace');

      _showMessage('Could not resend the email. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isResending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: _background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: _navy,
          ),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 94,
                    height: 94,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: _navy.withValues(alpha: 0.08),
                          blurRadius: 22,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/branding/movira_icon.png',
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.mark_email_read_rounded,
                        color: _teal,
                        size: 52,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  'Verify your email',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w800,
                    color: _navy,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'One more step before you start your journey with MOVIRA.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: Color(0xFF647A8B),
                  ),
                ),
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: const Color(0xFFDCE7EF),
                    ),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.mark_email_unread_outlined,
                        size: 52,
                        color: _teal,
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Check your inbox',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: _navy,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'We sent a verification link to:',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF647A8B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.email,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: _teal,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Open the email from Firebase and tap its verification link. '
                            'If you cannot find it, check your spam or junk folder.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.6,
                          color: Color(0xFF526879),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 56,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [_teal, _cyan],
                      ),
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: ElevatedButton(
                      onPressed: _isChecking
                          ? null
                          : _checkEmailVerification,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        disabledBackgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(17),
                        ),
                      ),
                      child: _isChecking
                          ? const SizedBox(
                        height: 23,
                        width: 23,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                          : const Text(
                        "I've Verified My Email",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: _isResending
                      ? null
                      : _resendVerificationEmail,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    side: const BorderSide(color: _teal),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isResending
                      ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: _teal,
                    ),
                  )
                      : const Text(
                    'Resend Verification Email',
                    style: TextStyle(
                      color: _teal,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                TextButton(
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance.signOut();

                      if (!context.mounted) return;

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                            (route) => false,
                      );
                    } catch (error, stackTrace) {
                      debugPrint('MOVIRA sign-out error: $error');
                      debugPrint('MOVIRA sign-out stack trace: $stackTrace');

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Could not log out. Please try again.',
                            ),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text(
                    'Back to Log In',
                    style: TextStyle(
                      color: _navy,
                      fontWeight: FontWeight.w700,
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
