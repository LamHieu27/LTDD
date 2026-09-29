import 'package:flutter/material.dart';

import '../../mo_hinh/ho_so_nguoi_dung.dart';
import 'trang_quan_ly_co_ban.dart';

/// Trang quản lý học kỳ dành cho quản trị viên.
class TrangHocKy extends StatelessWidget {
  const TrangHocKy({
    super.key,
    required this.hoSo,
  });

  final HoSoNguoiDung hoSo;

  @override
  Widget build(BuildContext context) {
    return TrangQuanLyCoBan(
      tieuDe: 'Quản lý học kỳ',
      moTa: 'Tạo mới, cập nhật và theo dõi các học kỳ trong hệ thống.',
      bang: 'hoc_ky',
      hoSo: hoSo,
      sapXepTheo: 'ngay_bat_dau',
      danhSachCot: const [
        CotBang(tenTruong: 'ma_hoc_ky', nhan: 'Mã học kỳ'),
        CotBang(tenTruong: 'ten_hoc_ky', nhan: 'Tên học kỳ'),
        CotBang(tenTruong: 'ngay_bat_dau', nhan: 'Ngày bắt đầu'),
        CotBang(tenTruong: 'ngay_ket_thuc', nhan: 'Ngày kết thúc'),
        CotBang(
          tenTruong: 'dang_hoat_dong',
          nhan: 'Đang hoạt động',
          canGiua: true,
        ),
      ],
      danhSachTruong: const [
        TruongBieuMau(
          tenTruong: 'ma_hoc_ky',
          nhan: 'Mã học kỳ',
          kieu: KieuTruong.vanBan,
          batBuoc: true,
        ),
        TruongBieuMau(
          tenTruong: 'ten_hoc_ky',
          nhan: 'Tên học kỳ',
          kieu: KieuTruong.vanBan,
          batBuoc: true,
        ),
        TruongBieuMau(
          tenTruong: 'ngay_bat_dau',
          nhan: 'Ngày bắt đầu',
          kieu: KieuTruong.ngay,
          batBuoc: true,
        ),
        TruongBieuMau(
          tenTruong: 'ngay_ket_thuc',
          nhan: 'Ngày kết thúc',
          kieu: KieuTruong.ngay,
          batBuoc: true,
        ),
        TruongBieuMau(
          tenTruong: 'dang_hoat_dong',
          nhan: 'Đang hoạt động',
          kieu: KieuTruong.boolean,
          giaTriMacDinh: false,
        ),
      ],
    );
  }
}
