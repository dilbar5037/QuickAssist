import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:quickassitnew/checkout/checkout_page.dart';
import 'package:quickassitnew/constans/colors.dart';
import 'package:quickassitnew/models/feedback_model.dart';
import 'package:quickassitnew/services/booking_service.dart';
import 'package:quickassitnew/services/feedback_service.dart';
import 'package:quickassitnew/services/userservice.dart';
import 'package:quickassitnew/widgets/appbutton.dart';
import 'package:quickassitnew/widgets/apptext.dart';
import 'package:quickassitnew/widgets/mydivider.dart';
import 'package:quickassitnew/widgets/rating_widgt.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyBookings extends StatefulWidget {
  const MyBookings({Key? key}) : super(key: key);

  @override
  State<MyBookings> createState() => _MyBookingsState();
}

class _MyBookingsState extends State<MyBookings> {
  final FeedbackService _feedbackService = FeedbackService();
  String? _type;
  String? uid;
  String? name;
  String? email;
  String? phone;
  String? img;

  Future<void> getData() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    _type = pref.getString('type');
    email = pref.getString('email');
    name = pref.getString('name');
    phone = pref.getString('phone');
    uid = pref.getString('uid');
    img = pref.getString('imgurl');

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (uid == null) {
      return Scaffold(
        backgroundColor: AppColors.scaffoldColor,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(data: "My Bookings", color: Colors.white),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: BookingService().getAllBookingsForUser(uid!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: AppText(data: 'Error: ${snapshot.error}'),
                    );
                  }

                  final bookings = snapshot.data ?? [];

                  if (bookings.isEmpty) {
                    return Center(child: AppText(data: 'No bookings found.'));
                  }

                  return ListView.separated(
                    itemCount: bookings.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final booking =
                          Map<String, dynamic>.from(bookings[index]);
                      final bookingId = booking['bookingId']?.toString() ?? '';

                      return FutureBuilder<FeedbackModel?>(
                        future:
                            _feedbackService.getFeedbackForBooking(bookingId),
                        builder: (context, feedbackSnapshot) {
                          final isLoadingFeedback =
                              feedbackSnapshot.connectionState ==
                                  ConnectionState.waiting;
                          final feedback = feedbackSnapshot.data;

                          return Card(
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildBookingTile(context, booking),
                                  if (booking['status'] == 'Completed')
                                    _buildFeedbackSection(
                                      context,
                                      booking: booking,
                                      feedback: feedback,
                                      isLoading: isLoadingFeedback,
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingTile(BuildContext context, Map<String, dynamic> booking) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text('Offer: ${booking['offerTitle']}'),
      subtitle: Text('Status: ${booking['status']}'),
      trailing: booking['status'] == 'Pending'
          ? IconButton(
              onPressed: () async {
                await BookingService().cancelBooking(booking['bookingId']);
                if (mounted) {
                  setState(() {});
                }
              },
              icon: const Icon(
                Icons.cancel,
                color: Colors.red,
              ),
            )
          : SizedBox(
              width: 110,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(
                    Icons.check,
                    color: Colors.green,
                  ),
                  IconButton(
                    onPressed: () async {
                      if (booking['status'] == 'Confirmed' ||
                          booking['status'] == 'Completed') {
                        final qrCodeData = await BookingService()
                            .getQRCodeData(booking['bookingId']);
                        final userdata =
                            await UserService().getUSerById(booking['userId']);
                        if (!mounted) return;

                        if (qrCodeData != null) {
                          _showQrDialog(context, booking, qrCodeData, userdata);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('QR code data not available'),
                            ),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.qr_code),
                  )
                ],
              ),
            ),
    );
  }

  Widget _buildFeedbackSection(
    BuildContext context, {
    required Map<String, dynamic> booking,
    required FeedbackModel? feedback,
    required bool isLoading,
  }) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.only(top: 12),
        child: LinearProgressIndicator(),
      );
    }

    if (feedback == null) {
      return Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Align(
          alignment: Alignment.centerRight,
          child: AppButton(
            height: 40,
            width: 150,
            color: AppColors.btnPrimaryColor,
            onTap: () => _openFeedbackSheet(context, booking: booking),
            child: AppText(data: 'Rate Service', color: Colors.white),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your rating',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              StarRating(rating: feedback.rating),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            feedback.review.isEmpty ? 'No review added.' : feedback.review,
            style: const TextStyle(fontSize: 14),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => _openFeedbackSheet(context,
                  booking: booking, existingFeedback: feedback),
              child: const Text('Edit review'),
            ),
          ),
        ],
      ),
    );
  }

  void _openFeedbackSheet(
    BuildContext context, {
    required Map<String, dynamic> booking,
    FeedbackModel? existingFeedback,
  }) {
    final TextEditingController controller = TextEditingController(
      text: existingFeedback?.review ?? '',
    );
    double currentRating = existingFeedback?.rating ?? 5;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 24,
          ),
          child: StatefulBuilder(
            builder: (context, setSheetState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking['offerTitle'] ?? 'Service feedback',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Rate your experience'),
                  const SizedBox(height: 12),
                  Row(
                    children: List.generate(5, (index) {
                      final value = index + 1;
                      return IconButton(
                        icon: Icon(
                          value <= currentRating
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 32,
                        ),
                        onPressed: () {
                          setSheetState(() {
                            currentRating = value.toDouble();
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  const Text('Share your feedback'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: controller,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText:
                          'Describe the service quality, punctuality, etc.',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (currentRating <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please select a rating'),
                            ),
                          );
                          return;
                        }

                        try {
                          await _feedbackService.submitFeedback(
                            bookingId: booking['bookingId'].toString(),
                            shopId: booking['shopid'].toString(),
                            userId: uid!,
                            rating: currentRating,
                            review: controller.text.trim(),
                            userName: name ?? 'User',
                            userImage: img ?? '',
                            offerTitle: booking['offerTitle']?.toString() ?? '',
                          );

                          if (mounted) {
                            setState(() {});
                          }
                          if (Navigator.of(sheetContext).canPop()) {
                            Navigator.of(sheetContext).pop();
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Thanks for your feedback!')),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Failed to submit feedback: $e')),
                          );
                        }
                      },
                      child:
                          Text(existingFeedback == null ? 'Submit' : 'Update'),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    ).whenComplete(() => controller.dispose());
  }

  void _showQrDialog(
    BuildContext context,
    Map<String, dynamic> booking,
    Map<String, dynamic> qrCodeData,
    dynamic userdata,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final splitData = qrCodeData['data'].toString().split(';');
        return AlertDialog(
          content: SizedBox(
            height: 590,
            width: 200,
            child: Column(
              children: [
                AppText(data: "Your Gate Pass"),
                AppText(
                  data: "${booking['status']}",
                  size: 14,
                  color: Colors.green,
                ),
                const MyDivider(),
                QrImageView(
                  data: qrCodeData['data'] as String,
                  version: QrVersions.auto,
                  size: 200.0,
                ),
                const MyDivider(),
                AppText(
                    data: splitData.isNotEmpty ? splitData[0] : '', size: 12),
                const MyDivider(),
                AppText(
                  data: splitData.length > 1 ? splitData[1].toUpperCase() : '',
                  size: 12,
                ),
                const MyDivider(),
                AppText(
                  data: splitData.length > 2 ? splitData[2].toUpperCase() : '',
                  size: 12,
                ),
                const MyDivider(),
                AppText(
                  data: splitData.length > 3 ? splitData[3].toUpperCase() : '',
                  size: 12,
                ),
                const MyDivider(),
                AppText(
                  data: "Thank You for your Business",
                  size: 12,
                  color: Colors.teal,
                ),
                const SizedBox(height: 15),
                booking['status'] != "Completed"
                    ? AppButton(
                        height: 48,
                        width: 200,
                        color: AppColors.btnPrimaryColor,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CheckoutPage(
                                booking: booking,
                                customerData: userdata,
                              ),
                            ),
                          );
                        },
                        child: AppText(data: "Collect Payment"),
                      )
                    : AppText(data: "Work Completed"),
              ],
            ),
          ),
        );
      },
    );
  }
}
