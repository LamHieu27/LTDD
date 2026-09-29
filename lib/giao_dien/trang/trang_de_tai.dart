import 'package:flutter/material.dart';

import '../../dich_vu/dich_vu_du_lieu.dart';
import '../../mo_hinh/ho_so_nguoi_dung.dart';
import 'trang_quan_ly_co_ban.dart';

/// Trang quản lý đề tài đồ án.
class TrangDeTai extends StatelessWidget {
  TrangDeTai({
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
      tieuDe: 'Quản lý đề tài',
      moTa:
          'Tạo danh sách đề tài, mô tả công nghệ, số lượng thành viên và trạng thái công bố.',
      bang: 'de_tai',
      hoSo: hoSo,
      selectClause:
          '*, lop:lop_do_an_id(ma_lop, ten_lop), giang_vien:giang_vien_id(ho_ten)',
      sapXepTheo: 'tao_luc',
      danhSachCot: const [
        CotBang(tenTruong: 'ma_de_tai', nhan: 'Mã đề tài'),
        CotBang(tenTruong: 'ten_de_tai', nhan: 'Tên đề tài'),
        CotBang(tenTruong: 'lop.ma_lop', nhan: 'Lớp'),
        CotBang(tenTruong: 'giang_vien.ho_ten', nhan: 'Giảng viên'),
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
          tenTruong: 'giang_vien_id',
          nhan: 'Giảng viên phụ trách',
          kieu: KieuTruong.luaChon,
          batBuoc: true,
          taiLuaChon: _taiGiangVien,
        ),
        const TruongBieuMau(
          tenTruong: 'ma_de_tai',
          nhan: 'Mã đề tài',
          kieu: KieuTruong.vanBan,
          batBuoc: true,
        ),
        const TruongBieuMau(
          tenTruong: 'ten_de_tai',
          nhan: 'Tên đề tài',
          kieu: KieuTruong.vanBan,
          batBuoc: true,
        ),
        const TruongBieuMau(
          tenTruong: 'mo_ta',
          nhan: 'Mô tả',
          kieu: KieuTruong.vanBanNhieuDong,
        ),
        const TruongBieuMau(
          tenTruong: 'muc_tieu',
          nhan: 'Mục tiêu',
          kieu: KieuTruong.vanBanNhieuDong,
        ),
        const TruongBieuMau(
          tenTruong: 'yeu_cau',
          nhan: 'Yêu cầu',
          kieu: KieuTruong.vanBanNhieuDong,
        ),
        const TruongBieuMau(
          tenTruong: 'cong_nghe',
          nhan: 'Công nghệ',
          kieu: KieuTruong.vanBanNhieuDong,
        ),
        const TruongBieuMau(
          tenTruong: 'san_pham_ban_giao',
          nhan: 'Sản phẩm bàn giao',
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
          tenTruong: 'trang_thai',
          nhan: 'Trạng thái',
          kieu: KieuTruong.luaChon,
          batBuoc: true,
          giaTriMacDinh: 'ban_nhap',
          luaChonTinh: [
            LuaChonMuc(giaTri: 'ban_nhap', nhan: 'Bản nháp'),
            LuaChonMuc(giaTri: 'da_cong_bo', nhan: 'Đã công bố'),
            LuaChonMuc(giaTri: 'dong', nhan: 'Đóng'),
            LuaChonMuc(giaTri: 'da_gan_nhom', nhan: 'Đã gán nhóm'),
            LuaChonMuc(giaTri: 'luu_tru', nhan: 'Lưu trữ'),
          ],
        ),
        TruongBieuMau(
          tenTruong: 'tao_boi',
          nhan: 'Tạo bởi',
          kieu: KieuTruong.luaChon,
          taiLuaChon: _taiGiangVien,
        ),
        TruongBieuMau(
          tenTruong: 'duyet_boi',
          nhan: 'Duyệt bởi',
          kieu: KieuTruong.luaChon,
          taiLuaChon: _taiGiangVien,
        ),
        const TruongBieuMau(
          tenTruong: 'cong_bo_luc',
          nhan: 'Công bố lúc',
          kieu: KieuTruong.ngayGio,
        ),
      ],
    );
  }
}
