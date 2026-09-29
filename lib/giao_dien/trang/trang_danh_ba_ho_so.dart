import 'package:flutter/material.dart';

import '../../mo_hinh/ho_so_nguoi_dung.dart';
import 'trang_quan_ly_co_ban.dart';

/// Trang danh bạ hồ sơ để quản trị viên rà soát người dùng.
class TrangDanhBaHoSo extends StatelessWidget {
  const TrangDanhBaHoSo({
    super.key,
    required this.hoSo,
  });

  final HoSoNguoiDung hoSo;

  @override
  Widget build(BuildContext context) {
    return TrangQuanLyCoBan(
      tieuDe: 'Danh bạ hồ sơ',
      moTa:
          'Quản trị viên có thể tra cứu và cập nhật nhanh thông tin hồ sơ người dùng trong hệ thống.',
      bang: 'ho_so',
      hoSo: hoSo,
      duocThem: false,
      duocXoa: false,
      sapXepTheo: 'ho_ten',
      danhSachCot: const [
        CotBang(tenTruong: 'ho_ten', nhan: 'Họ tên'),
        CotBang(tenTruong: 'email', nhan: 'Email'),
        CotBang(tenTruong: 'vai_tro', nhan: 'Vai trò'),
        CotBang(tenTruong: 'ma_sinh_vien', nhan: 'Mã sinh viên'),
        CotBang(tenTruong: 'ma_giang_vien', nhan: 'Mã giảng viên'),
        CotBang(tenTruong: 'dang_hoat_dong', nhan: 'Hoạt động'),
      ],
      danhSachTruong: const [
        TruongBieuMau(
          tenTruong: 'ho_ten',
          nhan: 'Họ tên',
          kieu: KieuTruong.vanBan,
          batBuoc: true,
        ),
        TruongBieuMau(
          tenTruong: 'vai_tro',
          nhan: 'Vai trò',
          kieu: KieuTruong.luaChon,
          batBuoc: true,
          luaChonTinh: [
            LuaChonMuc(giaTri: 'sinh_vien', nhan: 'Sinh viên'),
            LuaChonMuc(giaTri: 'giang_vien', nhan: 'Giảng viên'),
            LuaChonMuc(giaTri: 'quan_tri_vien', nhan: 'Quản trị viên'),
          ],
        ),
        TruongBieuMau(
          tenTruong: 'ma_sinh_vien',
          nhan: 'Mã sinh viên',
          kieu: KieuTruong.vanBan,
        ),
        TruongBieuMau(
          tenTruong: 'ma_giang_vien',
          nhan: 'Mã giảng viên',
          kieu: KieuTruong.vanBan,
        ),
        TruongBieuMau(
          tenTruong: 'lop_hanh_chinh',
          nhan: 'Lớp hành chính',
          kieu: KieuTruong.vanBan,
        ),
        TruongBieuMau(
          tenTruong: 'khoa',
          nhan: 'Khoa',
          kieu: KieuTruong.vanBan,
        ),
        TruongBieuMau(
          tenTruong: 'nganh',
          nhan: 'Ngành',
          kieu: KieuTruong.vanBan,
        ),
        TruongBieuMau(
          tenTruong: 'so_dien_thoai',
          nhan: 'Số điện thoại',
          kieu: KieuTruong.vanBan,
        ),
        TruongBieuMau(
          tenTruong: 'anh_dai_dien_url',
          nhan: 'URL ảnh đại diện',
          kieu: KieuTruong.vanBan,
        ),
        TruongBieuMau(
          tenTruong: 'dang_hoat_dong',
          nhan: 'Đang hoạt động',
          kieu: KieuTruong.boolean,
          giaTriMacDinh: true,
        ),
      ],
    );
  }
}
