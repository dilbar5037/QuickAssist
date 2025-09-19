import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickassitnew/constans/colors.dart';
import 'package:quickassitnew/models/feedback_model.dart';
import 'package:quickassitnew/services/feedback_service.dart';
import 'package:quickassitnew/shops/confirm_assign_age.dart';
import 'package:quickassitnew/widgets/apptext.dart';
import 'package:quickassitnew/widgets/rating_widgt.dart';

class ShopBookings extends StatefulWidget {
  final String? uid;
  const ShopBookings({Key? key, this.uid}) : super(key: key);

  @override
  _ShopBookingsState createState() => _ShopBookingsState();
}

class _ShopBookingsState extends State<ShopBookings> {
  final FeedbackService _feedbackService = FeedbackService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        title: AppText(
          data: 'Shop Bookings',
          color: Colors.white,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('bookings')
              .where('shopid', isEqualTo: widget.uid.toString())
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            final bookings =
                List<QueryDocumentSnapshot<Map<String, dynamic>>>.from(
                    snapshot.data?.docs ?? []);
            bookings.sort((a, b) {
              final aCreated = a['createdAt'];
              final bCreated = b['createdAt'];
              if (aCreated is Timestamp && bCreated is Timestamp) {
                return bCreated.compareTo(aCreated);
              }
              return 0;
            });
            if (bookings.isEmpty) {
              return const _EmptyState();
            }

            return ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                final data = booking.data() as Map<String, dynamic>;
                final status = (data['status'] ?? '').toString();
                final bookingId = (data['bookingId'] ?? booking.id).toString();
                final offerTitle =
                    (data['offerTitle'] ?? data['offerId'] ?? 'Service')
                        .toString();
                final scheduledDate = data['date']?.toString();
                final scheduledTime = data['time']?.toString();

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText(
                                    data: offerTitle,
                                    fw: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Booking ID: $bookingId',
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 13,
                                    ),
                                  ),
                                  if (scheduledDate != null &&
                                      scheduledTime != null)
                                    Text(
                                      'Scheduled: $scheduledDate - $scheduledTime',
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 13,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                _StatusChip(status: status),
                                if (status == 'Pending') ...[
                                  const SizedBox(height: 8),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ConfirmAssign(
                                            booking: booking,
                                            uid: widget.uid,
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          AppColors.btnPrimaryColor,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      textStyle: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text('Assign'),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _BookingFeedbackPreview(
                          status: status,
                          bookingId: bookingId,
                          feedbackService: _feedbackService,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              size: 40,
              color: Colors.white70,
            ),
            const SizedBox(height: 12),
            AppText(
              data: 'No bookings found',
              color: Colors.white,
            ),
            const SizedBox(height: 4),
            const Text(
              'Completed bookings will appear here with customer feedback.',
              style: TextStyle(color: Colors.white70, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final normalized = status.toLowerCase();
    Color bg;
    Color fg;
    switch (normalized) {
      case 'completed':
        bg = Colors.green.withOpacity(0.15);
        fg = Colors.green.shade700;
        break;
      case 'confirmed':
        bg = Colors.blue.withOpacity(0.15);
        fg = Colors.blue.shade700;
        break;
      case 'pending':
        bg = Colors.orange.withOpacity(0.18);
        fg = Colors.orange.shade700;
        break;
      default:
        bg = Colors.grey.withOpacity(0.18);
        fg = Colors.grey.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: fg,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _BookingFeedbackPreview extends StatelessWidget {
  const _BookingFeedbackPreview({
    required this.status,
    required this.bookingId,
    required this.feedbackService,
  });

  final String status;
  final String bookingId;
  final FeedbackService feedbackService;

  @override
  Widget build(BuildContext context) {
    if (status.toLowerCase() != 'completed') {
      return const SizedBox.shrink();
    }

    return FutureBuilder<FeedbackModel?>(
      future: feedbackService.getFeedbackForBooking(bookingId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LinearProgressIndicator(minHeight: 2);
        }

        final feedback = snapshot.data;
        if (feedback == null) {
          return const SizedBox.shrink();
        }

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.contColor3.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  StarRating(rating: feedback.rating),
                  const SizedBox(width: 8),
                  Text(
                    feedback.rating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              if (feedback.review.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  feedback.review,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 13,
                    height: 1.3,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
