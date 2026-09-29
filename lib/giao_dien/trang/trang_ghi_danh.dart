import 'package:flutter/material.dart';

import '../../dich_vu/dich_vu_du_lieu.dart';
import '../../mo_hinh/ho_so_nguoi_dung.dart';
import 'trang_quan_ly_co_ban.dart';

/// Trang quản lý ghi danh sinh viên vào lớp đồ án.
class TrangGhiDanh extends StatelessWidget {
  TrangGhiDanh({
    super.key,
    required this.hoSo,
  });

  final HoSoNguoiDung hoSo;
  final DichVuDuLieu _dichVuDuLieu = DichVuDuLieu();

  /// Tải danh sách lớp đồ án cho combobox.
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

  /// Tải danh sách sinh viên cho combobox.
  Future<List<LuaChonMuc>> _taiSinhVien() async {
    final duLieu = await _dichVuDuLieu.layDanhSach(
      bang: 'ho_so',
      boLoc: {'vai_tro': 'sinh_vien'},
      sapXepTheo: 'ho_ten',
    );

    return duLieu
        .map(
          (e) => LuaChonMuc(
            giaTri: e['id'],
            nhan: '${e['ho_ten']} (${e['ma_sinh_vien'] ?? 'Chưa có MSSV'})',
          ),
        )
        .toList();
  }

  /// Tải danh sách người duyệt để chọn nhanh.
  Future<List<LuaChonMuc>> _taiNguoiDuyet() async {
    final duLieu = await _dichVuDuLieu.layDanhSach(
      bang: 'ho_so',
      sapXepTheo: 'ho_ten',
    );

    return duLieu
        .map(
          (e) => LuaChonMuc(
            giaTri: e['id'],
            nhan: e['ho_ten'].toString(),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return TrangQuanLyCoBan(
      tieuDe: 'Quản lý ghi danh',
      moTa: 'Ghi danh sinh viên vào lớp đồ án và cập nhật trạng thái duyệt.',
      bang: 'ghi_danh',
      hoSo: hoSo,
      selectClause:
          '*, lop:lop_do_an_id(ma_lop, ten_lop), sinh_vien:sinh_vien_id(ho_ten, ma_sinh_vien), nguoi_duyet:duyet_boi(ho_ten)',
      sapXepTheo: 'ghi_danh_luc',
      danhSachCot: const [
        CotBang(tenTruong: 'lop.ma_lop', nhan: 'Mã lớp'),
        CotBang(tenTruong: 'lop.ten_lop', nhan: 'Tên lớp'),
        CotBang(tenTruong: 'sinh_vien.ho_ten', nhan: 'Sinh viên'),
        CotBang(tenTruong: 'trang_thai', nhan: 'Trạng thái'),
        CotBang(tenTruong: 'ghi_danh_luc', nhan: 'Ghi danh lúc'),
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
          tenTruong: 'sinh_vien_id',
          nhan: 'Sinh viên',
          kieu: KieuTruong.luaChon,
          batBuoc: true,
          taiLuaChon: _taiSinhVien,
        ),
        const TruongBieuMau(
          tenTruong: 'trang_thai',
          nhan: 'Trạng thái',
          kieu: KieuTruong.luaChon,
          batBuoc: true,
          giaTriMacDinh: 'da_duyet',
          luaChonTinh: [
            LuaChonMuc(giaTri: 'cho_duyet', nhan: 'Chờ duyệt'),
            LuaChonMuc(giaTri: 'da_duyet', nhan: 'Đã duyệt'),
            LuaChonMuc(giaTri: 'tu_choi', nhan: 'Từ chối'),
            LuaChonMuc(giaTri: 'huy', nhan: 'Huỷ'),
          ],
        ),
        const TruongBieuMau(
          tenTruong: 'ghi_danh_luc',
          nhan: 'Ghi danh lúc',
          kieu: KieuTruong.ngayGio,
        ),
        TruongBieuMau(
          tenTruong: 'duyet_boi',
          nhan: 'Duyệt bởi',
          kieu: KieuTruong.luaChon,
          taiLuaChon: _taiNguoiDuyet,
        ),
        const TruongBieuMau(
          tenTruong: 'duyet_luc',
          nhan: 'Duyệt lúc',
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
