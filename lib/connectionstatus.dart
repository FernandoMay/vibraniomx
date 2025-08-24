import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibraniomx/chainservice.dart';
import 'package:vibraniomx/providers.dart';
import 'package:vibraniomx/theme.dart';

class ConnectionStatus extends ConsumerWidget {
  const ConnectionStatus({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blockchainService = BlockchainService();
    final isConnected = blockchainService.isConnected;
    final userAddress = blockchainService.userAddress;

    return GestureDetector(
      onTap: () async {
        if (!isConnected) {
          await blockchainService.connectWallet();
          ref.invalidate(blockchainServiceProvider);
              // Invalidate providers that depend on connection status
        } else {
          await blockchainService.disconnect();
          ref.invalidate(blockchainServiceProvider);
                      }
      },
              // Invalidate providers that depend on connection status
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isConnected
              ? AppTheme.primary.withOpacity(0.2)
              : AppTheme.surface.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isConnected
                  ? AppTheme.primary
                  : AppTheme.textSecondary.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isConnected ? Icons.link : Icons.link_off,
              color: isConnected ? AppTheme.primary : AppTheme.textSecondary,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              isConnected
                  ? 'Connected'
                  : 'Connect Wallet',
              style: TextStyle(
                color:
                    isConnected ? AppTheme.primary : AppTheme.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
