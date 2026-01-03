import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashController extends GetxController with GetTickerProviderStateMixin {
  late AnimationController imageController;
  late Animation<double> imageScale;

  late AnimationController textController;
  late Animation<double> textFade;
  late AnimationController progressController;
  double progressValue = 0.0;
  bool showGreeting = false;

  @override
  void onInit() {
    super.onInit();

    // تحريك الصورة
    imageController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    imageScale = Tween<double>(begin: 0.7, end: 1.3).animate(
      CurvedAnimation(parent: imageController, curve: Curves.easeOutBack),
    );
    imageController.forward();

    // تحريك النص
    textController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    textFade = Tween<double>(begin: 0.0, end: 1.0).animate(textController);

    // شريط التحميل
    progressController =
        AnimationController(duration: const Duration(seconds: 3), vsync: this)
          ..addListener(() {
            progressValue = progressController.value;
            update();
          });
    progressController.forward();

    // عرض التحية فقط بدون انتقال تلقائي
    Future.delayed(const Duration(seconds: 5), () {
      showGreeting = true;
      textController.forward();
      update();
    });
  }

  @override
  void onClose() {
    imageController.dispose();
    textController.dispose();
    progressController.dispose();
    super.onClose();
  }
}
