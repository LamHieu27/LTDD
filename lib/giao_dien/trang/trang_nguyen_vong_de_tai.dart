import 'package:flutter/material.dart';

import '../../dich_vu/dich_vu_du_lieu.dart';
import '../../mo_hinh/ho_so_nguoi_dung.dart';
import 'trang_quan_ly_co_ban.dart';

/// Trang quản lý nguyện vọng đề tài của từng nhóm.
class TrangNguyenVongDeTai extends StatelessWidget {
  TrangNguyenVongDeTai({
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

  /// Tải danh sách người gửi.
  Future<List<LuaChonMuc>> _taiNguoiGui() async {
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
      tieuDe: 'Nguyện vọng đề tài',
      moTa:
          'Nhóm trưởng gửi thứ tự ưu tiên đề tài cho nhóm của mình hoặc giảng viên theo dõi.',
      bang: 'nguyen_vong_de_tai',
      hoSo: hoSo,
      selectClause:
          '*, lop:lop_do_an_id(ma_lop), nhom:nhom_id(ten_nhom), de_tai:de_tai_id(ten_de_tai, ma_de_tai), nguoi_gui:gui_boi(ho_ten)',
      sapXepTheo: 'gui_luc',
      danhSachCot: const [
        CotBang(tenTruong: 'nhom.ten_nhom', nhan: 'Nhóm'),
        CotBang(tenTruong: 'de_tai.ten_de_tai', nhan: 'Đề tài'),
        CotBang(tenTruong: 'thu_tu_uu_tien', nhan: 'Ưu tiên', canGiua: true),
        CotBang(tenTruong: 'trang_thai', nhan: 'Trạng thái'),
        CotBang(tenTruong: 'gui_luc', nhan: 'Gửi lúc'),
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
        const TruongBieuMau(
          tenTruong: 'thu_tu_uu_tien',
          nhan: 'Thứ tự ưu tiên',
          kieu: KieuTruong.soNguyen,
          batBuoc: true,
        ),
        const TruongBieuMau(
          tenTruong: 'ghi_chu',
          nhan: 'Ghi chú',
          kieu: KieuTruong.vanBanNhieuDong,
        ),
        TruongBieuMau(
          tenTruong: 'gui_boi',
          nhan: 'Gửi bởi',
          kieu: KieuTruong.luaChon,
          batBuoc: true,
          taiLuaChon: _taiNguoiGui,
        ),
        const TruongBieuMau(
          tenTruong: 'gui_luc',
          nhan: 'Gửi lúc',
          kieu: KieuTruong.ngayGio,
        ),
        const TruongBieuMau(
          tenTruong: 'trang_thai',
          nhan: 'Trạng thái',
          kieu: KieuTruong.luaChon,
          batBuoc: true,
          giaTriMacDinh: 'da_gui',
          luaChonTinh: [
            LuaChonMuc(giaTri: 'ban_nhap', nhan: 'Bản nháp'),
            LuaChonMuc(giaTri: 'da_gui', nhan: 'Đã gửi'),
            LuaChonMuc(giaTri: 'da_xem', nhan: 'Đã xem'),
          ],
        ),
      ],
    );
  }
}
