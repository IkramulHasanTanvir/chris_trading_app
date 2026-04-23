import 'package:flutter/material.dart';
import 'package:flutter_task/core/helpers/time_format.dart';
import 'package:flutter_task/features/referral/data/model/withdrawal_model.dart';

class WithdrawalCard extends StatelessWidget {
  final WithdrawalModel data;

  const WithdrawalCard({super.key, required this.data});

  Color _getStatusColor() {
    switch (data.status.toUpperCase()) {
      case 'PENDING':
        return Colors.orange;
      case 'APPROVED':
        return Colors.green;
      case 'REJECTED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Amount + Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "৳ ${data.amount}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    data.status,
                    style: TextStyle(
                      color: _getStatusColor(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            /// Method
            Text(
              "Method: ${data.paymentMethod}",
              style: const TextStyle(fontSize: 14),
            ),

            const SizedBox(height: 4),

            /// Details
            Text(
              "Details: ${data.paymentDetails}",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 6),

            /// Admin Note
            if (data.adminNote.isNotEmpty)
              Text(
                "Note: ${data.adminNote}",
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.blueGrey,
                ),
              ),

            const Divider(height: 16),

            /// Created Date
            Text(
              "Date: ${TimeFormatHelper.formatDate(data.createdAt)}",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
