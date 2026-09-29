/// Mô hình hồ sơ người dùng đang đăng nhập.
///
/// Lớp này được ánh xạ từ bảng `ho_so` trong Supabase.
class HoSoNguoiDung {
  HoSoNguoiDung({
    required this.id,
    required this.hoTen,
    required this.vaiTro,
    this.email,
    this.maSinhVien,
    this.maGiangVien,
    this.lopHanhChinh,
    this.khoa,
    this.nganh,
    this.soDienThoai,
    this.anhDaiDienUrl,
    this.dangHoatDong = true,
  });

  final String id;
  final String hoTen;
  final String vaiTro;
  final String? email;
  final String? maSinhVien;
  final String? maGiangVien;
  final String? lopHanhChinh;
  final String? khoa;
  final String? nganh;
  final String? soDienThoai;
  final String? anhDaiDienUrl;
  final bool dangHoatDong;

  /// Tạo đối tượng từ dữ liệu JSON lấy về từ Supabase.
  factory HoSoNguoiDung.tuMap(Map<String, dynamic> map) {
    return HoSoNguoiDung(
      id: (map['id'] ?? '').toString(),
      hoTen: (map['ho_ten'] ?? '').toString(),
      vaiTro: (map['vai_tro'] ?? 'sinh_vien').toString(),
      email: map['email']?.toString(),
      maSinhVien: map['ma_sinh_vien']?.toString(),
      maGiangVien: map['ma_giang_vien']?.toString(),
      lopHanhChinh: map['lop_hanh_chinh']?.toString(),
      khoa: map['khoa']?.toString(),
      nganh: map['nganh']?.toString(),
      soDienThoai: map['so_dien_thoai']?.toString(),
      anhDaiDienUrl: map['anh_dai_dien_url']?.toString(),
      dangHoatDong: map['dang_hoat_dong'] == true,
    );
  }

  /// Chuyển đối tượng sang map để gửi lên Supabase.
  Map<String, dynamic> sangMapCapNhat() {
    return {
      'ho_ten': hoTen,
      'lop_hanh_chinh': lopHanhChinh,
      'khoa': khoa,
      'nganh': nganh,
      'so_dien_thoai': soDienThoai,
      'anh_dai_dien_url': anhDaiDienUrl,
    };
  }

  /// Kiểm tra người dùng hiện tại có phải sinh viên hay không.
  bool get laSinhVien => vaiTro == 'sinh_vien';

  /// Kiểm tra người dùng hiện tại có phải giảng viên hay không.
  bool get laGiangVien => vaiTro == 'giang_vien';

  /// Kiểm tra người dùng hiện tại có phải quản trị viên hay không.
  bool get laQuanTriVien => vaiTro == 'quan_tri_vien';

  /// Trả về nhãn vai trò để hiển thị trên giao diện.
  String get nhanVaiTro {
    switch (vaiTro) {
      case 'giang_vien':
        return 'Giảng viên';
      case 'quan_tri_vien':
        return 'Quản trị viên';
      default:
        return 'Sinh viên';
    }
  }
}
