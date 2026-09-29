import 'package:flutter/material.dart';

import '../dich_vu/dich_vu_xac_thuc.dart';
import '../tien_ich/thong_bao.dart';

/// Màn hình đăng nhập và đăng ký người dùng.
///
/// Chức năng:
/// - Đăng nhập bằng email và mật khẩu
/// - Đăng ký tài khoản mới
/// - Ẩn/hiện mật khẩu bằng icon con mắt
/// - Nhấn giữ icon để hiện mật khẩu tạm thời
/// - Kiểm tra xác nhận mật khẩu khi đăng ký
class ManHinhDangNhap extends StatefulWidget {
  const ManHinhDangNhap({super.key});

  @override
  State<ManHinhDangNhap> createState() => _ManHinhDangNhapState();
}

class _ManHinhDangNhapState extends State<ManHinhDangNhap> {
  final _emailController = TextEditingController();
  final _matKhauController = TextEditingController();
  final _xacNhanMatKhauController = TextEditingController();
  final _hoTenController = TextEditingController();
  final _dichVuXacThuc = DichVuXacThuc();

  bool _laDangNhap = true;
  bool _dangXuLy = false;
  String _vaiTro = 'sinh_vien';

  /// Trạng thái bật/tắt hiển thị mật khẩu theo kiểu nhấn 1 lần.
  bool _hienMatKhau = false;

  /// Trạng thái bật/tắt hiển thị xác nhận mật khẩu theo kiểu nhấn 1 lần.
  bool _hienXacNhanMatKhau = false;

  /// Trạng thái hiện tạm thời khi người dùng nhấn giữ icon mắt.
  bool _giuDeHienMatKhau = false;

  /// Trạng thái hiện tạm thời của ô xác nhận mật khẩu khi nhấn giữ.
  bool _giuDeHienXacNhanMatKhau = false;

  @override
  void dispose() {
    _emailController.dispose();
    _matKhauController.dispose();
    _xacNhanMatKhauController.dispose();
    _hoTenController.dispose();
    super.dispose();
  }

  /// Trả về true nếu ô mật khẩu hiện đang được hiển thị.
  ///
  /// Mật khẩu sẽ hiện khi:
  /// - Người dùng đã bật chế độ hiện bằng cách bấm icon
  /// - Hoặc đang nhấn giữ icon để xem tạm thời
  bool get _dangHienMatKhau => _hienMatKhau || _giuDeHienMatKhau;

  /// Trả về true nếu ô xác nhận mật khẩu hiện đang được hiển thị.
  bool get _dangHienXacNhanMatKhau =>
      _hienXacNhanMatKhau || _giuDeHienXacNhanMatKhau;

  /// Xử lý đăng nhập hoặc đăng ký.
  ///
  /// Quy trình:
  /// - Kiểm tra dữ liệu đầu vào
  /// - Nếu là đăng ký thì kiểm tra xác nhận mật khẩu
  /// - Gọi Supabase thông qua dịch vụ xác thực
  /// - Hiển thị thông báo thành công hoặc lỗi
  Future<void> _xuLyXacThuc() async {
    final email = _emailController.text.trim();
    final matKhau = _matKhauController.text.trim();
    final xacNhanMatKhau = _xacNhanMatKhauController.text.trim();
    final hoTen = _hoTenController.text.trim();

    if (email.isEmpty || matKhau.isEmpty) {
      ThongBao.loi(context, 'Vui lòng nhập đầy đủ email và mật khẩu.');
      return;
    }

    if (!_laDangNhap) {
      if (hoTen.isEmpty) {
        ThongBao.loi(context, 'Vui lòng nhập họ tên.');
        return;
      }

      if (xacNhanMatKhau.isEmpty) {
        ThongBao.loi(context, 'Vui lòng nhập xác nhận mật khẩu.');
        return;
      }

      if (matKhau.length < 6) {
        ThongBao.loi(context, 'Mật khẩu phải có ít nhất 6 ký tự.');
        return;
      }

      if (matKhau != xacNhanMatKhau) {
        ThongBao.loi(context, 'Mật khẩu và xác nhận mật khẩu không khớp.');
        return;
      }
    }

    setState(() => _dangXuLy = true);

    try {
      if (_laDangNhap) {
        await _dichVuXacThuc.dangNhap(email: email, matKhau: matKhau);
      } else {
        await _dichVuXacThuc.dangKy(
          email: email,
          matKhau: matKhau,
          hoTen: hoTen,
          vaiTro: _vaiTro,
        );

        if (!mounted) return;

        ThongBao.thanhCong(
          context,
          'Đăng ký thành công. Nếu Supabase bật xác minh email, hãy kiểm tra hộp thư.',
        );

        setState(() {
          _laDangNhap = true;
          _xacNhanMatKhauController.clear();
          _hienMatKhau = false;
          _hienXacNhanMatKhau = false;
          _giuDeHienMatKhau = false;
          _giuDeHienXacNhanMatKhau = false;
        });
      }
    } catch (loi) {
      if (!mounted) return;
      ThongBao.loi(context, loi);
    } finally {
      if (mounted) {
        setState(() => _dangXuLy = false);
      }
    }
  }

  /// Đổi qua lại giữa chế độ đăng nhập và đăng ký.
  ///
  /// Đồng thời xóa các trạng thái hiển thị mật khẩu tạm thời để tránh rối giao diện.
  void _doiCheDo() {
    setState(() {
      _laDangNhap = !_laDangNhap;
      _hienMatKhau = false;
      _hienXacNhanMatKhau = false;
      _giuDeHienMatKhau = false;
      _giuDeHienXacNhanMatKhau = false;
      _xacNhanMatKhauController.clear();
    });
  }

  /// Tạo ô nhập mật khẩu dùng chung.
  ///
  /// [controller]: bộ điều khiển text
  /// [label]: nhãn hiển thị
  /// [dangHien]: trạng thái đang hiện mật khẩu
  /// [onNhanIcon]: xử lý khi bấm 1 lần vào icon mắt
  /// [onGiuBatDau]: xử lý khi bắt đầu nhấn giữ icon mắt
  /// [onGiuKetThuc]: xử lý khi thả tay khỏi icon mắt
  Widget _taoOInputMatKhau({
    required TextEditingController controller,
    required String label,
    required bool dangHien,
    required VoidCallback onNhanIcon,
    required VoidCallback onGiuBatDau,
    required VoidCallback onGiuKetThuc,
  }) {
    final mau = Theme.of(context).colorScheme;

    return TextField(
      controller: controller,
      obscureText: !dangHien,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: onNhanIcon,
            onLongPressStart: (_) => onGiuBatDau(),
            onLongPressEnd: (_) => onGiuKetThuc(),
            child: Container(
              width: 42,
              height: 42,
              margin: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: dangHien
                    ? mau.primary.withValues(alpha: 0.12)
                    : mau.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                dangHien
                    ? Icons.visibility_rounded
                    : Icons.visibility_off_rounded,
                size: 20,
                color: dangHien ? mau.primary : mau.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mau = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [mau.primaryContainer, mau.surface, mau.secondaryContainer],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 470),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 82,
                        height: 82,
                        decoration: BoxDecoration(
                          color: mau.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Icon(
                          Icons.groups_2_rounded,
                          size: 42,
                          color: mau.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Hệ thống đăng ký nhóm và chọn đề tài',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _laDangNhap
                            ? 'Đăng nhập để sử dụng toàn bộ chức năng đồ án.'
                            : 'Tạo tài khoản mới để bắt đầu sử dụng hệ thống.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: mau.onSurfaceVariant),
                      ),
                      const SizedBox(height: 24),

                      if (!_laDangNhap) ...[
                        TextField(
                          controller: _hoTenController,
                          decoration: const InputDecoration(
                            labelText: 'Họ tên',
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                        ),
                        const SizedBox(height: 14),
                      ],

                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.mail_outline),
                        ),
                      ),
                      const SizedBox(height: 14),

                      _taoOInputMatKhau(
                        controller: _matKhauController,
                        label: 'Mật khẩu',
                        dangHien: _dangHienMatKhau,
                        onNhanIcon: () {
                          setState(() {
                            _hienMatKhau = !_hienMatKhau;
                          });
                        },
                        onGiuBatDau: () {
                          setState(() {
                            _giuDeHienMatKhau = true;
                          });
                        },
                        onGiuKetThuc: () {
                          setState(() {
                            _giuDeHienMatKhau = false;
                          });
                        },
                      ),

                      if (!_laDangNhap) ...[
                        const SizedBox(height: 14),
                        _taoOInputMatKhau(
                          controller: _xacNhanMatKhauController,
                          label: 'Xác nhận mật khẩu',
                          dangHien: _dangHienXacNhanMatKhau,
                          onNhanIcon: () {
                            setState(() {
                              _hienXacNhanMatKhau = !_hienXacNhanMatKhau;
                            });
                          },
                          onGiuBatDau: () {
                            setState(() {
                              _giuDeHienXacNhanMatKhau = true;
                            });
                          },
                          onGiuKetThuc: () {
                            setState(() {
                              _giuDeHienXacNhanMatKhau = false;
                            });
                          },
                        ),
                        const SizedBox(height: 14),
                        DropdownButtonFormField<String>(
                          value: _vaiTro,
                          items: const [
                            DropdownMenuItem(
                              value: 'sinh_vien',
                              child: Text('Sinh viên'),
                            ),
                            DropdownMenuItem(
                              value: 'giang_vien',
                              child: Text('Giảng viên'),
                            ),
                            DropdownMenuItem(
                              value: 'quan_tri_vien',
                              child: Text('Quản trị viên'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _vaiTro = value);
                            }
                          },
                          decoration: const InputDecoration(
                            labelText: 'Vai trò',
                            prefixIcon: Icon(Icons.badge_outlined),
                          ),
                        ),
                      ],

                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _dangXuLy ? null : _xuLyXacThuc,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: _dangXuLy
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.8,
                                    ),
                                  )
                                : Text(_laDangNhap ? 'Đăng nhập' : 'Đăng ký'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      TextButton(
                        onPressed: _dangXuLy ? null : _doiCheDo,
                        child: Text(
                          _laDangNhap
                              ? 'Chưa có tài khoản? Đăng ký ngay'
                              : 'Đã có tài khoản? Quay về đăng nhập',
                        ),
                      ),

                      if (!_laDangNhap) ...[
                        const SizedBox(height: 6),
                        Text(
                          'Mẹo: chạm icon mắt để bật/tắt, nhấn giữ để xem tạm thời.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: mau.onSurfaceVariant),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
