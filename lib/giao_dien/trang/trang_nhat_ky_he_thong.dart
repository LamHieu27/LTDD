import 'package:flutter/material.dart';

import '../../mo_hinh/ho_so_nguoi_dung.dart';
import 'trang_quan_ly_co_ban.dart';

/// Trang hiển thị nhật ký hệ thống cho quản trị viên.
class TrangNhatKyHeThong extends StatelessWidget {
  const TrangNhatKyHeThong({
    super.key,
    required this.hoSo,
  });

  final HoSoNguoiDung hoSo;

  @override
  Widget build(BuildContext context) {
    return TrangQuanLyCoBan(
      tieuDe: 'Nhật ký hệ thống',
      moTa:
          'Theo dõi lịch sử thêm, sửa, xoá trên toàn bộ hệ thống để phục vụ kiểm tra và demo đồ án.',
      bang: 'nhat_ky_he_thong',
      hoSo: hoSo,
      duocThem: false,
      duocSua: false,
      duocXoa: false,
      selectClause: '*, nguoi_thuc_hien:nguoi_thuc_hien_id(ho_ten)',
      sapXepTheo: 'tao_luc',
      danhSachCot: const [
        CotBang(tenTruong: 'nguoi_thuc_hien.ho_ten', nhan: 'Người thực hiện'),
        CotBang(tenTruong: 'hanh_dong', nhan: 'Hành động'),
        CotBang(tenTruong: 'loai_doi_tuong', nhan: 'Loại đối tượng'),
        CotBang(tenTruong: 'doi_tuong_id', nhan: 'ID đối tượng'),
        CotBang(tenTruong: 'tao_luc', nhan: 'Thời gian'),
      ],
      danhSachTruong: const [],
    );
  }
}
