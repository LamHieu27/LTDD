import 'package:flutter/material.dart';

import '../../dich_vu/dich_vu_du_lieu.dart';
import '../../mo_hinh/ho_so_nguoi_dung.dart';
import 'trang_quan_ly_co_ban.dart';

/// Trang quản lý phân công đề tài cho nhóm.
class TrangPhanCongDeTai extends StatelessWidget {
  TrangPhanCongDeTai({
    super.key,
    required this.hoSo,
  });

  final HoSoNguoiDung hoSo;
  final DichVuDuLieu _dichVuDuLieu = DichVuDuLieu();

  /// Tải danh sách lớp đồ án.
  Future<List<LuaChonMuc>> _taiLopDoAn() async {
    final duLieu = await _dichVuDuLieu.layDanhSach(
      bang: 'lop_do_an',
      sapXepTheo: 'ma_lop',
    );

    return duLieu
        .map(
          (e) => LuaChonMuc(
            giaTri: e['id'],
            nhan: '${e['ma_lop']} - ${e['ten_lop']}',
          ),
        )
        .toList();
  }

  /// Tải danh sách nhóm đồ án.
  Future<List<LuaChonMuc>> _taiNhomDoAn() async {
    final duLieu = await _dichVuDuLieu.layDanhSach(
      bang: 'nhom_do_an',
      sapXepTheo: 'ten_nhom',
    );

    return duLieu
        .map(
          (e) => LuaChonMuc(giaTri: e['id'], nhan: e['ten_nhom'].toString()))
        .toList();
  }

  /// Tải danh sách đề tài.
  Future<List<LuaChonMuc>> _taiDeTai() async {
    final duLieu = await _dichVuDuLieu.layDanhSach(
      bang: 'de_tai',
      sapXepTheo: 'ma_de_tai',
    );

    return duLieu
        .map(
          (e) => LuaChonMuc(
            giaTri: e['id'],
            nhan: '${e['ma_de_tai']} - ${e['ten_de_tai']}',
          ),
        )
        .toList();
  }

  /// Tải danh sách người phân công.
  Future<List<LuaChonMuc>> _taiNguoiPhanCong() async {
    final duLieu = await _dichVuDuLieu.layDanhSach(
      bang: 'ho_so',
      sapXepTheo: 'ho_ten',
    );

    return duLieu
        .map(
          (e) => LuaChonMuc(giaTri: e['id'], nhan: e['ho_ten'].toString()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return TrangQuanLyCoBan(
      tieuDe: 'Phân công đề tài',
      moTa:
          'Giảng viên hoặc quản trị viên gán đề tài cho nhóm sau khi xem nguyện vọng.',
      bang: 'phan_cong_de_tai',
      hoSo: hoSo,
      selectClause:
          '*, lop:lop_do_an_id(ma_lop), nhom:nhom_id(ten_nhom), de_tai:de_tai_id(ma_de_tai, ten_de_tai), nguoi_phan_cong:phan_cong_boi(ho_ten)',
      sapXepTheo: 'phan_cong_luc',
      danhSachCot: const [
        CotBang(tenTruong: 'lop.ma_lop', nhan: 'Lớp'),
        CotBang(tenTruong: 'nhom.ten_nhom', nhan: 'Nhóm'),
        CotBang(tenTruong: 'de_tai.ma_de_tai', nhan: 'Mã đề tài'),
        CotBang(tenTruong: 'de_tai.ten_de_tai', nhan: 'Tên đề tài'),
        CotBang(tenTruong: 'phan_cong_luc', nhan: 'Phân công lúc'),
      ],
      danhSachTruong: [
        TruongBieuMau(
          tenTruong: 'lop_do_an_id',
          nhan: 'Lớp đồ án',
          kieu: KieuTruong.luaChon,
          batBuoc: true,
          taiLuaChon: _taiLopDoAn,
        ),
        TruongBieuMau(
          tenTruong: 'nhom_id',
          nhan: 'Nhóm đồ án',
          kieu: KieuTruong.luaChon,
          batBuoc: true,
          taiLuaChon: _taiNhomDoAn,
        ),
        TruongBieuMau(
          tenTruong: 'de_tai_id',
          nhan: 'Đề tài',
          kieu: KieuTruong.luaChon,
          batBuoc: true,
          taiLuaChon: _taiDeTai,
        ),
        TruongBieuMau(
          tenTruong: 'phan_cong_boi',
          nhan: 'Phân công bởi',
          kieu: KieuTruong.luaChon,
          batBuoc: true,
          taiLuaChon: _taiNguoiPhanCong,
        ),
        const TruongBieuMau(
          tenTruong: 'phan_cong_luc',
          nhan: 'Phân công lúc',
          kieu: KieuTruong.ngayGio,
        ),
        const TruongBieuMau(
          tenTruong: 'ghi_chu',
          nhan: 'Ghi chú',
          kieu: KieuTruong.vanBanNhieuDong,
        ),
      ],
    );
  }
}
