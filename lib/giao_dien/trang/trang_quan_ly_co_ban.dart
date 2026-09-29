import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../dich_vu/dich_vu_du_lieu.dart';
import '../../mo_hinh/ho_so_nguoi_dung.dart';
import '../../tien_ich/thong_bao.dart';
import '../thanh_phan/khung_trang_hien_dai.dart';

/// Kiểu dữ liệu của một trường trong biểu mẫu CRUD.
enum KieuTruong {
  vanBan,
  vanBanNhieuDong,
  soNguyen,
  soThuc,
  boolean,
  ngay,
  ngayGio,
  luaChon,
}

/// Một mục lựa chọn hiển thị trong combobox.
class LuaChonMuc {
  const LuaChonMuc({
    required this.giaTri,
    required this.nhan,
  });

  final dynamic giaTri;
  final String nhan;
}

/// Cấu hình cho một trường nhập liệu.
class TruongBieuMau {
  const TruongBieuMau({
    required this.tenTruong,
    required this.nhan,
    required this.kieu,
    this.batBuoc = false,
    this.chiDoc = false,
    this.goiY,
    this.giaTriMacDinh,
    this.luaChonTinh,
    this.taiLuaChon,
  });

  final String tenTruong;
  final String nhan;
  final KieuTruong kieu;
  final bool batBuoc;
  final bool chiDoc;
  final String? goiY;
  final dynamic giaTriMacDinh;
  final List<LuaChonMuc>? luaChonTinh;
  final Future<List<LuaChonMuc>> Function()? taiLuaChon;
}

/// Cấu hình cho một cột hiển thị trên bảng.
class CotBang {
  const CotBang({
    required this.tenTruong,
    required this.nhan,
    this.hienThi = true,
    this.canGiua = false,
    this.hamDinhDang,
  });

  final String tenTruong;
  final String nhan;
  final bool hienThi;
  final bool canGiua;
  final String Function(dynamic giaTri, Map<String, dynamic> dong)? hamDinhDang;
}

/// Hàm dùng để biến đổi dữ liệu trước khi lưu vào Supabase.
typedef HamXuLyTruocKhiLuu = FutureOr<Map<String, dynamic>> Function(
  Map<String, dynamic> duLieuMoi,
  Map<String, dynamic>? duLieuCu,
);

/// Widget CRUD tổng quát để tái sử dụng cho hầu hết các bảng trong hệ thống.
class TrangQuanLyCoBan extends StatefulWidget {
  const TrangQuanLyCoBan({
    super.key,
    required this.tieuDe,
    required this.moTa,
    required this.bang,
    required this.hoSo,
    required this.danhSachCot,
    required this.danhSachTruong,
    this.selectClause = '*',
    this.sapXepTheo,
    this.khoaChinh = 'id',
    this.duocThem = true,
    this.duocSua = true,
    this.duocXoa = true,
    this.tieuDeNutThem = 'Thêm mới',
    this.hamXuLyTruocKhiLuu,
  });

  final String tieuDe;
  final String moTa;
  final String bang;
  final HoSoNguoiDung hoSo;
  final List<CotBang> danhSachCot;
  final List<TruongBieuMau> danhSachTruong;
  final String selectClause;
  final String? sapXepTheo;
  final String khoaChinh;
  final bool duocThem;
  final bool duocSua;
  final bool duocXoa;
  final String tieuDeNutThem;
  final HamXuLyTruocKhiLuu? hamXuLyTruocKhiLuu;

  @override
  State<TrangQuanLyCoBan> createState() => _TrangQuanLyCoBanState();
}

class _TrangQuanLyCoBanState extends State<TrangQuanLyCoBan> {
  final DichVuDuLieu _dichVuDuLieu = DichVuDuLieu();
  final TextEditingController _timKiemController = TextEditingController();
  final DateFormat _dinhDangNgay = DateFormat('dd/MM/yyyy');
  final DateFormat _dinhDangNgayGio = DateFormat('dd/MM/yyyy HH:mm');

  bool _dangTai = true;
  List<Map<String, dynamic>> _duLieu = <Map<String, dynamic>>[];
  String _tuKhoa = '';

  @override
  void initState() {
    super.initState();
    _taiDuLieu();
  }

  @override
  void dispose() {
    _timKiemController.dispose();
    super.dispose();
  }

  /// Tải lại dữ liệu từ Supabase và cập nhật giao diện.
  Future<void> _taiDuLieu() async {
    setState(() => _dangTai = true);

    try {
      final duLieu = await _dichVuDuLieu.layDanhSach(
        bang: widget.bang,
        selectClause: widget.selectClause,
        sapXepTheo: widget.sapXepTheo,
      );

      if (!mounted) return;
      setState(() {
        _duLieu = duLieu;
      });
    } catch (loi) {
      if (!mounted) return;
      ThongBao.loi(context, loi);
    } finally {
      if (mounted) {
        setState(() => _dangTai = false);
      }
    }
  }

  /// Trả về danh sách dữ liệu sau khi lọc theo từ khoá tìm kiếm.
  List<Map<String, dynamic>> get _duLieuSauLoc {
    return _dichVuDuLieu.timKiemCucBo(_duLieu, _tuKhoa);
  }

  /// Lấy giá trị của một trường theo cú pháp `a.b.c` để hỗ trợ join.
  dynamic _layGiaTri(Map<String, dynamic> banGhi, String duongDan) {
    dynamic hienTai = banGhi;
    for (final phan in duongDan.split('.')) {
      if (hienTai is Map<String, dynamic>) {
        hienTai = hienTai[phan];
      } else {
        return null;
      }
    }
    return hienTai;
  }

  /// Chuyển giá trị thô thành chuỗi đẹp để hiển thị trên bảng.
  String _chuyenThanhChuoi(
    dynamic giaTri,
    CotBang cot,
    Map<String, dynamic> dong,
  ) {
    if (cot.hamDinhDang != null) {
      return cot.hamDinhDang!(giaTri, dong);
    }

    if (giaTri == null) return '—';
    if (giaTri is bool) return giaTri ? 'Có' : 'Không';

    final chuoi = giaTri.toString();
    final kieuNgay = DateTime.tryParse(chuoi);
    if (kieuNgay != null && chuoi.contains('-')) {
      if (chuoi.contains(':')) {
        return _dinhDangNgayGio.format(kieuNgay.toLocal());
      }
      return _dinhDangNgay.format(kieuNgay.toLocal());
    }

    return chuoi;
  }

  /// Mở hộp thoại nhập liệu để thêm hoặc sửa một bản ghi.
  Future<Map<String, dynamic>?> _moHopThoaiNhapLieu({
    Map<String, dynamic>? duLieuBanDau,
  }) async {
    final formKey = GlobalKey<FormState>();
    final duLieuLamViec = <String, dynamic>{};

    for (final truong in widget.danhSachTruong) {
      duLieuLamViec[truong.tenTruong] =
          duLieuBanDau?[truong.tenTruong] ?? truong.giaTriMacDinh;
    }

    final nguonLuaChon = <String, List<LuaChonMuc>>{};
    for (final truong in widget.danhSachTruong) {
      if (truong.taiLuaChon != null) {
        nguonLuaChon[truong.tenTruong] = await truong.taiLuaChon!.call();
      } else if (truong.luaChonTinh != null) {
        nguonLuaChon[truong.tenTruong] = truong.luaChonTinh!;
      }
    }

    if (!mounted) return null;

    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            Future<void> chonNgay(String truongTen) async {
              final banDau = DateTime.tryParse(
                    duLieuLamViec[truongTen]?.toString() ?? '',
                  ) ??
                  DateTime.now();

              final ngay = await showDatePicker(
                context: context,
                initialDate: banDau,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );

              if (ngay != null) {
                setDialogState(() {
                  duLieuLamViec[truongTen] =
                      DateFormat('yyyy-MM-dd').format(ngay);
                });
              }
            }

            Future<void> chonNgayGio(String truongTen) async {
              final banDau = DateTime.tryParse(
                    duLieuLamViec[truongTen]?.toString() ?? '',
                  ) ??
                  DateTime.now();

              final ngay = await showDatePicker(
                context: context,
                initialDate: banDau,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );

              if (ngay == null) return;

              if (!mounted) return;
              final gio = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(banDau),
              );

              final gioChon = gio ?? const TimeOfDay(hour: 0, minute: 0);
              final ketQua = DateTime(
                ngay.year,
                ngay.month,
                ngay.day,
                gioChon.hour,
                gioChon.minute,
              );

              setDialogState(() {
                duLieuLamViec[truongTen] = ketQua.toIso8601String();
              });
            }

            return AlertDialog(
              title: Text(
                duLieuBanDau == null ? 'Thêm bản ghi' : 'Cập nhật bản ghi',
              ),
              content: SizedBox(
                width: 640,
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: widget.danhSachTruong.map((truong) {
                        final giaTri = duLieuLamViec[truong.tenTruong];
                        final luaChon = nguonLuaChon[truong.tenTruong];

                        switch (truong.kieu) {
                          case KieuTruong.boolean:
                            return SwitchListTile(
                              value: giaTri == true,
                              onChanged: truong.chiDoc
                                  ? null
                                  : (value) {
                                      setDialogState(() {
                                        duLieuLamViec[truong.tenTruong] = value;
                                      });
                                    },
                              title: Text(truong.nhan),
                            );
                          case KieuTruong.luaChon:
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: DropdownButtonFormField<dynamic>(
                                value: giaTri,
                                items: (luaChon ?? [])
                                    .map(
                                      (muc) => DropdownMenuItem<dynamic>(
                                        value: muc.giaTri,
                                        child: Text(muc.nhan),
                                      ),
                                    )
                                    .toList(),
                                onChanged: truong.chiDoc
                                    ? null
                                    : (value) {
                                        setDialogState(() {
                                          duLieuLamViec[truong.tenTruong] =
                                              value;
                                        });
                                      },
                                decoration: InputDecoration(
                                  labelText: truong.nhan,
                                  hintText: truong.goiY,
                                ),
                                validator: (value) {
                                  if (truong.batBuoc && value == null) {
                                    return 'Vui lòng chọn ${truong.nhan.toLowerCase()}.';
                                  }
                                  return null;
                                },
                              ),
                            );
                          case KieuTruong.ngay:
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: TextFormField(
                                readOnly: true,
                                initialValue: giaTri?.toString() ?? '',
                                decoration: InputDecoration(
                                  labelText: truong.nhan,
                                  hintText: truong.goiY,
                                  suffixIcon: IconButton(
                                    onPressed: truong.chiDoc
                                        ? null
                                        : () => chonNgay(truong.tenTruong),
                                    icon: const Icon(Icons.calendar_month),
                                  ),
                                ),
                                validator: (value) {
                                  if (truong.batBuoc &&
                                      (value == null || value.trim().isEmpty)) {
                                    return 'Vui lòng nhập ${truong.nhan.toLowerCase()}.';
                                  }
                                  return null;
                                },
                              ),
                            );
                          case KieuTruong.ngayGio:
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: TextFormField(
                                readOnly: true,
                                initialValue: giaTri?.toString() ?? '',
                                decoration: InputDecoration(
                                  labelText: truong.nhan,
                                  hintText: truong.goiY,
                                  suffixIcon: IconButton(
                                    onPressed: truong.chiDoc
                                        ? null
                                        : () => chonNgayGio(truong.tenTruong),
                                    icon: const Icon(Icons.schedule),
                                  ),
                                ),
                                validator: (value) {
                                  if (truong.batBuoc &&
                                      (value == null || value.trim().isEmpty)) {
                                    return 'Vui lòng nhập ${truong.nhan.toLowerCase()}.';
                                  }
                                  return null;
                                },
                              ),
                            );
                          case KieuTruong.vanBanNhieuDong:
                          case KieuTruong.vanBan:
                          case KieuTruong.soNguyen:
                          case KieuTruong.soThuc:
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: TextFormField(
                                initialValue: giaTri?.toString() ?? '',
                                readOnly: truong.chiDoc,
                                minLines:
                                    truong.kieu == KieuTruong.vanBanNhieuDong
                                        ? 3
                                        : 1,
                                maxLines:
                                    truong.kieu == KieuTruong.vanBanNhieuDong
                                        ? 5
                                        : 1,
                                keyboardType: truong.kieu == KieuTruong.soNguyen
                                    ? TextInputType.number
                                    : truong.kieu == KieuTruong.soThuc
                                        ? const TextInputType.numberWithOptions(
                                            decimal: true,
                                          )
                                        : TextInputType.text,
                                decoration: InputDecoration(
                                  labelText: truong.nhan,
                                  hintText: truong.goiY,
                                ),
                                onChanged: (value) {
                                  duLieuLamViec[truong.tenTruong] = value;
                                },
                                validator: (value) {
                                  if (truong.batBuoc &&
                                      (value == null || value.trim().isEmpty)) {
                                    return 'Vui lòng nhập ${truong.nhan.toLowerCase()}.';
                                  }
                                  return null;
                                },
                              ),
                            );
                        }
                      }).toList(),
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Huỷ'),
                ),
                FilledButton(
                  onPressed: () {
                    if (!formKey.currentState!.validate()) {
                      return;
                    }

                    final duLieuKetQua = <String, dynamic>{};

                    for (final truong in widget.danhSachTruong) {
                      final giaTri = duLieuLamViec[truong.tenTruong];
                      if (giaTri == null || (giaTri is String && giaTri.isEmpty)) {
                        duLieuKetQua[truong.tenTruong] = null;
                        continue;
                      }

                      switch (truong.kieu) {
                        case KieuTruong.soNguyen:
                          duLieuKetQua[truong.tenTruong] =
                              int.tryParse(giaTri.toString());
                          break;
                        case KieuTruong.soThuc:
                          duLieuKetQua[truong.tenTruong] =
                              double.tryParse(giaTri.toString());
                          break;
                        default:
                          duLieuKetQua[truong.tenTruong] = giaTri;
                      }
                    }

                    Navigator.of(context).pop(duLieuKetQua);
                  },
                  child: const Text('Lưu'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Xử lý thêm bản ghi mới.
  Future<void> _themBanGhi() async {
    try {
      final duLieuMoi = await _moHopThoaiNhapLieu();
      if (duLieuMoi == null) return;

      final duLieuCanLuu = widget.hamXuLyTruocKhiLuu == null
          ? duLieuMoi
          : await widget.hamXuLyTruocKhiLuu!(duLieuMoi, null);

      await _dichVuDuLieu.themBanGhi(
        bang: widget.bang,
        duLieu: duLieuCanLuu,
        khoaChinh: widget.khoaChinh,
      );

      if (!mounted) return;
      ThongBao.thanhCong(context, 'Đã thêm dữ liệu thành công.');
      await _taiDuLieu();
    } catch (loi) {
      if (!mounted) return;
      ThongBao.loi(context, loi);
    }
  }

  /// Xử lý cập nhật bản ghi đã có.
  Future<void> _suaBanGhi(Map<String, dynamic> banGhiCu) async {
    try {
      final duLieuMoi = await _moHopThoaiNhapLieu(duLieuBanDau: banGhiCu);
      if (duLieuMoi == null) return;

      final duLieuCanLuu = widget.hamXuLyTruocKhiLuu == null
          ? duLieuMoi
          : await widget.hamXuLyTruocKhiLuu!(duLieuMoi, banGhiCu);

      await _dichVuDuLieu.capNhatBanGhi(
        bang: widget.bang,
        id: banGhiCu[widget.khoaChinh],
        duLieu: duLieuCanLuu,
        khoaChinh: widget.khoaChinh,
      );

      if (!mounted) return;
      ThongBao.thanhCong(context, 'Đã cập nhật dữ liệu.');
      await _taiDuLieu();
    } catch (loi) {
      if (!mounted) return;
      ThongBao.loi(context, loi);
    }
  }

  /// Xử lý xoá bản ghi.
  Future<void> _xoaBanGhi(Map<String, dynamic> banGhi) async {
    final dongY = await ThongBao.xacNhan(
      context,
      tieuDe: 'Xoá dữ liệu',
      noiDung: 'Bạn có chắc muốn xoá bản ghi này không?',
    );

    if (!dongY) return;

    try {
      await _dichVuDuLieu.xoaBanGhi(
        bang: widget.bang,
        id: banGhi[widget.khoaChinh],
        khoaChinh: widget.khoaChinh,
      );

      if (!mounted) return;
      ThongBao.thanhCong(context, 'Đã xoá dữ liệu.');
      await _taiDuLieu();
    } catch (loi) {
      if (!mounted) return;
      ThongBao.loi(context, loi);
    }
  }

  /// Xây dựng bảng hiển thị trên màn hình lớn.
  Widget _xayDungBang(List<Map<String, dynamic>> duLieu) {
    final cotHienThi =
        widget.danhSachCot.where((cot) => cot.hienThi).toList(growable: false);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            ...cotHienThi.map(
              (cot) => DataColumn(label: Text(cot.nhan)),
            ),
            const DataColumn(label: Text('Tác vụ')),
          ],
          rows: duLieu.map((dong) {
            return DataRow(
              cells: [
                ...cotHienThi.map((cot) {
                  final giaTri = _layGiaTri(dong, cot.tenTruong);
                  return DataCell(
                    Align(
                      alignment: cot.canGiua
                          ? Alignment.center
                          : Alignment.centerLeft,
                      child: SizedBox(
                        width: 180,
                        child: Text(
                          _chuyenThanhChuoi(giaTri, cot, dong),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  );
                }),
                DataCell(
                  Wrap(
                    spacing: 8,
                    children: [
                      if (widget.duocSua)
                        IconButton.filledTonal(
                          tooltip: 'Sửa',
                          onPressed: () => _suaBanGhi(dong),
                          icon: const Icon(Icons.edit_outlined),
                        ),
                      if (widget.duocXoa)
                        IconButton.filledTonal(
                          tooltip: 'Xoá',
                          onPressed: () => _xoaBanGhi(dong),
                          icon: const Icon(Icons.delete_outline),
                        ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  /// Xây dựng giao diện dạng thẻ trên màn hình nhỏ.
  Widget _xayDungDanhSachThe(List<Map<String, dynamic>> duLieu) {
    final cotHienThi =
        widget.danhSachCot.where((cot) => cot.hienThi).toList(growable: false);

    return Column(
      children: duLieu.map((dong) {
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...cotHienThi.map((cot) {
                final giaTri = _layGiaTri(dong, cot.tenTruong);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: [
                        TextSpan(
                          text: '${cot.nhan}: ',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        TextSpan(text: _chuyenThanhChuoi(giaTri, cot, dong)),
                      ],
                    ),
                  ),
                );
              }),
              const Divider(height: 26),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  if (widget.duocSua)
                    FilledButton.tonalIcon(
                      onPressed: () => _suaBanGhi(dong),
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('Sửa'),
                    ),
                  if (widget.duocXoa)
                    FilledButton.tonalIcon(
                      onPressed: () => _xoaBanGhi(dong),
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Xoá'),
                    ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final duLieuSauLoc = _duLieuSauLoc;

    return KhungTrangHienDai(
      tieuDe: widget.tieuDe,
      moTa: widget.moTa,
      hanhDong: [
        FilledButton.icon(
          onPressed: _taiDuLieu,
          icon: const Icon(Icons.refresh),
          label: const Text('Tải lại'),
        ),
        if (widget.duocThem)
          FilledButton.icon(
            onPressed: _themBanGhi,
            icon: const Icon(Icons.add),
            label: Text(widget.tieuDeNutThem),
          ),
      ],
      noiDung: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _timKiemController,
            onChanged: (value) => setState(() => _tuKhoa = value),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Nhập từ khoá để tìm nhanh...',
              suffixIcon: _tuKhoa.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () {
                        _timKiemController.clear();
                        setState(() => _tuKhoa = '');
                      },
                      icon: const Icon(Icons.close),
                    ),
            ),
          ),
          const SizedBox(height: 18),
          if (_dangTai)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(),
              ),
            )
          else if (duLieuSauLoc.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
              child: const Text(
                'Chưa có dữ liệu phù hợp để hiển thị.',
                textAlign: TextAlign.center,
              ),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 900) {
                  return _xayDungDanhSachThe(duLieuSauLoc);
                }
                return _xayDungBang(duLieuSauLoc);
              },
            ),
        ],
      ),
    );
  }
}
