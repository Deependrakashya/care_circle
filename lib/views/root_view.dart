import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter/services.dart';

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
  DateTime? _lastPressedAt;

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

    final content = switch (viewModel.status) {
      ResidentsStatus.initial ||
      ResidentsStatus.loading => const _LoadingState(),
      ResidentsStatus.error => _MessageState(
        icon: Icons.cloud_off_outlined,
        headline: 'Something went wrong',
        body:
            viewModel.errorMessage ??
            'We couldn\'t load your family\'s information.',
        actionLabel: 'Try again',
        onAction: () => context.read<ResidentsViewModel>().loadResidents(),
      ),
      ResidentsStatus.empty => _MessageState(
        icon: Icons.people_outline_rounded,
        headline: 'No relatives yet',
        body: 'No relatives are available in CareCircle right now.',
        actionLabel: 'Refresh',
        onAction: () => context.read<ResidentsViewModel>().loadResidents(),
      ),
      ResidentsStatus.ready => () {
        final resident = viewModel.selectedResident;
        if (resident == null) {
          return _MessageState(
            icon: Icons.person_outline_rounded,
            headline: 'No relative selected',
            body: 'Please refresh to select a relative.',
            actionLabel: 'Refresh',
            onAction: () => context.read<ResidentsViewModel>().loadResidents(),
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

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        final now = DateTime.now();
        if (_lastPressedAt == null ||
            now.difference(_lastPressedAt!) > const Duration(seconds: 2)) {
          _lastPressedAt = now;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Press back again to exit'),
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          SystemNavigator.pop();
        }
      },
      child: content,
    );
  }
}

// ─── Loading state — calm, centered ─────────────────────────────────────────
class _LoadingState extends StatefulWidget {
  const _LoadingState();

  @override
  State<_LoadingState> createState() => _LoadingStateState();
}

class _LoadingStateState extends State<_LoadingState>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _scale = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ScaleTransition(
              scale: _scale,
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppTheme.primarySoft,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withValues(alpha: 0.15),
                      blurRadius: 24,
                      spreadRadius: 8,
                    ),
                  ],
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: AppTheme.primary,
                    semanticsLabel: 'Loading',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Loading CareCircle…',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Error / empty message state ─────────────────────────────────────────────
class _MessageState extends StatefulWidget {
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
  State<_MessageState> createState() => _MessageStateState();
}

class _MessageStateState extends State<_MessageState>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _float;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _float = Tween<double>(
      begin: -6.0,
      end: 6.0,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(36),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(AppTheme.cardRadius),
              border: Border.all(color: AppTheme.borderSubtle, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: _float,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _float.value),
                      child: child,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: AppTheme.heroSurface,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(widget.icon, size: 36, color: AppTheme.primary),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  widget.headline,
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.body,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: widget.onAction,
                    child: Text(widget.actionLabel),
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
