import 'package:flutter/material.dart';

void showGymCoachToast(BuildContext context, String message) {
  final overlay = Overlay.of(context);
  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (ctx) => Positioned(
      left: 16,
      right: 16,
      bottom: 96,
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xF21C1C1E),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0x5975FF9E),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x80000000),
                  blurRadius: 32,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFE5E2E1),
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    ),
  );
  overlay.insert(entry);
  Future.delayed(const Duration(milliseconds: 2800), entry.remove);
}
