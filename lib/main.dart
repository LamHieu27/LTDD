import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'cau_hinh/supabase_cau_hinh.dart';
import 'giao_dien/man_hinh_cho.dart';
import 'giao_dien/man_hinh_chinh.dart';
import 'giao_dien/man_hinh_dang_nhap.dart';

/// Hàm khởi động ứng dụng.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseCauHinh.url,
    anonKey: SupabaseCauHinh.anonKey,
  );

  runApp(const UngDungDangKyNhom());
}

/// Widget gốc của ứng dụng đồ án.
class UngDungDangKyNhom extends StatelessWidget {
  const UngDungDangKyNhom({super.key});

  @override
  Widget build(BuildContext context) {
    final mau = ColorScheme.fromSeed(
      seedColor: const Color(0xFF4F46E5),
      brightness: Brightness.light,
    );

    return MaterialApp(
      title: 'Đăng ký nhóm và chọn đề tài',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: mau,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF6F7FB),
        textTheme: GoogleFonts.beVietnamProTextTheme(),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: mau.outlineVariant),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: mau.outlineVariant),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: mau.primary, width: 1.4),
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
      ),
      home: const CongXacThuc(),
    );
  }
}

/// Cổng xác thực để chuyển giữa màn hình đăng nhập và giao diện chính.
class CongXacThuc extends StatelessWidget {
  const CongXacThuc({super.key});

  @override
  Widget build(BuildContext context) {
    final client = Supabase.instance.client;

    return StreamBuilder<AuthState>(
      stream: client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            client.auth.currentSession == null) {
          return const ManHinhCho(thongDiep: 'Đang kiểm tra phiên đăng nhập...');
        }

        final session = snapshot.data?.session ?? client.auth.currentSession;
        if (session == null) {
          return const ManHinhDangNhap();
        }

        return const ManHinhChinh();
      },
    );
  }
}
