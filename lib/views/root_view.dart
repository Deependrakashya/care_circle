import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/app_theme.dart';
import '../view_models/resident_detail_view_model.dart';
import '../view_models/residents_view_model.dart';
import 'resident_detail_view.dart';

class RootView extends StatefulWidget {
  const RootView({super.key});

  @override
  State<RootView> createState() => _RootViewState();
}

class _RootViewState extends State<RootView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ResidentsViewModel>().loadResidents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ResidentsViewModel>();

    return switch (viewModel.status) {
      ResidentsStatus.initial || ResidentsStatus.loading => const _LoadingState(),
      ResidentsStatus.error => _MessageState(
          icon: Icons.cloud_off_outlined,
          headline: 'Something went wrong',
          body: viewModel.errorMessage ??
              'We couldn\'t load your family\'s information.',
          actionLabel: 'Try again',
          onAction: () =>
              context.read<ResidentsViewModel>().loadResidents(),
        ),
      ResidentsStatus.empty => _MessageState(
          icon: Icons.people_outline_rounded,
          headline: 'No relatives yet',
          body: 'No relatives are available in CareCircle right now.',
          actionLabel: 'Refresh',
          onAction: () =>
              context.read<ResidentsViewModel>().loadResidents(),
        ),
      ResidentsStatus.ready => () {
          final resident = viewModel.selectedResident;
          if (resident == null) {
            return _MessageState(
              icon: Icons.person_outline_rounded,
              headline: 'No relative selected',
              body: 'Please refresh to select a relative.',
              actionLabel: 'Refresh',
              onAction: () =>
                  context.read<ResidentsViewModel>().loadResidents(),
            );
          }
          return ChangeNotifierProvider(
            key: ValueKey(resident.id),
            create: (context) => ResidentDetailViewModel(
              resident: resident,
              summaryRepository: context.read(),
              eventRepository: context.read(),
              vitalRepository: context.read(),
              staffUpdateRepository: context.read(),
            ),
            child: const ResidentDetailView(),
          );
        }(),
    };
  }
}

// ─── Loading state — calm, centered ─────────────────────────────────────────
class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Soft pulsing indicator
            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: AppTheme.primarySoft,
                shape: BoxShape.circle,
              ),
              child: const Padding(
                padding: EdgeInsets.all(14),
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppTheme.primary,
                  semanticsLabel: 'Loading',
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Loading CareCircle…',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppTheme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Error / empty message state ─────────────────────────────────────────────
class _MessageState extends StatelessWidget {
  final IconData icon;
  final String headline;
  final String body;
  final String actionLabel;
  final VoidCallback onAction;

  const _MessageState({
    required this.icon,
    required this.headline,
    required this.body,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(36),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 44, color: AppTheme.textTertiary),
              const SizedBox(height: 16),
              Text(
                headline,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                body,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: 180,
                child: FilledButton(
                  onPressed: onAction,
                  child: Text(actionLabel),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
