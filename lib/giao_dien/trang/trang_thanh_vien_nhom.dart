import 'package:flutter/material.dart';

import '../../dich_vu/dich_vu_du_lieu.dart';
import '../../mo_hinh/ho_so_nguoi_dung.dart';
import 'trang_quan_ly_co_ban.dart';

/// Trang quản lý thành viên của từng nhóm.
class TrangThanhVienNhom extends StatelessWidget {
  TrangThanhVienNhom({
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
        .map((e) => LuaChonMuc(giaTri: e['id'], nhan: '${e['ma_lop']} - ${e['ten_lop']}'))
        .toList();
  }

  /// Tải danh sách nhóm.
  Future<List<LuaChonMuc>> _taiNhom() async {
    final duLieu = await _dichVuDuLieu.layDanhSach(
      bang: 'nhom_do_an',
      sapXepTheo: 'ten_nhom',
    );

    return duLieu
        .map((e) => LuaChonMuc(giaTri: e['id'], nhan: e['ten_nhom'].toString()))
        .toList();
  }

  /// Tải danh sách sinh viên.
  Future<List<LuaChonMuc>> _taiSinhVien() async {
    final duLieu = await _dichVuDuLieu.layDanhSach(
      bang: 'ho_so',
      boLoc: {'vai_tro': 'sinh_vien'},
      sapXepTheo: 'ho_ten',
    );

    return duLieu
        .map((e) => LuaChonMuc(giaTri: e['id'], nhan: e['ho_ten'].toString()))
        .toList();
  }

  /// Tải danh sách người mời.
  Future<List<LuaChonMuc>> _taiNguoiMoi() async {
    final duLieu = await _dichVuDuLieu.layDanhSach(
      bang: 'ho_so',
      sapXepTheo: 'ho_ten',
    );

    return duLieu
        .map((e) => LuaChonMuc(giaTri: e['id'], nhan: e['ho_ten'].toString()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return TrangQuanLyCoBan(
      tieuDe: 'Thành viên nhóm',
      moTa:
          'Quản lý danh sách thành viên, vai trò nhóm trưởng và trạng thái tham gia trong từng nhóm đồ án.',
      bang: 'thanh_vien_nhom',
      hoSo: hoSo,
      selectClause:
          '*, lop:lop_do_an_id(ma_lop), nhom:nhom_id(ten_nhom), sinh_vien:sinh_vien_id(ho_ten), nguoi_moi:moi_boi(ho_ten)',
      sapXepTheo: 'tham_gia_luc',
      danhSachCot: const [
        CotBang(tenTruong: 'lop.ma_lop', nhan: 'Lớp'),
        CotBang(tenTruong: 'nhom.ten_nhom', nhan: 'Nhóm'),
        CotBang(tenTruong: 'sinh_vien.ho_ten', nhan: 'Sinh viên'),
        CotBang(tenTruong: 'vai_tro', nhan: 'Vai trò'),
        CotBang(tenTruong: 'trang_thai', nhan: 'Trạng thái'),
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
          taiLuaChon: _taiNhom,
        ),
        TruongBieuMau(
          tenTruong: 'sinh_vien_id',
          nhan: 'Sinh viên',
          kieu: KieuTruong.luaChon,
          batBuoc: true,
          taiLuaChon: _taiSinhVien,
        ),
        const TruongBieuMau(
          tenTruong: 'vai_tro',
          nhan: 'Vai trò',
          kieu: KieuTruong.luaChon,
          batBuoc: true,
          giaTriMacDinh: 'thanh_vien',
          luaChonTinh: [
            LuaChonMuc(giaTri: 'nhom_truong', nhan: 'Nhóm trưởng'),
            LuaChonMuc(giaTri: 'thanh_vien', nhan: 'Thành viên'),
          ],
        ),
        const TruongBieuMau(
          tenTruong: 'trang_thai',
          nhan: 'Trạng thái thành viên',
          kieu: KieuTruong.luaChon,
          batBuoc: true,
          giaTriMacDinh: 'da_chap_nhan',
          luaChonTinh: [
            LuaChonMuc(giaTri: 'cho_duyet', nhan: 'Chờ duyệt'),
            LuaChonMuc(giaTri: 'da_chap_nhan', nhan: 'Đã chấp nhận'),
            LuaChonMuc(giaTri: 'tu_choi', nhan: 'Từ chối'),
            LuaChonMuc(giaTri: 'da_roi', nhan: 'Đã rời'),
            LuaChonMuc(giaTri: 'bi_xoa', nhan: 'Bị xoá'),
          ],
        ),
        const TruongBieuMau(
          tenTruong: 'tham_gia_luc',
          nhan: 'Tham gia lúc',
          kieu: KieuTruong.ngayGio,
        ),
        TruongBieuMau(
          tenTruong: 'moi_boi',
          nhan: 'Mời bởi',
          kieu: KieuTruong.luaChon,
          taiLuaChon: _taiNguoiMoi,
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
