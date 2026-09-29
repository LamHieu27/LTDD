import 'package:flutter/material.dart';

import '../../mo_hinh/ho_so_nguoi_dung.dart';
import 'trang_quan_ly_co_ban.dart';

/// Trang quản lý môn học dành cho quản trị viên.
class TrangMonHoc extends StatelessWidget {
  const TrangMonHoc({
    super.key,
    required this.hoSo,
  });

  final HoSoNguoiDung hoSo;

  @override
  Widget build(BuildContext context) {
    return TrangQuanLyCoBan(
      tieuDe: 'Quản lý môn học',
      moTa: 'Quản lý danh mục môn học phục vụ mở lớp đồ án.',
      bang: 'mon_hoc',
      hoSo: hoSo,
      sapXepTheo: 'ma_mon_hoc',
      danhSachCot: const [
        CotBang(tenTruong: 'ma_mon_hoc', nhan: 'Mã môn học'),
        CotBang(tenTruong: 'ten_mon_hoc', nhan: 'Tên môn học'),
        CotBang(tenTruong: 'so_tin_chi', nhan: 'Số tín chỉ', canGiua: true),
        CotBang(tenTruong: 'khoa', nhan: 'Khoa'),
        CotBang(
          tenTruong: 'dang_hoat_dong',
          nhan: 'Đang hoạt động',
          canGiua: true,
        ),
      ],
      danhSachTruong: const [
        TruongBieuMau(
          tenTruong: 'ma_mon_hoc',
          nhan: 'Mã môn học',
          kieu: KieuTruong.vanBan,
          batBuoc: true,
        ),
        TruongBieuMau(
          tenTruong: 'ten_mon_hoc',
          nhan: 'Tên môn học',
          kieu: KieuTruong.vanBan,
          batBuoc: true,
        ),
        TruongBieuMau(
          tenTruong: 'so_tin_chi',
          nhan: 'Số tín chỉ',
          kieu: KieuTruong.soNguyen,
          batBuoc: true,
        ),
        TruongBieuMau(
          tenTruong: 'khoa',
          nhan: 'Khoa',
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
