import 'package:supabase_flutter/supabase_flutter.dart';

/// Dịch vụ xác thực cho đăng nhập, đăng ký và đăng xuất.
class DichVuXacThuc {
  final SupabaseClient _client = Supabase.instance.client;

  /// Trả về phiên đăng nhập hiện tại.
  Session? get phienHienTai => _client.auth.currentSession;

  /// Trả về luồng thay đổi trạng thái đăng nhập.
  Stream<AuthState> get thayDoiXacThuc => _client.auth.onAuthStateChange;

  /// Đăng nhập bằng email và mật khẩu.
  Future<void> dangNhap({
    required String email,
    required String matKhau,
  }) async {
    await _client.auth.signInWithPassword(
      email: email.trim(),
      password: matKhau,
    );
  }

  /// Đăng ký tài khoản mới.
  ///
  /// Metadata `full_name` và `role` sẽ được trigger trong Supabase
  /// sử dụng để tự tạo hồ sơ ở bảng `ho_so`.
  Future<void> dangKy({
    required String email,
    required String matKhau,
    required String hoTen,
    required String vaiTro,
  }) async {
    await _client.auth.signUp(
      email: email.trim(),
      password: matKhau,
      data: {
        'full_name': hoTen.trim(),
        'role': vaiTro,
      },
    );
  }

  /// Đăng xuất khỏi hệ thống.
  Future<void> dangXuat() async {
    await _client.auth.signOut();
  }
}
