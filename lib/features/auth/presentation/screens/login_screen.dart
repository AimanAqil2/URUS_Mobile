import 'package:flutter/material.dart';

import '../../../../app/router/route_names.dart';
import '../../../../design_system/components/app_button.dart';
import '../../../../design_system/components/app_card.dart';
import '../../../../design_system/components/app_text_field.dart';
import '../../../../design_system/tokens/app_colors.dart';
import '../../../../design_system/tokens/app_radius.dart';
import '../../../../design_system/tokens/app_shadows.dart';
import '../../../../design_system/tokens/app_spacing.dart';

/// Local-only login form. Authentication is connected in a later phase.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var _isPasswordObscured = true;
  var _hasSubmitted = false;

  void _validateLoginForm() {
    setState(() => _hasSubmitted = true);
    _formKey.currentState?.validate();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 360;
            final horizontalPadding = isCompact ? AppSpacing.md : AppSpacing.lg;
            final logoSize = isCompact ? 70.0 : 78.0;
            final content = Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                AppSpacing.lg,
                horizontalPadding,
                AppSpacing.md,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/urus_icon.png',
                        width: logoSize,
                        height: logoSize,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Welcome Back',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontSize: 29,
                              fontWeight: FontWeight.w700,
                              height: 1.1,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Sign in to continue managing your day.',
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        child: _LoginForm(
                          formKey: _formKey,
                          emailController: _emailController,
                          passwordController: _passwordController,
                          isPasswordObscured: _isPasswordObscured,
                          autovalidateMode: _hasSubmitted
                              ? AutovalidateMode.onUserInteraction
                              : AutovalidateMode.disabled,
                          onTogglePassword: () => setState(() {
                            _isPasswordObscured = !_isPasswordObscured;
                          }),
                          onSignIn: _validateLoginForm,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      const SizedBox(
                        width: double.infinity,
                        child: _SocialDivider(),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      const _GoogleSignInButton(),
                      const SizedBox(height: AppSpacing.lg),
                      _CreateAccountPrompt(
                        onTap: () => Navigator.of(
                          context,
                        ).pushNamed(RouteNames.register),
                      ),
                    ],
                  ),
                ),
              ),
            );

            // Keep the reference layout fixed on normal mobile viewports. When
            // the keyboard or a compact device reduces the body height, allow
            // the form to scroll instead of clipping controls below the fold.
            final isKeyboardVisible =
                MediaQuery.viewInsetsOf(context).bottom > 0;
            final isVerticallyConstrained = constraints.maxHeight < 720;

            // The scroll view stays mounted while the keyboard opens. Swapping
            // between separate layout trees here would dispose a focused field
            // and make Android immediately dismiss the keyboard.
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              physics: isKeyboardVisible || isVerticallyConstrained
                  ? const ClampingScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: content,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.isPasswordObscured,
    required this.autovalidateMode,
    required this.onTogglePassword,
    required this.onSignIn,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isPasswordObscured;
  final AutovalidateMode autovalidateMode;
  final VoidCallback onTogglePassword;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );

    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 21),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _LoginFieldLabel(
              icon: Icons.mail_outline_rounded,
              label: 'Email Address',
              style: labelStyle,
            ),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(
              controller: emailController,
              height: 52,
              hintText: 'name@company.com',
              keyboardType: TextInputType.emailAddress,
              autovalidateMode: autovalidateMode,
              validator: _validateEmail,
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: _LoginFieldLabel(
                    icon: Icons.lock_outline_rounded,
                    label: 'Password',
                    style: labelStyle,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Flexible(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF3D6900),
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Forgot Password?',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: const Color(0xFF3D6900),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(
              controller: passwordController,
              height: 52,
              hintText: '••••••••••',
              obscureText: isPasswordObscured,
              suffixIcon: IconButton(
                onPressed: onTogglePassword,
                icon: Icon(
                  isPasswordObscured
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 22,
                ),
              ),
              autovalidateMode: autovalidateMode,
              validator: _validatePassword,
            ),
            const SizedBox(height: 20),
            AppButton(label: 'SIGN IN  →', onPressed: onSignIn, height: 52),
          ],
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) {
      return 'Enter your email address.';
    }
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) {
      return 'Enter your password.';
    }
    if (password.length < 8) {
      return 'Password must be at least 8 characters.';
    }
    return null;
  }
}

class _LoginFieldLabel extends StatelessWidget {
  const _LoginFieldLabel({
    required this.icon,
    required this.label,
    required this.style,
  });

  final IconData icon;
  final String label;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 21, color: AppColors.textSecondary),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: style,
          ),
        ),
      ],
    );
  }
}

class _SocialDivider extends StatelessWidget {
  const _SocialDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.border)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            'OR CONTINUE WITH',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
            ),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.border)),
      ],
    );
  }
}

class _GoogleSignInButton extends StatelessWidget {
  const _GoogleSignInButton();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: AppRadius.field,
      child: InkWell(
        onTap: () {},
        borderRadius: AppRadius.field,
        child: Ink(
          width: 216,
          height: 50,
          decoration: const BoxDecoration(
            borderRadius: AppRadius.field,
            border: Border.fromBorderSide(BorderSide(color: AppColors.border)),
            boxShadow: AppShadows.card,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'G',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: const Color(0xFF4285F4),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                'Google',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CreateAccountPrompt extends StatelessWidget {
  const _CreateAccountPrompt({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.sm,
      children: [
        Text(
          'Don’t have an account?',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14),
        ),
        InkWell(
          onTap: onTap,
          borderRadius: AppRadius.chip,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text(
              'CREATE ACCOUNT',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: const Color(0xFF3D6900),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
