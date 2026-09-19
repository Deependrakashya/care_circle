import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models/check_in_request.dart';
import '../data/models/resident.dart';
import '../view_models/check_in_view_model.dart';
import '../theme/app_theme.dart';

class CheckInSheet extends StatelessWidget {
  const CheckInSheet({super.key, required this.resident});

  final Resident resident;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          CheckInViewModel(resident: resident, repository: context.read()),
      child: const _CheckInContent(),
    );
  }
}

class _CheckInContent extends StatefulWidget {
  const _CheckInContent();

  @override
  State<_CheckInContent> createState() => _CheckInContentState();
}

class _CheckInContentState extends State<_CheckInContent> {
  final _reasonController = TextEditingController();
  String _selectedReason = 'General wellbeing';

  final List<String> _options = [
    'General wellbeing',
    'Medication',
    'Meals',
    'Activity',
    'Other',
  ];

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CheckInViewModel>();
    final isSubmitting = viewModel.status == CheckInSubmissionStatus.submitting;
    final isSuccess = viewModel.status == CheckInSubmissionStatus.success;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: isSuccess
          ? _buildSuccess(context)
          : _buildForm(context, viewModel, isSubmitting),
    );
  }

  // ─── Success view — animated check entrance ───────────────────────────────
  Widget _buildSuccess(BuildContext context) {
    return _AnimatedSuccessView(onClose: () => Navigator.pop(context));
  }

  // ─── Form view ────────────────────────────────────────────────────────────
  Widget _buildForm(
    BuildContext context,
    CheckInViewModel viewModel,
    bool isSubmitting,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),

          Text(
            'Request a check-in',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 6),
          Text(
            'What would you like an update about?',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),

          // Reason options — custom animated tap chips
          ..._options.map(
            (option) => _buildOption(context, option, isSubmitting),
          ),

          // Other text field
          if (_selectedReason == 'Other') ...[
            const SizedBox(height: 12),
            TextField(
              controller: _reasonController,
              enabled: !isSubmitting,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppTheme.textPrimary),
              decoration: InputDecoration(
                hintText: 'Please describe your concern…',
                hintStyle: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppTheme.textTertiary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: AppTheme.border,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: AppTheme.border,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: AppTheme.primary,
                    width: 1.5,
                  ),
                ),
                filled: true,
                fillColor: AppTheme.background,
                contentPadding: const EdgeInsets.all(14),
                errorText: viewModel.status == CheckInSubmissionStatus.error
                    ? viewModel.errorMessage
                    : null,
              ),
              maxLines: 2,
            ),
          ],

          // Non-other error
          if (_selectedReason != 'Other' &&
              viewModel.status == CheckInSubmissionStatus.error) ...[
            const SizedBox(height: 8),
            Text(
              viewModel.errorMessage ?? '',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppTheme.semanticError),
            ),
          ],

          const SizedBox(height: 28),

          FilledButton(
            onPressed: isSubmitting
                ? null
                : () {
                    FocusScope.of(context).unfocus();
                    String finalReason = _selectedReason;
                    if (_selectedReason == 'Other') {
                      finalReason = _reasonController.text;
                    }
                    viewModel.submitCheckIn(
                      reason: finalReason,
                      urgency: CheckInUrgency.routine,
                    );
                  },
            child: isSubmitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Send request'),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(BuildContext context, String option, bool disabled) {
    final isSelected = _selectedReason == option;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: disabled ? null : () => setState(() => _selectedReason = option),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primarySoft : AppTheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? AppTheme.primary.withValues(alpha: 0.4)
                  : AppTheme.borderSubtle,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  option,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isSelected ? AppTheme.primary : AppTheme.textPrimary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              if (isSelected)
                Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: AppTheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, size: 12, color: Colors.white),
                )
              else
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.border, width: 1.5),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Animated check-in success view ─────────────────────────────────────────
/// Scale-in + fade entrance for the confirmation icon.
/// One-shot, 350ms — calm, not celebratory.
class _AnimatedSuccessView extends StatefulWidget {
  final VoidCallback onClose;
  const _AnimatedSuccessView({required this.onClose});

  @override
  State<_AnimatedSuccessView> createState() => _AnimatedSuccessViewState();
}

class _AnimatedSuccessViewState extends State<_AnimatedSuccessView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _fade;
  late final Animation<double> _textFade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    // Icon: scale from 0.6 → 1.0 with a soft overshoot
    _scale = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));
    // Icon: fade 0 → 1 in first 70% of duration
    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );
    // Text: fades in after icon is mostly settled (35%–100%)
    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.35, 1.0, curve: Curves.easeOut),
      ),
    );
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 44, 32, 48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animated check circle — scale + fade
          ScaleTransition(
            scale: _scale,
            child: FadeTransition(
              opacity: _fade,
              child: Container(
                width: 84,
                height: 84,
                decoration: const BoxDecoration(
                  color: AppTheme.primarySoft,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 42,
                  color: AppTheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Text block fades in slightly after icon settles
          FadeTransition(
            opacity: _textFade,
            child: Column(
              children: [
                Text(
                  'Request received',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Your check-in request has been recorded.\nWe will notify you when there is an update.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: widget.onClose,
                  child: const Text('Done'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
