import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models/check_in_request.dart';
import '../data/models/resident.dart';
import '../view_models/check_in_view_model.dart';
import '../theme/app_theme.dart';

class CheckInView extends StatelessWidget {
  const CheckInView({super.key, required this.resident});

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
  CheckInUrgency _urgency = CheckInUrgency.routine;

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Request a check-in'),
      ),
      body: isSuccess
          ? _buildSuccessView(context)
          : _buildFormView(context, viewModel, isSubmitting),
    );
  }

  Widget _buildSuccessView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: AppTheme.primarySoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_outline, size: 64, color: AppTheme.primary),
            ),
            const SizedBox(height: 24),
            Text(
              'Request received',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Text(
              'Your check-in request has been recorded.\nWe will notify you when there is an update.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Return to overview'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormView(
      BuildContext context, CheckInViewModel viewModel, bool isSubmitting) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'What would you like an update about?',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _reasonController,
          enabled: !isSubmitting,
          decoration: InputDecoration(
            labelText: 'Reason',
            hintText: 'e.g. General wellbeing, Medication',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppTheme.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppTheme.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppTheme.primary, width: 2),
            ),
            filled: true,
            fillColor: AppTheme.surface,
            errorText: viewModel.status == CheckInSubmissionStatus.error
                ? viewModel.errorMessage
                : null,
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 32),
        Text(
          'Urgency',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        SegmentedButton<CheckInUrgency>(
          segments: const [
            ButtonSegment(
              value: CheckInUrgency.routine,
              label: Text('Routine'),
            ),
            ButtonSegment(
              value: CheckInUrgency.soon,
              label: Text('Soon'),
            ),
          ],
          selected: {_urgency},
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.selected)) {
                  return AppTheme.primarySoft;
                }
                return AppTheme.surface;
              },
            ),
            foregroundColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.selected)) {
                  return AppTheme.primary;
                }
                return AppTheme.textPrimary;
              },
            ),
          ),
          onSelectionChanged: isSubmitting
              ? null
              : (Set<CheckInUrgency> newSelection) {
                  setState(() {
                    _urgency = newSelection.first;
                  });
                },
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: isSubmitting
                ? null
                : () {
                    FocusScope.of(context).unfocus();
                    viewModel.submitCheckIn(
                      reason: _reasonController.text,
                      urgency: _urgency,
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
        ),
      ],
    );
  }
}
