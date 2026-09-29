import 'package:flutter/material.dart';

import '../../dich_vu/dich_vu_ho_so.dart';
import '../../mo_hinh/ho_so_nguoi_dung.dart';
import '../../tien_ich/thong_bao.dart';
import '../thanh_phan/khung_trang_hien_dai.dart';

/// Trang cho phép người dùng xem và cập nhật hồ sơ cá nhân.
class TrangHoSo extends StatefulWidget {
  const TrangHoSo({
    super.key,
    required this.hoSo,
    required this.onDaCapNhat,
  });

  final HoSoNguoiDung hoSo;
  final Future<void> Function() onDaCapNhat;

  @override
  State<TrangHoSo> createState() => _TrangHoSoState();
}

class _TrangHoSoState extends State<TrangHoSo> {
  final _dichVuHoSo = DichVuHoSo();
  late final TextEditingController _hoTenController;
  late final TextEditingController _soDienThoaiController;
  late final TextEditingController _lopController;
  late final TextEditingController _khoaController;
  late final TextEditingController _nganhController;
  late final TextEditingController _anhController;

  bool _dangLuu = false;

  @override
  void initState() {
    super.initState();
    _hoTenController = TextEditingController(text: widget.hoSo.hoTen);
    _soDienThoaiController =
        TextEditingController(text: widget.hoSo.soDienThoai ?? '');
    _lopController =
        TextEditingController(text: widget.hoSo.lopHanhChinh ?? '');
    _khoaController = TextEditingController(text: widget.hoSo.khoa ?? '');
    _nganhController = TextEditingController(text: widget.hoSo.nganh ?? '');
    _anhController =
        TextEditingController(text: widget.hoSo.anhDaiDienUrl ?? '');
  }

  @override
  void dispose() {
    _hoTenController.dispose();
    _soDienThoaiController.dispose();
    _lopController.dispose();
    _khoaController.dispose();
    _nganhController.dispose();
    _anhController.dispose();
    super.dispose();
  }

  /// Lưu các trường hồ sơ mà người dùng được phép sửa.
  Future<void> _luuHoSo() async {
    setState(() => _dangLuu = true);

    try {
      await _dichVuHoSo.capNhatHoSo({
        'ho_ten': _hoTenController.text.trim(),
        'so_dien_thoai': _soDienThoaiController.text.trim(),
        'lop_hanh_chinh': _lopController.text.trim(),
        'khoa': _khoaController.text.trim(),
        'nganh': _nganhController.text.trim(),
        'anh_dai_dien_url': _anhController.text.trim(),
      });

      if (!mounted) return;
      ThongBao.thanhCong(context, 'Đã cập nhật hồ sơ.');
      await widget.onDaCapNhat();
    } catch (loi) {
      if (!mounted) return;
      ThongBao.loi(context, loi);
    } finally {
      if (mounted) {
        setState(() => _dangLuu = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mau = Theme.of(context).colorScheme;

    return KhungTrangHienDai(
      tieuDe: 'Hồ sơ cá nhân',
      moTa: 'Bạn có thể chỉnh sửa các trường thông tin cơ bản ở đây.',
      hanhDong: [
        FilledButton.icon(
          onPressed: _dangLuu ? null : _luuHoSo,
          icon: const Icon(Icons.save_outlined),
          label: const Text('Lưu hồ sơ'),
        ),
      ],
      noiDung: Wrap(
        spacing: 18,
        runSpacing: 18,
        children: [
          Container(
            width: 320,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: mau.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: mau.outlineVariant),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 44,
                  backgroundColor: mau.primaryContainer,
                  child: Icon(
                    Icons.person,
                    color: mau.primary,
                    size: 42,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.hoSo.hoTen,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 8),
                Text(widget.hoSo.email ?? 'Chưa có email'),
                const SizedBox(height: 8),
                Chip(label: Text(widget.hoSo.nhanVaiTro)),
                const SizedBox(height: 8),
                if (widget.hoSo.maSinhVien != null)
                  Text('Mã sinh viên: ${widget.hoSo.maSinhVien}'),
                if (widget.hoSo.maGiangVien != null)
                  Text('Mã giảng viên: ${widget.hoSo.maGiangVien}'),
              ],
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: mau.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: mau.outlineVariant),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _hoTenController,
                    decoration: const InputDecoration(
                      labelText: 'Họ tên',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.mail_outline),
                      hintText: widget.hoSo.email ?? '',
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Vai trò',
                      prefixIcon: const Icon(Icons.badge_outlined),
                      hintText: widget.hoSo.nhanVaiTro,
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _soDienThoaiController,
                    decoration: const InputDecoration(
                      labelText: 'Số điện thoại',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _lopController,
                    decoration: const InputDecoration(
                      labelText: 'Lớp hành chính',
                      prefixIcon: Icon(Icons.groups_outlined),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _khoaController,
                    decoration: const InputDecoration(
                      labelText: 'Khoa',
                      prefixIcon: Icon(Icons.apartment_outlined),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _nganhController,
                    decoration: const InputDecoration(
                      labelText: 'Ngành',
                      prefixIcon: Icon(Icons.school_outlined),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _anhController,
                    decoration: const InputDecoration(
                      labelText: 'URL ảnh đại diện',
                      prefixIcon: Icon(Icons.image_outlined),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
