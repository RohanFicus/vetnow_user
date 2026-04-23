import 'package:flutter/material.dart';
import 'package:vetnow_user/features/auth/data/models/assessment_success_model.dart';

import 'dashboard_screen.dart';

class ResultScreen extends StatelessWidget {
  final AssessmentSuccessModel? assessmentSuccessData;

  const ResultScreen({super.key, required this.assessmentSuccessData});

  @override
  Widget build(BuildContext context) {
    print("Answers ${assessmentSuccessData?.toJson()}");

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      body: SafeArea(
        child: Column(
          children: [
            /// 🔹 Header + Avatar
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 160,
                  decoration: const BoxDecoration(
                    color: Color(0xFF3B76E1),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(120),
                    ),
                  ),
                  child: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    automaticallyImplyLeading: false,
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => MainDashboard()),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                /// Avatar
                Positioned(
                  bottom: -40,
                  child: CircleAvatar(
                    radius: 56,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 52,
                      backgroundImage: NetworkImage(
                        'https://placedog.net/500/500?id=1',
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 70),

            /// 🔹 Title
            Text(
              "${assessmentSuccessData?.pet?.name}'s Health Result",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: Text(
                assessmentSuccessData?.warningMessage?.textEn ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
            ),

            /// 🔹 White Result Card
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      /// Needs Attention Header
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.red.shade400,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              "Needs Attention",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),

                      /// Dynamic list (scrolls if needed)
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount:
                              assessmentSuccessData?.needsAttention?.length ??
                              0,
                          itemBuilder: (context, index) {
                            final item =
                                assessmentSuccessData!.needsAttention![index];
                            return _buildResultItem(
                              item.titleEn ?? '',
                              item.valueEn ?? '',
                              Colors.red.shade50,
                              Colors.red,
                            );
                          },
                        ),
                      ),

                      /// Footer (sticks to bottom of card)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: Color(0xFFB63A2B),
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(20),
                          ),
                        ),
                        child: const Text(
                          "Your pet’s health needs attention, please make sure you take a doctor appointment.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /// 🔹 Bottom Button
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B76E1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => MainDashboard()),
                    );
                  },
                  child: const Text(
                    "Next",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertCard() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red),
          SizedBox(width: 10),
          Text(
            "Needs Attention",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildResultItem(
    String title,
    String status,
    Color bg,
    Color textCol,
  ) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
              Text(status, style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          Icon(Icons.warning, color: Colors.red[200]),
        ],
      ),
    );
  }
}
