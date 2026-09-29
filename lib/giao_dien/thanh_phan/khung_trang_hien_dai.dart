import 'package:flutter/material.dart';

/// Khung trang dùng chung để tạo giao diện đồng nhất, hiện đại cho toàn app.
class KhungTrangHienDai extends StatelessWidget {
  const KhungTrangHienDai({
    super.key,
    required this.tieuDe,
    required this.noiDung,
    this.moTa,
    this.hanhDong,
  });

  final String tieuDe;
  final String? moTa;
  final Widget noiDung;
  final List<Widget>? hanhDong;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primaryContainer,
                  Theme.of(context).colorScheme.secondaryContainer,
                ],
              ),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Wrap(
              runSpacing: 16,
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tieuDe,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      if (moTa != null) ...[
                        const SizedBox(height: 10),
                        Text(
                          moTa!,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ],
                  ),
                ),
                if (hanhDong != null)
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: hanhDong!,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          noiDung,
        ],
      ),
    );
  }
}
