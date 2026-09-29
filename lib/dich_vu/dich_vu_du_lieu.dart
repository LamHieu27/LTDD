import 'dart:async';
import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'dich_vu_nhat_ky.dart';

/// Dịch vụ CRUD dùng chung cho hầu hết các bảng trong hệ thống.
class DichVuDuLieu {
  final SupabaseClient _client = Supabase.instance.client;
  final DichVuNhatKy _dichVuNhatKy = DichVuNhatKy();

  /// Lấy danh sách bản ghi từ một bảng.
  ///
  /// Có thể truyền thêm `selectClause`, `boLoc`, `sapXepTheo` để tái sử dụng
  /// cho nhiều màn hình khác nhau.
  Future<List<Map<String, dynamic>>> layDanhSach({
    required String bang,
    String selectClause = '*',
    Map<String, dynamic>? boLoc,
    String? sapXepTheo,
    bool tangDan = true,
    int? gioiHan,
  }) async {
    dynamic truyVan = _client.from(bang).select(selectClause);

    if (boLoc != null) {
      for (final entry in boLoc.entries) {
        truyVan = truyVan.eq(entry.key, entry.value);
      }
    }

    if (sapXepTheo != null && sapXepTheo.isNotEmpty) {
      truyVan = truyVan.order(sapXepTheo, ascending: tangDan);
    }

    if (gioiHan != null) {
      truyVan = truyVan.limit(gioiHan);
    }

    final duLieu = await truyVan;
    return List<Map<String, dynamic>>.from(duLieu as List);
  }

  /// Lấy chi tiết một bản ghi theo khoá chính.
  Future<Map<String, dynamic>?> layTheoId({
    required String bang,
    required Object id,
    String khoaChinh = 'id',
    String selectClause = '*',
  }) async {
    final duLieu = await _client
        .from(bang)
        .select(selectClause)
        .eq(khoaChinh, id)
        .maybeSingle();

    if (duLieu == null) return null;
    return Map<String, dynamic>.from(duLieu);
  }

  /// Thêm một bản ghi mới.
  ///
  /// Hàm sẽ tự ghi log vào bảng `nhat_ky_he_thong`.
  Future<Map<String, dynamic>> themBanGhi({
    required String bang,
    required Map<String, dynamic> duLieu,
    String khoaChinh = 'id',
    bool ghiNhatKy = true,
  }) async {
    final ketQua = await _client.from(bang).insert(duLieu).select().single();
    final banGhi = Map<String, dynamic>.from(ketQua);

    if (ghiNhatKy) {
      await _dichVuNhatKy.ghiNhatKy(
        hanhDong: 'Thêm dữ liệu',
        loaiDoiTuong: bang,
        doiTuongId: banGhi[khoaChinh],
        duLieu: duLieu,
      );
    }

    return banGhi;
  }

  /// Cập nhật một bản ghi hiện có.
  Future<void> capNhatBanGhi({
    required String bang,
    required Object id,
    required Map<String, dynamic> duLieu,
    String khoaChinh = 'id',
    bool ghiNhatKy = true,
  }) async {
    await _client.from(bang).update(duLieu).eq(khoaChinh, id);

    if (ghiNhatKy) {
      await _dichVuNhatKy.ghiNhatKy(
        hanhDong: 'Cập nhật dữ liệu',
        loaiDoiTuong: bang,
        doiTuongId: id,
        duLieu: duLieu,
      );
    }
  }

  /// Xoá một bản ghi khỏi bảng.
  Future<void> xoaBanGhi({
    required String bang,
    required Object id,
    String khoaChinh = 'id',
    bool ghiNhatKy = true,
  }) async {
    await _client.from(bang).delete().eq(khoaChinh, id);

    if (ghiNhatKy) {
      await _dichVuNhatKy.ghiNhatKy(
        hanhDong: 'Xoá dữ liệu',
        loaiDoiTuong: bang,
        doiTuongId: id,
        duLieu: {'khoa_chinh': khoaChinh},
      );
    }
  }

  /// Lấy tổng số bản ghi của một bảng dựa trên tập dữ liệu được phép theo RLS.
  Future<int> demSoLuong({
    required String bang,
    Map<String, dynamic>? boLoc,
  }) async {
    final duLieu = await layDanhSach(
      bang: bang,
      boLoc: boLoc,
    );
    return duLieu.length;
  }

  /// Tìm kiếm cục bộ trong một danh sách bản ghi.
  ///
  /// Hàm này giúp giảm số lần gọi mạng khi người dùng chỉ lọc theo từ khoá.
  List<Map<String, dynamic>> timKiemCucBo(
    List<Map<String, dynamic>> duLieu,
    String tuKhoa,
  ) {
    if (tuKhoa.trim().isEmpty) return duLieu;

    final chuanHoa = tuKhoa.toLowerCase().trim();
    return duLieu.where((banGhi) {
      return jsonEncode(banGhi).toLowerCase().contains(chuanHoa);
    }).toList();
  }
}
