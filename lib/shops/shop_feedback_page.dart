import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickassitnew/constans/colors.dart';
import 'package:quickassitnew/models/feedback_model.dart';
import 'package:quickassitnew/services/feedback_service.dart';
import 'package:quickassitnew/widgets/apptext.dart';
import 'package:quickassitnew/widgets/rating_widgt.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopFeedbackPage extends StatefulWidget {
  const ShopFeedbackPage({super.key});

  @override
  State<ShopFeedbackPage> createState() => _ShopFeedbackPageState();
}

class _ShopFeedbackPageState extends State<ShopFeedbackPage> {
  final FeedbackService _feedbackService = FeedbackService();
  String? _shopId;

  @override
  void initState() {
    super.initState();
    _loadShopId();
  }

  Future<void> _loadShopId() async {
    final pref = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _shopId = pref.getString('uid');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        title: AppText(data: 'Customer Feedback', color: Colors.white),
      ),
      body: _shopId == null
          ? Center(child: CircularProgressIndicator())
          : StreamBuilder<List<FeedbackModel>>(
              stream: _feedbackService.streamFeedbackForShop(_shopId!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: AppText(
                        data: 'Failed to load feedback: ${snapshot.error}'),
                  );
                }

                final feedbackList = snapshot.data ?? [];
                final average = feedbackList.isEmpty
                    ? 0.0
                    : feedbackList
                            .map((e) => e.rating)
                            .reduce((value, element) => value + element) /
                        feedbackList.length;

                if (feedbackList.isEmpty) {
                  return Center(
                    child: AppText(
                        data: 'No feedback received yet.', color: Colors.white),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: feedbackList.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _buildSummaryCard(average, feedbackList.length);
                    }
                    final feedback = feedbackList[index - 1];
                    return Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: _FeedbackCard(feedback: feedback),
                    );
                  },
                );
              },
            ),
    );
  }

  Widget _buildSummaryCard(double averageRating, int totalReviews) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Overall Rating',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  StarRating(rating: averageRating, orientation: false),
                  const SizedBox(height: 8),
                  Text(
                      '$totalReviews review${totalReviews == 1 ? '' : 's'} received'),
                ],
              ),
            ),
            Text(
              averageRating.toStringAsFixed(1),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeedbackCard extends StatelessWidget {
  const _FeedbackCard({required this.feedback});

  final FeedbackModel feedback;

  @override
  Widget build(BuildContext context) {
    final createdDate = feedback.createdAt ?? feedback.updatedAt;
    final formattedDate = createdDate == null
        ? 'Just now'
        : DateFormat('dd MMM yyyy').format(createdDate);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.contColor5.withOpacity(0.2),
                  child: Text(
                    feedback.userName.isNotEmpty
                        ? feedback.userName[0].toUpperCase()
                        : '?',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        feedback.userName,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        formattedDate,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                StarRating(rating: feedback.rating),
              ],
            ),
            const SizedBox(height: 12),
            if (feedback.offerTitle.isNotEmpty)
              Text(
                feedback.offerTitle,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            const SizedBox(height: 8),
            Text(
              feedback.review.isEmpty
                  ? 'Customer left a rating without additional comments.'
                  : feedback.review,
            ),
          ],
        ),
      ),
    );
  }
}
