import 'package:flutter/material.dart';

import '../../dich_vu/dich_vu_du_lieu.dart';
import '../../mo_hinh/ho_so_nguoi_dung.dart';
import 'trang_quan_ly_co_ban.dart';

/// Trang quản lý lớp đồ án.
class TrangLopDoAn extends StatelessWidget {
  TrangLopDoAn({
    super.key,
    required this.hoSo,
  });

  final HoSoNguoiDung hoSo;
  final DichVuDuLieu _dichVuDuLieu = DichVuDuLieu();

  /// Tải danh sách học kỳ cho combobox.
  Future<List<LuaChonMuc>> _taiHocKy() async {
    final duLieu = await _dichVuDuLieu.layDanhSach(
      bang: 'hoc_ky',
      sapXepTheo: 'ngay_bat_dau',
    );

    return duLieu
        .map(
          (e) => LuaChonMuc(
            giaTri: e['id'],
            nhan: '${e['ma_hoc_ky']} - ${e['ten_hoc_ky']}',
          ),
        )
        .toList();
  }

  /// Tải danh sách môn học cho combobox.
  Future<List<LuaChonMuc>> _taiMonHoc() async {
    final duLieu = await _dichVuDuLieu.layDanhSach(
      bang: 'mon_hoc',
      sapXepTheo: 'ma_mon_hoc',
    );

    return duLieu
        .map(
          (e) => LuaChonMuc(
            giaTri: e['id'],
            nhan: '${e['ma_mon_hoc']} - ${e['ten_mon_hoc']}',
          ),
        )
        .toList();
  }

  /// Tải danh sách giảng viên cho combobox.
  Future<List<LuaChonMuc>> _taiGiangVien() async {
    final duLieu = await _dichVuDuLieu.layDanhSach(
      bang: 'ho_so',
      boLoc: {'vai_tro': 'giang_vien'},
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
      tieuDe: 'Quản lý lớp đồ án',
      moTa:
          'Mở lớp theo học kỳ, gắn môn học, giảng viên và thời điểm đăng ký/chọn đề tài.',
      bang: 'lop_do_an',
      hoSo: hoSo,
      selectClause:
          '*, hoc_ky:hoc_ky_id(ten_hoc_ky), mon_hoc:mon_hoc_id(ten_mon_hoc), giang_vien:giang_vien_id(ho_ten)',
      sapXepTheo: 'tao_luc',
      danhSachCot: const [
        CotBang(tenTruong: 'ma_lop', nhan: 'Mã lớp'),
        CotBang(tenTruong: 'ten_lop', nhan: 'Tên lớp'),
        CotBang(tenTruong: 'hoc_ky.ten_hoc_ky', nhan: 'Học kỳ'),
        CotBang(tenTruong: 'mon_hoc.ten_mon_hoc', nhan: 'Môn học'),
        CotBang(tenTruong: 'giang_vien.ho_ten', nhan: 'Giảng viên'),
        CotBang(tenTruong: 'trang_thai', nhan: 'Trạng thái'),
      ],
      danhSachTruong: [
        TruongBieuMau(
          tenTruong: 'hoc_ky_id',
          nhan: 'Học kỳ',
          kieu: KieuTruong.luaChon,
          batBuoc: true,
          taiLuaChon: _taiHocKy,
        ),
        TruongBieuMau(
          tenTruong: 'mon_hoc_id',
          nhan: 'Môn học',
          kieu: KieuTruong.luaChon,
          batBuoc: true,
          taiLuaChon: _taiMonHoc,
        ),
        TruongBieuMau(
          tenTruong: 'giang_vien_id',
          nhan: 'Giảng viên phụ trách',
          kieu: KieuTruong.luaChon,
          batBuoc: true,
          taiLuaChon: _taiGiangVien,
        ),
        const TruongBieuMau(
          tenTruong: 'ma_lop',
          nhan: 'Mã lớp',
          kieu: KieuTruong.vanBan,
          batBuoc: true,
        ),
        const TruongBieuMau(
          tenTruong: 'ten_lop',
          nhan: 'Tên lớp',
          kieu: KieuTruong.vanBan,
          batBuoc: true,
        ),
        const TruongBieuMau(
          tenTruong: 'mo_ta',
          nhan: 'Mô tả',
          kieu: KieuTruong.vanBanNhieuDong,
        ),
        const TruongBieuMau(
          tenTruong: 'so_thanh_vien_toi_thieu',
          nhan: 'Số thành viên tối thiểu',
          kieu: KieuTruong.soNguyen,
          batBuoc: true,
          giaTriMacDinh: 1,
        ),
        const TruongBieuMau(
          tenTruong: 'so_thanh_vien_toi_da',
          nhan: 'Số thành viên tối đa',
          kieu: KieuTruong.soNguyen,
          batBuoc: true,
          giaTriMacDinh: 5,
        ),
        const TruongBieuMau(
          tenTruong: 'mo_dang_ky_luc',
          nhan: 'Mở đăng ký lúc',
          kieu: KieuTruong.ngayGio,
        ),
        const TruongBieuMau(
          tenTruong: 'dong_dang_ky_luc',
          nhan: 'Đóng đăng ký lúc',
          kieu: KieuTruong.ngayGio,
        ),
        const TruongBieuMau(
          tenTruong: 'mo_chon_de_tai_luc',
          nhan: 'Mở chọn đề tài lúc',
          kieu: KieuTruong.ngayGio,
        ),
        const TruongBieuMau(
          tenTruong: 'dong_chon_de_tai_luc',
          nhan: 'Đóng chọn đề tài lúc',
          kieu: KieuTruong.ngayGio,
        ),
        const TruongBieuMau(
          tenTruong: 'cho_phep_sinh_vien_tao_nhom',
          nhan: 'Cho phép sinh viên tạo nhóm',
          kieu: KieuTruong.boolean,
          giaTriMacDinh: true,
        ),
        const TruongBieuMau(
          tenTruong: 'can_giang_vien_duyet',
          nhan: 'Cần giảng viên duyệt',
          kieu: KieuTruong.boolean,
          giaTriMacDinh: true,
        ),
        const TruongBieuMau(
          tenTruong: 'trang_thai',
          nhan: 'Trạng thái',
          kieu: KieuTruong.luaChon,
          batBuoc: true,
          giaTriMacDinh: 'ban_nhap',
          luaChonTinh: [
            LuaChonMuc(giaTri: 'ban_nhap', nhan: 'Bản nháp'),
            LuaChonMuc(giaTri: 'mo_dang_ky', nhan: 'Mở đăng ký'),
            LuaChonMuc(giaTri: 'dong_dang_ky', nhan: 'Đóng đăng ký'),
            LuaChonMuc(giaTri: 'dang_thuc_hien', nhan: 'Đang thực hiện'),
            LuaChonMuc(giaTri: 'hoan_thanh', nhan: 'Hoàn thành'),
            LuaChonMuc(giaTri: 'luu_tru', nhan: 'Lưu trữ'),
          ],
        ),
      ],
      hamXuLyTruocKhiLuu: (duLieuMoi, duLieuCu) async {
        if (duLieuCu != null && !hoSo.laQuanTriVien && !hoSo.laGiangVien) {
          duLieuMoi['giang_vien_id'] = duLieuCu['giang_vien_id'];
        }
        return duLieuMoi;
      },
    );
  }
}
