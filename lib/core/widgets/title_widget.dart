// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_task/core/utils/app_colors.dart';
// import 'package:flutter_task/core/widgets/widgets.dart';
// class TitleWidget extends StatelessWidget {
//   const TitleWidget({super.key, this.onTap, required this.title,  this.fontWeight = FontWeight.w400});
//
//   final VoidCallback? onTap;
//   final String title;
//   final FontWeight fontWeight;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16.w),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           CustomText(
//             fontSize: 16.sp,
//             text: title,
//             color: AppColors.color444444,
//             fontWeight: fontWeight,
//           ),
//           if (onTap != null)
//           GestureDetector(
//             onTap: onTap,
//             child: CustomText(
//               fontSize: 14.sp,
//               text: 'See All',
//               color: AppColors.color6F6F70,
//               fontWeight: fontWeight,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
