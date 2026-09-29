import 'package:flutter/material.dart';

import '../dich_vu/dich_vu_ho_so.dart';
import '../dich_vu/dich_vu_xac_thuc.dart';
import '../mo_hinh/ho_so_nguoi_dung.dart';
import '../tien_ich/thong_bao.dart';
import 'man_hinh_cho.dart';
import 'trang/trang_danh_ba_ho_so.dart';
import 'trang/trang_de_tai.dart';
import 'trang/trang_ghi_danh.dart';
import 'trang/trang_ho_so.dart';
import 'trang/trang_hoc_ky.dart';
import 'trang/trang_lop_do_an.dart';
import 'trang/trang_mon_hoc.dart';
import 'trang/trang_nguyen_vong_de_tai.dart';
import 'trang/trang_nhat_ky_he_thong.dart';
import 'trang/trang_nhom_do_an.dart';
import 'trang/trang_phan_cong_de_tai.dart';
import 'trang/trang_thanh_vien_nhom.dart';
import 'trang/trang_tong_quan.dart';
import 'trang/trang_yeu_cau_vao_nhom.dart';

/// Cấu hình một mục điều hướng trên menu trái.
class MucDieuHuong {
  const MucDieuHuong({
    required this.nhan,
    required this.icon,
    required this.builder,
  });

  final String nhan;
  final IconData icon;
  final Widget Function() builder;
}

/// Màn hình chính sau khi người dùng đăng nhập thành công.
class ManHinhChinh extends StatefulWidget {
  const ManHinhChinh({super.key});

  @override
  State<ManHinhChinh> createState() => _ManHinhChinhState();
}

class _ManHinhChinhState extends State<ManHinhChinh> {
  final DichVuHoSo _dichVuHoSo = DichVuHoSo();
  final DichVuXacThuc _dichVuXacThuc = DichVuXacThuc();

  HoSoNguoiDung? _hoSo;
  bool _dangTaiHoSo = true;
  int _chiSoDangChon = 0;

  @override
  void initState() {
    super.initState();
    _taiHoSo();
  }

  /// Tải hồ sơ hiện tại từ Supabase để dựng menu đúng vai trò.
  Future<void> _taiHoSo() async {
    setState(() => _dangTaiHoSo = true);

    try {
      final hoSo = await _dichVuHoSo.layHoSoHienTai();

      if (!mounted) return;
      setState(() {
        _hoSo = hoSo;
      });
    } catch (loi) {
      if (!mounted) return;
      ThongBao.loi(context, loi);
    } finally {
      if (mounted) {
        setState(() => _dangTaiHoSo = false);
      }
    }
  }

  /// Trả về danh sách menu theo vai trò của người dùng.
  List<MucDieuHuong> _taoDanhSachMenu(HoSoNguoiDung hoSo) {
    final menu = <MucDieuHuong>[
      MucDieuHuong(
        nhan: 'Tổng quan',
        icon: Icons.dashboard_outlined,
        builder: () => TrangTongQuan(hoSo: hoSo),
      ),
      MucDieuHuong(
        nhan: 'Hồ sơ',
        icon: Icons.person_outline,
        builder: () => TrangHoSo(
          hoSo: hoSo,
          onDaCapNhat: _taiHoSo,
        ),
      ),
    ];

    if (hoSo.laQuanTriVien) {
      menu.addAll([
        MucDieuHuong(
          nhan: 'Danh bạ hồ sơ',
          icon: Icons.contacts_outlined,
          builder: () => TrangDanhBaHoSo(hoSo: hoSo),
        ),
        MucDieuHuong(
          nhan: 'Học kỳ',
          icon: Icons.calendar_month_outlined,
          builder: () => TrangHocKy(hoSo: hoSo),
        ),
        MucDieuHuong(
          nhan: 'Môn học',
          icon: Icons.menu_book_outlined,
          builder: () => TrangMonHoc(hoSo: hoSo),
        ),
      ]);
    }

    if (hoSo.laQuanTriVien || hoSo.laGiangVien || hoSo.laSinhVien) {
      menu.add(
        MucDieuHuong(
          nhan: 'Lớp đồ án',
          icon: Icons.class_outlined,
          builder: () => TrangLopDoAn(hoSo: hoSo),
        ),
      );
      menu.add(
        MucDieuHuong(
          nhan: 'Đề tài',
          icon: Icons.topic_outlined,
          builder: () => TrangDeTai(hoSo: hoSo),
        ),
      );
      menu.add(
        MucDieuHuong(
          nhan: 'Nhóm đồ án',
          icon: Icons.groups_outlined,
          builder: () => TrangNhomDoAn(hoSo: hoSo),
        ),
      );
      menu.add(
        MucDieuHuong(
          nhan: 'Thành viên nhóm',
          icon: Icons.group_outlined,
          builder: () => TrangThanhVienNhom(hoSo: hoSo),
        ),
      );
      menu.add(
        MucDieuHuong(
          nhan: 'Yêu cầu vào nhóm',
          icon: Icons.mark_email_unread_outlined,
          builder: () => TrangYeuCauVaoNhom(hoSo: hoSo),
        ),
      );
      menu.add(
        MucDieuHuong(
          nhan: 'Nguyện vọng đề tài',
          icon: Icons.playlist_add_check_circle_outlined,
          builder: () => TrangNguyenVongDeTai(hoSo: hoSo),
        ),
      );
      menu.add(
        MucDieuHuong(
          nhan: 'Phân công đề tài',
          icon: Icons.assignment_turned_in_outlined,
          builder: () => TrangPhanCongDeTai(hoSo: hoSo),
        ),
      );
    }

    if (hoSo.laQuanTriVien || hoSo.laGiangVien) {
      menu.insert(
        hoSo.laQuanTriVien ? 6 : 2,
        MucDieuHuong(
          nhan: 'Ghi danh',
          icon: Icons.how_to_reg_outlined,
          builder: () => TrangGhiDanh(hoSo: hoSo),
        ),
      );
    }

    if (hoSo.laQuanTriVien) {
      menu.add(
        MucDieuHuong(
          nhan: 'Nhật ký hệ thống',
          icon: Icons.history_outlined,
          builder: () => TrangNhatKyHeThong(hoSo: hoSo),
        ),
      );
    }

    return menu;
  }

  /// Đăng xuất người dùng ra khỏi ứng dụng.
  Future<void> _dangXuat() async {
    final dongY = await ThongBao.xacNhan(
      context,
      tieuDe: 'Đăng xuất',
      noiDung: 'Bạn có chắc muốn đăng xuất khỏi hệ thống không?',
    );

    if (!dongY) return;

    try {
      await _dichVuXacThuc.dangXuat();
    } catch (loi) {
      if (!mounted) return;
      ThongBao.loi(context, loi);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_dangTaiHoSo) {
      return const ManHinhCho(thongDiep: 'Đang nạp hồ sơ người dùng...');
    }

    final hoSo = _hoSo;
    if (hoSo == null) {
      return Scaffold(
        body: Center(
          child: FilledButton.icon(
            onPressed: _taiHoSo,
            icon: const Icon(Icons.refresh),
            label: const Text('Tải lại hồ sơ'),
          ),
        ),
      );
    }

    final danhSachMenu = _taoDanhSachMenu(hoSo);
    if (_chiSoDangChon >= danhSachMenu.length) {
      _chiSoDangChon = 0;
    }

    final trangHienTai = danhSachMenu[_chiSoDangChon];

    return LayoutBuilder(
      builder: (context, constraints) {
        final laManHinhLon = constraints.maxWidth >= 1100;

        Widget noiDung = AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: KeyedSubtree(
            key: ValueKey(trangHienTai.nhan),
            child: trangHienTai.builder(),
          ),
        );

        if (laManHinhLon) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _chiSoDangChon,
                  onDestinationSelected: (index) {
                    setState(() => _chiSoDangChon = index);
                  },
                  labelType: NavigationRailLabelType.all,
                  leading: Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 12),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 26,
                          child: Text(
                            hoSo.hoTen.isNotEmpty
                                ? hoSo.hoTen[0].toUpperCase()
                                : '?',
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: 96,
                          child: Text(
                            hoSo.nhanVaiTro,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  trailing: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: IconButton(
                      tooltip: 'Đăng xuất',
                      onPressed: _dangXuat,
                      icon: const Icon(Icons.logout),
                    ),
                  ),
                  destinations: danhSachMenu
                      .map(
                        (muc) => NavigationRailDestination(
                          icon: Icon(muc.icon),
                          label: Text(muc.nhan),
                        ),
                      )
                      .toList(),
                ),
                const VerticalDivider(width: 1),
                Expanded(child: noiDung),
              ],
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(trangHienTai.nhan),
            actions: [
              IconButton(
                onPressed: _dangXuat,
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
          drawer: Drawer(
            child: SafeArea(
              child: Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        hoSo.hoTen.isNotEmpty ? hoSo.hoTen[0].toUpperCase() : '?',
                      ),
                    ),
                    title: Text(hoSo.hoTen),
                    subtitle: Text(hoSo.nhanVaiTro),
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: danhSachMenu.length,
                      itemBuilder: (context, index) {
                        final muc = danhSachMenu[index];
                        final dangChon = index == _chiSoDangChon;
                        return ListTile(
                          selected: dangChon,
                          leading: Icon(muc.icon),
                          title: Text(muc.nhan),
                          onTap: () {
                            Navigator.of(context).pop();
                            setState(() => _chiSoDangChon = index);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: noiDung,
        );
      },
    );
  }
}
