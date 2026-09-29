import 'package:flutter/material.dart';

/// Tiện ích hiển thị thông báo nhanh trên ứng dụng.
class ThongBao {
  /// Hiển thị snackbar thành công.
  static void thanhCong(BuildContext context, String noiDung) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(noiDung),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green.shade700,
      ),
    );
  }

  /// Hiển thị snackbar lỗi.
  static void loi(BuildContext context, Object loi) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(loi.toString()),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red.shade700,
      ),
    );
  }

  /// Hiển thị hộp thoại xác nhận trước khi thực hiện tác vụ quan trọng.
  static Future<bool> xacNhan(
    BuildContext context, {
    required String tieuDe,
    required String noiDung,
  }) async {
    final ketQua = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(tieuDe),
          content: Text(noiDung),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Huỷ'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Đồng ý'),
            ),
          ],
        );
      },
    );

    return ketQua ?? false;
  }
}
