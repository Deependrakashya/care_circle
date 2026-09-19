import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

/// The emotional hero of the CareCircle experience.
///
/// Renders a calm reassurance state with the Care Pulse motif — soft
/// concentric circles behind the icon that communicate presence and
/// connection rather than monitoring.
class ReassuranceCard extends StatefulWidget {
  final String headline;
  final String? explanation;
  final DateTime lastUpdated;
  final bool isInsufficientData;
  final VoidCallback? onRequestCheckIn;
  // Resident first name used for the "Shared with you by…" attribution.
  final String? residentFirstName;

  const ReassuranceCard({
    super.key,
    required this.headline,
    this.explanation,
    required this.lastUpdated,
    this.isInsufficientData = false,
    this.onRequestCheckIn,
    this.residentFirstName,
  });

  @override
  State<ReassuranceCard> createState() => _ReassuranceCardState();
}

class _ReassuranceCardState extends State<ReassuranceCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fadeIn;
  late final Animation<Offset> _slideIn;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeIn = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slideIn = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));

    // Single entrance — does not loop.
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeIn,
      child: SlideTransition(
        position: _slideIn,
        child: _buildCard(context),
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    final bg = widget.isInsufficientData
        ? const Color(0xFFFAEED8)
        : AppTheme.heroSurface;

    final pulseColor = widget.isInsufficientData
        ? const Color(0xFFCE9244) // warm amber
        : AppTheme.primary;

    final iconBg = widget.isInsufficientData
        ? const Color(0xFFEFD5A4).withValues(alpha: 0.55)
        : AppTheme.primary.withValues(alpha: 0.12);

    final iconColor = widget.isInsufficientData
        ? AppTheme.semanticCaution
        : AppTheme.primary;

    final icon = widget.isInsufficientData
        ? Icons.info_outline_rounded
        : Icons.favorite_border_rounded;

    final headlineColor = widget.isInsufficientData
        ? const Color(0xFF7A5020)
        : AppTheme.textPrimary;

    final firstName = widget.residentFirstName;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppTheme.heroRadius),
        border: Border.all(
          color: widget.isInsufficientData
              ? const Color(0xFFE8C98A).withValues(alpha: 0.6)
              : AppTheme.primary.withValues(alpha: 0.12),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.isInsufficientData
                ? const Color(0xFFCE9244).withValues(alpha: 0.08)
                : AppTheme.primary.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.heroRadius),
        child: Stack(
          children: [
            // ── Care Pulse motif — low-opacity concentric circles ──────────
            Positioned(
              right: -30,
              top: -30,
              child: _CarePulse(color: pulseColor),
            ),

            // ── Card content ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon container
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: iconBg,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: iconColor, size: 22),
                  ),
                  const SizedBox(height: 18),

                  // Headline — most important text on the screen
                  Text(
                    widget.headline,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: headlineColor,
                          height: 1.2,
                        ),
                  ),

                  // Explanation — supporting sentence
                  if (widget.explanation != null &&
                      widget.explanation!.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      widget.explanation!,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: widget.isInsufficientData
                                ? const Color(0xFF9A6B30)
                                : AppTheme.textSecondary,
                            height: 1.5,
                          ),
                    ),
                  ],

                  const SizedBox(height: 22),

                  // Subtle divider
                  Container(
                    height: 1,
                    color: widget.isInsufficientData
                        ? const Color(0xFFE8C98A).withValues(alpha: 0.45)
                        : AppTheme.primary.withValues(alpha: 0.1),
                  ),

                  const SizedBox(height: 14),

                  // Freshness row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 13,
                        color: widget.isInsufficientData
                            ? AppTheme.semanticCaution.withValues(alpha: 0.7)
                            : AppTheme.primary.withValues(alpha: 0.55),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Latest CareCircle update · ${DateFormat.jm().format(widget.lastUpdated.toLocal())}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: widget.isInsufficientData
                                  ? AppTheme.semanticCaution.withValues(alpha: 0.8)
                                  : AppTheme.primary.withValues(alpha: 0.65),
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      if (widget.isInsufficientData &&
                          widget.onRequestCheckIn != null) ...[
                        const Spacer(),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: widget.onRequestCheckIn,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                            child: Text(
                              'Request update',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppTheme.semanticCaution,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppTheme.semanticCaution
                                        .withValues(alpha: 0.5),
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  // ── "Shared with you by…" — resident agency cue ───────────
                  if (!widget.isInsufficientData && firstName != null) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.shield_outlined,
                          size: 12,
                          color: AppTheme.primary.withValues(alpha: 0.6),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Shared with you by $firstName',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.primary.withValues(alpha: 0.7),
                                    fontStyle: FontStyle.italic,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Care Pulse — three soft concentric circles using the brand color.
/// Opacity and scale are chosen so they never draw focus from the text.
class _CarePulse extends StatelessWidget {
  final Color color;
  const _CarePulse({required this.color});

  @override
  Widget build(BuildContext context) {
    // Three concentric circles, outermost first.
    // Sizes: 140 → 100 → 66. All very low opacity.
    return SizedBox(
      width: 140,
      height: 140,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _circle(140, color.withValues(alpha: 0.055)),
          _circle(100, color.withValues(alpha: 0.07)),
          _circle(66, color.withValues(alpha: 0.09)),
        ],
      ),
    );
  }

  Widget _circle(double size, Color fill) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: fill,
        shape: BoxShape.circle,
      ),
    );
  }
}
