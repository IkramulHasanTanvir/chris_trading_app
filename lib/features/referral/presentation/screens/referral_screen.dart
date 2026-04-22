import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/features/referral/data/model/referral_data.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

// ─── Mock Model ──────────────────────────────────────────────────────────────


// ─── Controller ──────────────────────────────────────────────────────────────
class ReferralController extends GetxController {
  final isLoading = true.obs;
  final Rx<ReferralData?> referralData = Rx<ReferralData?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchReferralData();
  }

  Future<void> fetchReferralData() async {
    try {
      isLoading(true);
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 800));

      // Mock API response
      final mockResponse = {
        "success": true,
        "message": "Referral stats retrieved",
        "data": {
          "referralCode": "REF123456",
          "referralLink": "https://tradingapp.com/signup?ref=REF123456",
          "totalReferrals": 10,
          "activeReferrals": 5,
          "totalRewards": 500.0,
        }
      };

      referralData.value = ReferralData.fromJson(mockResponse);
    } finally {
      isLoading(false);
    }
  }
}

// ─── Screen ───────────────────────────────────────────────────────────────────
class ReferralScreen extends StatelessWidget {
  const ReferralScreen({super.key});

  static const _bg = Color(0xFF0A0A0F);
  static const _surface = Color(0xFF13131A);
  static const _card = Color(0xFF1C1C27);
  static const _accent = Color(0xFF6C63FF);
  static const _accentSoft = Color(0x266C63FF);
  static const _gold = Color(0xFFFFB547);
  static const _goldSoft = Color(0x26FFB547);
  static const _text = Color(0xFFE8E8F0);
  static const _textMuted = Color(0xFF6B6B80);
  static const _divider = Color(0xFF22222E);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReferralController());

    return Scaffold(
      backgroundColor: _bg,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: _accent),
          );
        }

        final data = controller.referralData.value;
        if (data == null) {
          return const Center(
            child: Text('Failed to load', style: TextStyle(color: _textMuted)),
          );
        }

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildAppBar(),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 32.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildQRCard(data),
                    SizedBox(height: 20.h),
                    _buildStatsRow(data),
                    SizedBox(height: 20.h),
                    _buildReferralCodeCard(data),
                    SizedBox(height: 20.h),
                    _buildHowItWorks(),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  // ── AppBar ────────────────────────────────────────────────────────────────
  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 110.h,
      pinned: true,
      floating: false,
      scrolledUnderElevation: 0,
      backgroundColor: _bg,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => Get.back(),
        child: Container(
          margin: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: _divider),
          ),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: _text,
            size: 16.sp,
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(left: 20.w, bottom: 16.h),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Invite & Earn',
              style: TextStyle(
                color: _text,
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              'Share your link, grow together',
              style: TextStyle(
                color: _textMuted,
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── QR Card ───────────────────────────────────────────────────────────────
  Widget _buildQRCard(ReferralData data) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: _divider),
      ),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: _accentSoft,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.qr_code_rounded, color: _accent, size: 13.sp),
                    SizedBox(width: 4.w),
                    Text(
                      'Your QR Code',
                      style: TextStyle(
                        color: _accent,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          // QR Code
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: QrImageView(
              data: data.referralLink,
              version: QrVersions.auto,
              size: 160.r,
              backgroundColor: Colors.white,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: Color(0xFF0A0A0F),
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: Color(0xFF0A0A0F),
              ),
            ),
          ),

          SizedBox(height: 16.h),

          Text(
            'Scan to sign up with your referral',
            style: TextStyle(
              color: _textMuted,
              fontSize: 12.sp,
            ),
          ),

          SizedBox(height: 16.h),

          // Share Button
          GestureDetector(
            onTap: () {
              // Share logic
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              decoration: BoxDecoration(
                color: _accent,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.share_rounded, color: Colors.white, size: 16.sp),
                  SizedBox(width: 8.w),
                  Text(
                    'Share Referral Link',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Stats Row ─────────────────────────────────────────────────────────────
  Widget _buildStatsRow(ReferralData data) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Total Referrals',
            value: '${data.totalReferrals}',
            icon: Icons.people_outline_rounded,
            iconColor: _accent,
            iconBg: _accentSoft,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _StatCard(
            label: 'Active',
            value: '${data.activeReferrals}',
            icon: Icons.person_outline_rounded,
            iconColor: const Color(0xFF4CAF82),
            iconBg: const Color(0x264CAF82),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _StatCard(
            label: 'Rewards',
            value: '\$${data.totalRewards.toStringAsFixed(0)}',
            icon: Icons.workspace_premium_outlined,
            iconColor: _gold,
            iconBg: _goldSoft,
          ),
        ),
      ],
    );
  }

  // ── Referral Code Card ────────────────────────────────────────────────────
  Widget _buildReferralCodeCard(ReferralData data) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: _divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Referral Code',
            style: TextStyle(
              color: _textMuted,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  decoration: BoxDecoration(
                    color: _card,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: _divider),
                  ),
                  child: Text(
                    data.referralCode,
                    style: TextStyle(
                      color: _text,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: data.referralCode));
                  Get.snackbar(
                    '',
                    '',
                    titleText: const SizedBox.shrink(),
                    messageText: Text(
                      'Code copied!',
                      style: TextStyle(
                        color: _text,
                        fontSize: 13.sp,
                      ),
                    ),
                    backgroundColor: _card,
                    snackPosition: SnackPosition.BOTTOM,
                    margin: EdgeInsets.all(16.r),
                    borderRadius: 12.r,
                    duration: const Duration(seconds: 2),
                    icon: Icon(Icons.check_circle_outline, color: _accent),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(14.r),
                  decoration: BoxDecoration(
                    color: _accentSoft,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: _accent.withOpacity(0.3)),
                  ),
                  child: Icon(Icons.copy_rounded, color: _accent, size: 18.sp),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── How It Works ──────────────────────────────────────────────────────────
  Widget _buildHowItWorks() {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: _divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How it works',
            style: TextStyle(
              color: _text,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          _StepItem(
            step: '01',
            title: 'Share your link',
            subtitle: 'Send your unique code to friends',
          ),
          _buildStepDivider(),
          _StepItem(
            step: '02',
            title: 'They sign up',
            subtitle: 'Your friend creates an account',
          ),
          _buildStepDivider(),
          _StepItem(
            step: '03',
            title: 'Earn rewards',
            subtitle: 'Get credited when they go active',
          ),
        ],
      ),
    );
  }

  Widget _buildStepDivider() {
    return Padding(
      padding: EdgeInsets.only(left: 18.w),
      child: Column(
        children: [
          SizedBox(height: 4.h),
          Container(width: 1, height: 16.h, color: _divider),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }
}

// ─── Stat Card Widget ─────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;

  static const _surface = Color(0xFF13131A);
  static const _divider = Color(0xFF22222E);
  static const _text = Color(0xFFE8E8F0);
  static const _textMuted = Color(0xFF6B6B80);

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: _divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(7.r),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, color: iconColor, size: 15.sp),
          ),
          SizedBox(height: 10.h),
          Text(
            value,
            style: TextStyle(
              color: _text,
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: TextStyle(
              color: _textMuted,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Step Item Widget ─────────────────────────────────────────────────────────
class _StepItem extends StatelessWidget {
  final String step;
  final String title;
  final String subtitle;

  static const _accent = Color(0xFF6C63FF);
  static const _accentSoft = Color(0x266C63FF);
  static const _text = Color(0xFFE8E8F0);
  static const _textMuted = Color(0xFF6B6B80);

  const _StepItem({
    required this.step,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36.r,
          height: 36.r,
          decoration: BoxDecoration(
            color: _accentSoft,
            borderRadius: BorderRadius.circular(10.r),
          ),
          alignment: Alignment.center,
          child: Text(
            step,
            style: TextStyle(
              color: _accent,
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: _text,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                color: _textMuted,
                fontSize: 11.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }
}