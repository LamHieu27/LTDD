import 'package:flutter/material.dart';

import '../../dich_vu/dich_vu_du_lieu.dart';
import '../../mo_hinh/ho_so_nguoi_dung.dart';
import '../thanh_phan/khung_trang_hien_dai.dart';
import '../thanh_phan/o_the_so_lieu.dart';

/// Trang tổng quan hiển thị các số liệu nổi bật theo vai trò.
class TrangTongQuan extends StatefulWidget {
  const TrangTongQuan({
    super.key,
    required this.hoSo,
  });

  final HoSoNguoiDung hoSo;

  @override
  State<TrangTongQuan> createState() => _TrangTongQuanState();
}

class _TrangTongQuanState extends State<TrangTongQuan> {
  final DichVuDuLieu _dichVuDuLieu = DichVuDuLieu();

  bool _dangTai = true;
  final Map<String, int> _soLieu = {};

  @override
  void initState() {
    super.initState();
    _taiTongQuan();
  }

  /// Tải các chỉ số chính cho dashboard.
  Future<void> _taiTongQuan() async {
    setState(() => _dangTai = true);

    final soLieu = <String, int>{};

    try {
      soLieu['lop_do_an'] = await _dichVuDuLieu.demSoLuong(bang: 'lop_do_an');
      soLieu['de_tai'] = await _dichVuDuLieu.demSoLuong(bang: 'de_tai');
      soLieu['nhom_do_an'] = await _dichVuDuLieu.demSoLuong(bang: 'nhom_do_an');

      if (widget.hoSo.laQuanTriVien || widget.hoSo.laGiangVien) {
        soLieu['ghi_danh'] = await _dichVuDuLieu.demSoLuong(bang: 'ghi_danh');
        soLieu['yeu_cau'] =
            await _dichVuDuLieu.demSoLuong(bang: 'yeu_cau_vao_nhom');
      }

      if (widget.hoSo.laQuanTriVien) {
        soLieu['hoc_ky'] = await _dichVuDuLieu.demSoLuong(bang: 'hoc_ky');
        soLieu['mon_hoc'] = await _dichVuDuLieu.demSoLuong(bang: 'mon_hoc');
        soLieu['nhat_ky'] =
            await _dichVuDuLieu.demSoLuong(bang: 'nhat_ky_he_thong');
      }

      if (!mounted) return;
      setState(() {
        _soLieu
          ..clear()
          ..addAll(soLieu);
      });
    } finally {
      if (mounted) {
        setState(() => _dangTai = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final danhSachThe = <Widget>[
      OTheSoLieu(
        tieuDe: 'Lớp đồ án',
        giaTri: (_soLieu['lop_do_an'] ?? 0).toString(),
        bieuTuong: Icons.class_outlined,
        moTa: 'Các lớp mà tài khoản được phép xem.',
      ),
      OTheSoLieu(
        tieuDe: 'Đề tài',
        giaTri: (_soLieu['de_tai'] ?? 0).toString(),
        bieuTuong: Icons.topic_outlined,
        moTa: 'Tổng số đề tài bạn có quyền truy cập.',
      ),
      OTheSoLieu(
        tieuDe: 'Nhóm đồ án',
        giaTri: (_soLieu['nhom_do_an'] ?? 0).toString(),
        bieuTuong: Icons.groups_outlined,
        moTa: 'Số nhóm hiện có trong phạm vi được phép xem.',
      ),
      if (widget.hoSo.laQuanTriVien || widget.hoSo.laGiangVien)
        OTheSoLieu(
          tieuDe: 'Ghi danh',
          giaTri: (_soLieu['ghi_danh'] ?? 0).toString(),
          bieuTuong: Icons.how_to_reg_outlined,
          moTa: 'Danh sách sinh viên đã được ghi danh.',
        ),
      if (widget.hoSo.laQuanTriVien || widget.hoSo.laGiangVien)
        OTheSoLieu(
          tieuDe: 'Yêu cầu vào nhóm',
          giaTri: (_soLieu['yeu_cau'] ?? 0).toString(),
          bieuTuong: Icons.mark_email_unread_outlined,
          moTa: 'Các yêu cầu đang/đã được xử lý.',
        ),
      if (widget.hoSo.laQuanTriVien)
        OTheSoLieu(
          tieuDe: 'Học kỳ',
          giaTri: (_soLieu['hoc_ky'] ?? 0).toString(),
          bieuTuong: Icons.calendar_month_outlined,
          moTa: 'Tổng số học kỳ trong hệ thống.',
        ),
      if (widget.hoSo.laQuanTriVien)
        OTheSoLieu(
          tieuDe: 'Môn học',
          giaTri: (_soLieu['mon_hoc'] ?? 0).toString(),
          bieuTuong: Icons.menu_book_outlined,
          moTa: 'Tổng số môn học đã cấu hình.',
        ),
      if (widget.hoSo.laQuanTriVien)
        OTheSoLieu(
          tieuDe: 'Nhật ký hệ thống',
          giaTri: (_soLieu['nhat_ky'] ?? 0).toString(),
          bieuTuong: Icons.history_outlined,
          moTa: 'Số log được lưu trong hệ thống.',
        ),
    ];

    return KhungTrangHienDai(
      tieuDe: 'Tổng quan',
      moTa:
          'Xin chào ${widget.hoSo.hoTen}. Đây là bảng điều khiển trung tâm cho vai trò ${widget.hoSo.nhanVaiTro.toLowerCase()}.',
      hanhDong: [
        FilledButton.icon(
          onPressed: _taiTongQuan,
          icon: const Icon(Icons.refresh),
          label: const Text('Làm mới số liệu'),
        ),
      ],
      noiDung: _dangTai
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(28),
                child: CircularProgressIndicator(),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: danhSachThe
                      .map(
                        (the) => SizedBox(
                          width: 330,
                          child: the,
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gợi ý sử dụng',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '• Sinh viên: xem lớp, tạo nhóm, gửi yêu cầu vào nhóm, gửi nguyện vọng đề tài.\n'
                        '• Giảng viên: quản lý lớp đồ án, đề tài, ghi danh, duyệt nhóm và phân công đề tài.\n'
                        '• Quản trị viên: cấu hình học kỳ, môn học, giám sát nhật ký toàn hệ thống.',
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
