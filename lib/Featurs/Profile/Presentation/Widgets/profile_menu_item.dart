import 'package:flutter/material.dart';
import '../../../../Core/Theme/app_palette.dart';

class ProfileMenuItem extends StatelessWidget {
  final String icon;
  final String title;
  final String? trailingLabel;
  final VoidCallback? onTap;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.trailingLabel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: context.elevatedCardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon box
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: context.primaryColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Image.asset(
                  icon,
                  width: 55,
                  height: 55,
                 ),
              ),
            ),
            const SizedBox(width: 16),

            // Title
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                  color: context.accentColor,
                ),
              ),
            ),

            // Trailing
            if (trailingLabel != null)
              Text(
                trailingLabel!,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: context.accentColor,
                ),
              )
            else
              Icon(
                Icons.chevron_right,
                color: context.textSecondaryColor,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
