import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_models/resident_detail_view_model.dart';
import '../view_models/residents_view_model.dart';
import 'resident_detail_view.dart';

class ResidentsView extends StatelessWidget {
  const ResidentsView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ResidentsViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('CareCircle'),
        actions: [
          IconButton(
            tooltip: 'Refresh relatives',
            onPressed: viewModel.isLoading
                ? null
                : () => context.read<ResidentsViewModel>().loadResidents(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: switch (viewModel.status) {
          ResidentsStatus.initial || ResidentsStatus.loading => const Center(
            child: CircularProgressIndicator(
              semanticsLabel: 'Loading relatives',
            ),
          ),
          ResidentsStatus.error => _MessageState(
            message: viewModel.errorMessage!,
            actionLabel: 'Try again',
            onAction: () => context.read<ResidentsViewModel>().loadResidents(),
          ),
          ResidentsStatus.empty => _MessageState(
            message: 'No relatives are available yet.',
            actionLabel: 'Refresh',
            onAction: () => context.read<ResidentsViewModel>().loadResidents(),
          ),
          ResidentsStatus.ready => RefreshIndicator(
            onRefresh: () => context.read<ResidentsViewModel>().loadResidents(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  'Your family',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Choose a relative. They control what is shared with you.',
                ),
                const SizedBox(height: 20),
                for (final resident in viewModel.residents)
                  Card(
                    child: Semantics(
                      selected: viewModel.selectedResident?.id == resident.id,
                      child: ListTile(
                        key: ValueKey(resident.id),
                        contentPadding: const EdgeInsets.all(16),
                        leading: CircleAvatar(
                          child: Text(resident.avatarInitials),
                        ),
                        title: Text(resident.name),
                        subtitle: Text(
                          '${resident.relationship}\n'
                          '${resident.facility.name}, ${resident.facility.city}',
                        ),
                        isThreeLine: true,
                        trailing: viewModel.selectedResident?.id == resident.id
                            ? const Icon(
                                Icons.check_circle,
                                semanticLabel: 'Selected',
                              )
                            : null,
                        onTap: () {
                          context
                              .read<ResidentsViewModel>()
                              .selectResident(resident.id);
                          
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChangeNotifierProvider(
                                create: (context) => ResidentDetailViewModel(
                                  resident: resident,
                                  summaryRepository: context.read(),
                                  eventRepository: context.read(),
                                  vitalRepository: context.read(),
                                  staffUpdateRepository: context.read(),
                                ),
                                child: const ResidentDetailView(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                if (viewModel.selectedResident case final selected?)
                  Text('Selected: ${selected.name}'),
              ],
            ),
          ),
        },
      ),
    );
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState({
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: onAction, child: Text(actionLabel)),
          ],
        ),
      ),
    );
  }
}
