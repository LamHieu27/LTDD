import 'package:flutter/material.dart';

import '../../dich_vu/dich_vu_du_lieu.dart';
import '../../mo_hinh/ho_so_nguoi_dung.dart';
import 'trang_quan_ly_co_ban.dart';

/// Trang quản lý yêu cầu xin vào nhóm.
class TrangYeuCauVaoNhom extends StatelessWidget {
  TrangYeuCauVaoNhom({
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
          (e) => LuaChonMuc(
            giaTri: e['id'],
            nhan: e['ten_nhom'].toString(),
          ),
        )
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
        .map(
          (e) => LuaChonMuc(
            giaTri: e['id'],
            nhan: e['ho_ten'].toString(),
          ),
        )
        .toList();
  }

  /// Tải danh sách người xử lý.
  Future<List<LuaChonMuc>> _taiNguoiXuLy() async {
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
      tieuDe: 'Yêu cầu vào nhóm',
      moTa:
          'Sinh viên gửi yêu cầu vào nhóm; nhóm trưởng hoặc giảng viên xử lý yêu cầu.',
      bang: 'yeu_cau_vao_nhom',
      hoSo: hoSo,
      selectClause:
          '*, lop:lop_do_an_id(ma_lop), nhom:nhom_id(ten_nhom), sinh_vien:sinh_vien_id(ho_ten), nguoi_xu_ly:xu_ly_boi(ho_ten)',
      sapXepTheo: 'tao_luc',
      danhSachCot: const [
        CotBang(tenTruong: 'lop.ma_lop', nhan: 'Lớp'),
        CotBang(tenTruong: 'nhom.ten_nhom', nhan: 'Nhóm'),
        CotBang(tenTruong: 'sinh_vien.ho_ten', nhan: 'Sinh viên'),
        CotBang(tenTruong: 'trang_thai', nhan: 'Trạng thái'),
        CotBang(tenTruong: 'tao_luc', nhan: 'Tạo lúc'),
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
          tenTruong: 'sinh_vien_id',
          nhan: 'Sinh viên',
          kieu: KieuTruong.luaChon,
          batBuoc: true,
          taiLuaChon: _taiSinhVien,
        ),
        const TruongBieuMau(
          tenTruong: 'loi_nhan',
          nhan: 'Lời nhắn',
          kieu: KieuTruong.vanBanNhieuDong,
        ),
        const TruongBieuMau(
          tenTruong: 'trang_thai',
          nhan: 'Trạng thái',
          kieu: KieuTruong.luaChon,
          batBuoc: true,
          giaTriMacDinh: 'cho_duyet',
          luaChonTinh: [
            LuaChonMuc(giaTri: 'cho_duyet', nhan: 'Chờ duyệt'),
            LuaChonMuc(giaTri: 'da_duyet', nhan: 'Đã duyệt'),
            LuaChonMuc(giaTri: 'tu_choi', nhan: 'Từ chối'),
            LuaChonMuc(giaTri: 'da_huy', nhan: 'Đã huỷ'),
          ],
        ),
        TruongBieuMau(
          tenTruong: 'xu_ly_boi',
          nhan: 'Xử lý bởi',
          kieu: KieuTruong.luaChon,
          taiLuaChon: _taiNguoiXuLy,
        ),
        const TruongBieuMau(
          tenTruong: 'xu_ly_luc',
          nhan: 'Xử lý lúc',
          kieu: KieuTruong.ngayGio,
        ),
      ],
    );
  }
}
