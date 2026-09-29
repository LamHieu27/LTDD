import 'package:supabase_flutter/supabase_flutter.dart';

import '../mo_hinh/ho_so_nguoi_dung.dart';
import 'dich_vu_nhat_ky.dart';

/// Dịch vụ xử lý hồ sơ người dùng.
class DichVuHoSo {
  final SupabaseClient _client = Supabase.instance.client;
  final DichVuNhatKy _dichVuNhatKy = DichVuNhatKy();

  /// Lấy hồ sơ của người dùng đang đăng nhập.
  Future<HoSoNguoiDung?> layHoSoHienTai() async {
    final nguoiDung = _client.auth.currentUser;
    if (nguoiDung == null) return null;

    final duLieu = await _client
        .from('ho_so')
        .select()
        .eq('id', nguoiDung.id)
        .maybeSingle();

    if (duLieu == null) return null;
    return HoSoNguoiDung.tuMap(Map<String, dynamic>.from(duLieu));
  }

  /// Cập nhật hồ sơ cá nhân của người dùng đang đăng nhập.
  Future<void> capNhatHoSo(Map<String, dynamic> duLieuCapNhat) async {
    final nguoiDung = _client.auth.currentUser;
    if (nguoiDung == null) {
      throw Exception('Chưa đăng nhập.');
    }

    await _client.from('ho_so').update(duLieuCapNhat).eq('id', nguoiDung.id);

    await _dichVuNhatKy.ghiNhatKy(
      hanhDong: 'Cập nhật hồ sơ',
      loaiDoiTuong: 'ho_so',
      doiTuongId: nguoiDung.id,
      duLieu: duLieuCapNhat,
    );
  }
}
