import 'package:flutter/material.dart';

import '../../dich_vu/dich_vu_du_lieu.dart';
import '../../mo_hinh/ho_so_nguoi_dung.dart';
import 'trang_quan_ly_co_ban.dart';

/// Trang quản lý nhóm đồ án.
class TrangNhomDoAn extends StatelessWidget {
  TrangNhomDoAn({
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

  /// Tải danh sách hồ sơ dùng cho các trường người tạo / người duyệt.
  Future<List<LuaChonMuc>> _taiNguoiDung() async {
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
      tieuDe: 'Quản lý nhóm đồ án',
      moTa:
          'Sinh viên có thể tạo nhóm; giảng viên và quản trị viên có thể duyệt hoặc khoá nhóm.',
      bang: 'nhom_do_an',
      hoSo: hoSo,
      selectClause:
          '*, lop:lop_do_an_id(ma_lop, ten_lop), nguoi_tao:tao_boi(ho_ten), nguoi_duyet:duyet_boi(ho_ten)',
      sapXepTheo: 'tao_luc',
      danhSachCot: const [
        CotBang(tenTruong: 'ten_nhom', nhan: 'Tên nhóm'),
        CotBang(tenTruong: 'lop.ma_lop', nhan: 'Lớp'),
        CotBang(tenTruong: 'nguoi_tao.ho_ten', nhan: 'Tạo bởi'),
        CotBang(tenTruong: 'trang_thai', nhan: 'Trạng thái'),
        CotBang(tenTruong: 'duyet_luc', nhan: 'Duyệt lúc'),
      ],
      danhSachTruong: [
        TruongBieuMau(
          tenTruong: 'lop_do_an_id',
          nhan: 'Lớp đồ án',
          kieu: KieuTruong.luaChon,
          batBuoc: true,
          taiLuaChon: _taiLopDoAn,
        ),
        const TruongBieuMau(
          tenTruong: 'ten_nhom',
          nhan: 'Tên nhóm',
          kieu: KieuTruong.vanBan,
          batBuoc: true,
        ),
        const TruongBieuMau(
          tenTruong: 'mo_ta',
          nhan: 'Mô tả',
          kieu: KieuTruong.vanBanNhieuDong,
        ),
        TruongBieuMau(
          tenTruong: 'tao_boi',
          nhan: 'Tạo bởi',
          kieu: KieuTruong.luaChon,
          batBuoc: true,
          taiLuaChon: _taiNguoiDung,
        ),
        const TruongBieuMau(
          tenTruong: 'trang_thai',
          nhan: 'Trạng thái',
          kieu: KieuTruong.luaChon,
          batBuoc: true,
          giaTriMacDinh: 'dang_tao',
          luaChonTinh: [
            LuaChonMuc(giaTri: 'dang_tao', nhan: 'Đang tạo'),
            LuaChonMuc(giaTri: 'cho_duyet', nhan: 'Chờ duyệt'),
            LuaChonMuc(giaTri: 'da_duyet', nhan: 'Đã duyệt'),
            LuaChonMuc(giaTri: 'da_khoa', nhan: 'Đã khoá'),
            LuaChonMuc(giaTri: 'da_huy', nhan: 'Đã huỷ'),
          ],
        ),
        TruongBieuMau(
          tenTruong: 'duyet_boi',
          nhan: 'Duyệt bởi',
          kieu: KieuTruong.luaChon,
          taiLuaChon: _taiNguoiDung,
        ),
        const TruongBieuMau(
          tenTruong: 'duyet_luc',
          nhan: 'Duyệt lúc',
          kieu: KieuTruong.ngayGio,
        ),
        const TruongBieuMau(
          tenTruong: 'khoa_luc',
          nhan: 'Khoá lúc',
          kieu: KieuTruong.ngayGio,
        ),
      ],
      hamXuLyTruocKhiLuu: (duLieuMoi, duLieuCu) async {
        if (duLieuCu == null && hoSo.laSinhVien) {
          final taoBoi = duLieuMoi['tao_boi'];
          if (taoBoi == null || taoBoi.toString().isEmpty) {
            throw Exception(
              'Khi tạo nhóm, sinh viên phải chọn đúng tài khoản tạo nhóm hiện tại.',
            );
          }
        }
        return duLieuMoi;
      },
    );
  }
}
