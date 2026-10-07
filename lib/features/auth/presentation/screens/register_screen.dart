import 'package:flutter/material.dart';

import '../../../../design_system/components/app_button.dart';
import '../../../../design_system/components/app_card.dart';
import '../../../../design_system/components/app_text_field.dart';
import '../../../../design_system/tokens/app_colors.dart';
import '../../../../design_system/tokens/app_radius.dart';
import '../../../../design_system/tokens/app_spacing.dart';

/// Local-only registration form. Account creation is connected in a later phase.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  var _isPasswordObscured = true;
  var _isConfirmPasswordObscured = true;
  var _hasAcceptedTerms = false;
  var _hasSubmitted = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() => _hasSubmitted = true);
    final isFormValid = _formKey.currentState?.validate() ?? false;
    if (!isFormValid || !_hasAcceptedTerms) {
      return;
    }

    // Registration is intentionally local-only until authentication is added.
  }

  void _togglePasswordVisibility({required bool isConfirmation}) {
    setState(() {
      if (isConfirmation) {
        _isConfirmPasswordObscured = !_isConfirmPasswordObscured;
      } else {
        _isPasswordObscured = !_isPasswordObscured;
      }
    });

    // Keep the active field focused so Android does not dismiss its keyboard
    // while the user reveals or hides the password.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      (isConfirmation ? _confirmPasswordFocusNode : _passwordFocusNode)
          .requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final autovalidateMode = _hasSubmitted
        ? AutovalidateMode.onUserInteraction
        : AutovalidateMode.disabled;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 360;
            final horizontalPadding = isCompact ? AppSpacing.md : AppSpacing.lg;
            final formPadding = isCompact ? 20.0 : 22.0;
            final heroSize = isCompact ? 70.0 : 78.0;
            final titleSize = isCompact ? 28.0 : 29.0;

            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                AppSpacing.lg,
                horizontalPadding,
                AppSpacing.xl,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              onPressed: () => Navigator.of(context).maybePop(),
                              icon: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                              ),
                              style: IconButton.styleFrom(
                                backgroundColor: AppColors.surfaceMuted,
                                foregroundColor: AppColors.textPrimary,
                                minimumSize: const Size(56, 56),
                              ),
                            ),
                          ),
                          Image.asset(
                            'assets/images/urus_icon.png',
                            width: heroSize,
                            height: heroSize,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Create Account',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontSize: titleSize,
                              fontWeight: FontWeight.w700,
                              height: 1.12,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Start planning smarter with URUS.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 28),
                      AppCard(
                        padding: EdgeInsets.all(formPadding),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _FieldLabel(
                                icon: Icons.person_outline_rounded,
                                label: 'Full Name',
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              AppTextField(
                                controller: _nameController,
                                height: 52,
                                hintText: 'e.g. Faris Al-Hadi',
                                autovalidateMode: autovalidateMode,
                                validator: _validateName,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              _FieldLabel(
                                icon: Icons.mail_outline_rounded,
                                label: 'Work Email',
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              AppTextField(
                                controller: _emailController,
                                height: 52,
                                hintText: 'name@company.com',
                                keyboardType: TextInputType.emailAddress,
                                autovalidateMode: autovalidateMode,
                                validator: _validateEmail,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              _FieldLabel(
                                icon: Icons.lock_outline_rounded,
                                label: 'Password',
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              AppTextField(
                                controller: _passwordController,
                                focusNode: _passwordFocusNode,
                                height: 52,
                                hintText: 'At least 8 characters',
                                obscureText: _isPasswordObscured,
                                suffixIcon: IconButton(
                                  tooltip: _isPasswordObscured
                                      ? 'Show password'
                                      : 'Hide password',
                                  onPressed: () => _togglePasswordVisibility(
                                    isConfirmation: false,
                                  ),
                                  icon: Icon(
                                    _isPasswordObscured
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    size: 21,
                                  ),
                                ),
                                autovalidateMode: autovalidateMode,
                                validator: _validatePassword,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              _FieldLabel(
                                icon: Icons.lock_reset_outlined,
                                label: 'Confirm Password',
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              AppTextField(
                                controller: _confirmPasswordController,
                                focusNode: _confirmPasswordFocusNode,
                                height: 52,
                                hintText: 'Confirm your password',
                                obscureText: _isConfirmPasswordObscured,
                                suffixIcon: IconButton(
                                  tooltip: _isConfirmPasswordObscured
                                      ? 'Show password'
                                      : 'Hide password',
                                  onPressed: () => _togglePasswordVisibility(
                                    isConfirmation: true,
                                  ),
                                  icon: Icon(
                                    _isConfirmPasswordObscured
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    size: 21,
                                  ),
                                ),
                                autovalidateMode: autovalidateMode,
                                validator: _validateConfirmation,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Row(
                                children: [
                                  Checkbox(
                                    value: _hasAcceptedTerms,
                                    activeColor: AppColors.primary,
                                    onChanged: (value) => setState(
                                      () => _hasAcceptedTerms = value ?? false,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      'I agree to the Terms & Privacy Policy.',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                  ),
                                ],
                              ),
                              if (_hasSubmitted && !_hasAcceptedTerms)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: AppSpacing.md,
                                    bottom: AppSpacing.sm,
                                  ),
                                  child: Text(
                                    'Please accept the Terms & Privacy Policy.',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(color: AppColors.urgent),
                                  ),
                                ),
                              const SizedBox(height: AppSpacing.md),
                              AppButton(
                                label: 'CREATE ACCOUNT  →',
                                onPressed: _submit,
                                height: 54,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _TrialNotice(isCompact: isCompact),
                      const SizedBox(height: AppSpacing.xl),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: AppSpacing.sm,
                        children: [
                          Text(
                            'Already have an account?',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          InkWell(
                            onTap: () => Navigator.of(context).maybePop(),
                            borderRadius: AppRadius.chip,
                            child: Text(
                              'SIGN IN',
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(
                                    color: const Color(0xFF3D6900),
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String? _validateName(String? value) {
    if ((value?.trim().length ?? 0) < 2) {
      return 'Enter your full name.';
    }
    return null;
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
    if ((value ?? '').length < 8) {
      return 'Password must be at least 8 characters.';
    }
    return null;
  }

  String? _validateConfirmation(String? value) {
    if ((value ?? '').isEmpty) {
      return 'Confirm your password.';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match.';
    }
    return null;
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.icon, required this.label});

  final IconData icon;
  final String label;

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
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _TrialNotice extends StatelessWidget {
  const _TrialNotice({required this.isCompact});

  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      borderRadius: AppRadius.field,
      child: Row(
        children: [
          Container(
            width: isCompact ? 44 : 48,
            height: isCompact ? 44 : 48,
            decoration: const BoxDecoration(
              color: AppColors.aiSoft,
              borderRadius: AppRadius.field,
            ),
            child: const Icon(
              Icons.workspace_premium_outlined,
              color: AppColors.aiPurple,
            ),
          ),
          SizedBox(width: isCompact ? AppSpacing.sm : AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '14-Day Pro Trial',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Full AI triage unlocked immediately',
                  maxLines: isCompact ? 2 : 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: AppRadius.field,
            ),
            child: Text(
              'FREE',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
