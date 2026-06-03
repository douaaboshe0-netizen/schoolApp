import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../controllers/profile_controller.dart';
import '../models/student_info.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Uint8List? _imageBytes;
  final picker = ImagePicker();

  
  final controller = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();
    _loadSavedImage();

    
  }

  Future<void> _loadSavedImage() async {
    final prefs = await SharedPreferences.getInstance();
    final base64 = prefs.getString('profileImageBytes');
    if (base64 != null) {
      setState(() {
        _imageBytes = Uint8List.fromList(base64.codeUnits);
      });
    }
  }

  Future<void> _pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profileImageBytes', String.fromCharCodes(bytes));
      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  Future<void> _removeImage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('profileImageBytes');
    setState(() {
      _imageBytes = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final cardColor = theme.cardColor;
    final shadowColor = theme.brightness == Brightness.dark
        ? Colors.black26
        : Colors.grey.shade300;

    return Drawer(
      child: GetBuilder<ProfileController>(
        builder: (_) {
          final student = controller.student;
          if (student == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 16),
                    Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 48,
                              backgroundColor: Colors.grey.shade300,
                              backgroundImage: _imageBytes != null
                                  ? MemoryImage(_imageBytes!)
                                  : const AssetImage('images/profile.jpg'),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: _pickImage,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.edit,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (_imageBytes != null)
                          Center(
                            child: TextButton(
                              onPressed: _removeImage,
                              child: const Text(
                                'حذف الصورة',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 135, 43, 22),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'اسم الطالب: ${student.firstName ?? ''} ${student.lastName ?? ''}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildIdRow(context, textColor, student),
                    const SizedBox(height: 24),
                    _buildInfoSection(
                      context,
                      textColor,
                      cardColor,
                      shadowColor,
                      student,
                    ),
                    const SizedBox(height: 12),
                    _buildLogoutButton(
                      context,
                      cardColor,
                      textColor,
                      shadowColor,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              if (controller.isLogoutVisible)
                _buildLogoutOverlay(context, cardColor, textColor),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      color: Colors.green[700],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const Text(
            'الملف الشخصي',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdRow(BuildContext context, Color textColor, student) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'ID: ${student.id ?? ''}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
        const SizedBox(width: 12),
        IconButton(
          icon: Icon(Icons.share, color: Colors.grey[700]),
          onPressed: () {
            final s = controller.student; 
            final message =
                '''
📌 معلومات الطالب:

الاسم الكامل: ${s?.firstName ?? ''} ${s?.lastName ?? ''}
الرقم التعريفي: ${s?.registrationNumber ?? ''}
الرقم المدني: ${s?.civilRegistryNumber ?? ''}
اسم الأب: ${s?.fatherName ?? ''}
وظيفة الأب: ${s?.fatherJob ?? ''}
اسم الأم: ${s?.motherName ?? ''}
اسم الجد: ${s?.grandFatherName ?? ''}
المواليد: ${s?.dateOfBirth ?? ''}
مكان الولادة: ${s?.birthPlace ?? ''}
مكان القيد المدني: ${s?.civilRegistryPlace ?? ''}
الجنسية: ${s?.nationality ?? ''}
تاريخ الانتساب للمدرسة: ${s?.schoolEnrollmentDate ?? ''}
''';

            Share.share(message);
          },
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.qr_code, color: Colors.green),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                contentPadding: const EdgeInsets.all(16),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'مشاركة التطبيق',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: SizedBox(
                        width: 200,
                        height: 200,
                        child: QrImageView(
                          data: 'https://abdalkader.onrender.com/app.apk',
                          version: QrVersions.auto,
                        ),
                      ),
                    ),
                  ],
                ),
                actionsAlignment: MainAxisAlignment.center,
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('إغلاق'),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
Widget _buildInfoSection(
  BuildContext context,
  Color textColor,
  Color cardColor,
  Color shadowColor,
  StudentInfo student,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Container(
      decoration: BoxDecoration(
        color: cardColor,
        boxShadow: [BoxShadow(color: shadowColor, blurRadius: 6)],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: controller.toggleExpanded,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AnimatedRotation(
                    turns: controller.isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.keyboard_arrow_down, size: 28),
                  ),
                  Text(
                    'المعلومات الشخصية',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (controller.isExpanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(height: 12),

                  _infoLine(context, 'الرقم التسجيلي: ${student.registrationNumber}'),
                  _infoLine(context, 'الرقم المدني: ${student.civilRegistryNumber}'),
                  _infoLine(context, 'اسم الأب: ${student.fatherName}'),
                  _infoLine(context, 'وظيفة الأب: ${student.fatherJob}'),
                  _infoLine(context, 'اسم الأم: ${student.motherName}'),
                  _infoLine(context, 'اسم الجد: ${student.grandFatherName}'),
                  _infoLine(context, 'المواليد: ${student.dateOfBirth}'),
                  _infoLine(context, 'مكان الولادة: ${student.birthPlace}'),
                  _infoLine(context, 'مكان القيد المدني: ${student.civilRegistryPlace}'),
                  _infoLine(context, 'الجنسية: ${student.nationality}'),
                  _infoLine(context, 'تاريخ الانتساب: ${student.schoolEnrollmentDate}'),

                  const SizedBox(height: 16),
                ],
              ),
            ),
        ],
      ),
    ),
  );
}
  Widget _infoLine(BuildContext context, String text) {
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          ' $text •',
          style: TextStyle(fontSize: 14, color: textColor),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(
    BuildContext context,
    Color cardColor,
    Color textColor,
    Color shadowColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: controller.showLogoutOverlay,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            boxShadow: [BoxShadow(color: shadowColor, blurRadius: 6)],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'تسجيل الخروج',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: textColor,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutOverlay(
    BuildContext context,
    Color cardColor,
    Color textColor,
  ) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.4),
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage('images/door.jpg'),
                ),
                const SizedBox(height: 12),
                Text(
                  'هل تريد تسجيل الخروج من الحساب؟',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  'ستتمكن من إعادة تسجيل الدخول بأي وقت.',
                  style: TextStyle(
                    fontSize: 13,
                    color: textColor.withOpacity(0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.remove('isLoggedIn');
                          await prefs.remove('token');
                          await prefs.remove('profileImageBytes');
                          controller.hideLogoutOverlay();
                          Get.offAllNamed('/login');
                        },
                        child: const Text('تسجيل الخروج'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.green,
                          side: const BorderSide(color: Colors.green),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: controller.hideLogoutOverlay,
                        child: const Text('إلغاء'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
