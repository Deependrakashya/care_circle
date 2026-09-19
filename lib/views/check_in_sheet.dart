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
      create: (context) => CheckInViewModel(
        resident: resident,
        repository: context.read(),
      ),
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
    final isSubmitting =
        viewModel.status == CheckInSubmissionStatus.submitting;
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

  // ─── Success view ─────────────────────────────────────────────────────────
  Widget _buildSuccess(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 40, 32, 48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Check icon in tinted circle
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.primarySoft,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              size: 40,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(height: 24),
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
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  // ─── Form view ────────────────────────────────────────────────────────────
  Widget _buildForm(BuildContext context, CheckInViewModel viewModel,
      bool isSubmitting) {
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

          // Reason options — custom tappable chips
          ..._options.map((option) => _buildOption(
                context,
                option,
                isSubmitting,
              )),

          // Other text field
          if (_selectedReason == 'Other') ...[
            const SizedBox(height: 12),
            TextField(
              controller: _reasonController,
              enabled: !isSubmitting,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppTheme.textPrimary),
              decoration: InputDecoration(
                hintText: 'Please describe your concern…',
                hintStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppTheme.textTertiary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide:
                      const BorderSide(color: AppTheme.border, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide:
                      const BorderSide(color: AppTheme.border, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide:
                      const BorderSide(color: AppTheme.primary, width: 1.5),
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
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppTheme.semanticError),
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
        onTap: disabled
            ? null
            : () => setState(() => _selectedReason = option),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                        color: isSelected
                            ? AppTheme.primary
                            : AppTheme.textPrimary,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
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
                    border:
                        Border.all(color: AppTheme.border, width: 1.5),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
