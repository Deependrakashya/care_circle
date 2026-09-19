import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/app_theme.dart';
import '../view_models/residents_view_model.dart';
import '../widgets/resident_header.dart';

class ResidentPickerSheet extends StatelessWidget {
  const ResidentPickerSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ResidentsViewModel>();
    final residents = viewModel.residents;

    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 14, bottom: 4),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 4),
            child: Text(
              'Your family',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
            child: Text(
              'Select a relative to view their updates.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),

          if (residents.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: Text(
                'No relatives are available yet.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppTheme.textTertiary),
              ),
            )
          else
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                itemCount: residents.length,
                itemBuilder: (context, index) {
                  final resident = residents[index];
                  final isSelected =
                      viewModel.selectedResident?.id == resident.id;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Semantics(
                      selected: isSelected,
                      child: ResidentHeader(
                        key: ValueKey(resident.id),
                        initials: resident.avatarInitials,
                        name: resident.name,
                        relationship: resident.relationship,
                        facilityName:
                            '${resident.facility.name} • ${resident.facility.city}',
                        isSelected: isSelected,
                        showChevron: false,
                        onTap: () {
                          context
                              .read<ResidentsViewModel>()
                              .selectResident(resident.id);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
