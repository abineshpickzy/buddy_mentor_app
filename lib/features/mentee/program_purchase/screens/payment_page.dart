
import 'package:buddymentor/features/mentee/program_purchase/controllers/program_selection_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/program_overview_controller.dart';

class PaymentPage extends ConsumerStatefulWidget {
  final String programId;
  final String programTitle;
  final String programPrice;
  final String productId;
  final int productType;
  
  const PaymentPage({
    super.key,
    required this.programId,
    required this.programTitle,
    required this.programPrice,
    required this.productId,
    required this.productType,
  });

  @override
  ConsumerState<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends ConsumerState<PaymentPage> {

  String selectedMethod = "Net Banking";
  String paymentMethod = "UPI";
  bool isProcessing = false;

  Future<void> _handlePayment() async {
    if (isProcessing) return;
    
    setState(() {
      isProcessing = true;
    });

    try {
      // Call enrollment API
      final success = await ref.read(programOverviewProvider.notifier).enrollProgram(widget.programId,widget.productId,widget.productType);
      
      if (success && mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment successful! Program enrolled.'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Fetch program data and navigate to dashboard
           ref
                                .read(selectedProgramProvider.notifier)
                                .selectProgram(
                                  programId: widget.programId,
                                  productId: widget.productId,
                                  productType: widget.productType,
                                  isFreeTrial: false
                                );

        if (mounted) {
          context.go('/menteedashboard');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 100,
        automaticallyImplyLeading: false,
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo.png', height: 28),
                const SizedBox(width: 8),
                Text(
                  "Buddy Mentor",
                  style: GoogleFonts.inter(
                    color: const Color(0xFF1A237E),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.chrome_reader_mode_outlined, color: Colors.grey, size: 20),
                const SizedBox(width: 8),
                Text("Payment", style: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                const Spacer(),
                const Icon(Icons.search, color: Colors.grey, size: 22),
                const SizedBox(width: 15),
                const Badge(
                  backgroundColor: Colors.amber,
                  child: Icon(Icons.notifications_none, color: Colors.grey, size: 22),
                ),
                const SizedBox(width: 15),
                const CircleAvatar(
                  radius: 14,
                  backgroundColor: Color(0xFF3F51B5),
                  child: Icon(Icons.person, size: 18, color: Colors.white),
                )
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.grey, size: 20),
              label: Text("Back", style: GoogleFonts.inter(color: Colors.grey, fontSize: 16)),
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
            ),
            const SizedBox(height: 10),

            /// Order Summary Card
            _buildCard(
              title: "Order Summary",
              child: Column(
                children: [
                  _summaryRow(widget.programTitle, "₹ 12000.00"),
                  const Divider(),
                  _summaryRow("GST (18%)", "₹ 0.00"),
                  const Divider(),
                  _summaryRow("Total", "₹ 12000.00", isBold: true),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// Payment Method Card
            _buildCard(
              title: "Payment Method",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _paymentTile(Icons.phone_android_outlined, "UPI", paymentMethod=="UPI"),
                      _paymentTile(Icons.credit_card_outlined, "Card", paymentMethod=="Card"),
                      _paymentTile(Icons.smartphone, "Net Banking", paymentMethod=="Net Banking"),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text("Select Bank", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: "State Bank of India",
                        items: ["State Bank of India", "HDFC Bank", "ICICI Bank"].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: GoogleFonts.inter(color: Colors.grey)),
                          );
                        }).toList(),
                        onChanged: (_) {},
                      ),
                    ),
                  )
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            
            /// Pay Button
  
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A237E),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: isProcessing ? null : _handlePayment,
                      child: isProcessing 
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text("Proceed to Pay ₹ 12000.00", style: GoogleFonts.inter(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
        
            
            const SizedBox(height: 20),
            
            /// Footer Security
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shield_outlined, color: Colors.grey.shade400, size: 18),
                const SizedBox(width: 4),
                Text("256-bit SSL", style: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 12)),
                const SizedBox(width: 15),
                Icon(Icons.lock_outline, color: Colors.grey.shade400, size: 18),
                const SizedBox(width: 4),
                Text("PCI Compliant", style: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.inter(color: isBold ? Colors.black : Colors.grey, fontSize: 14, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: isBold ? 16 : 14)),
        ],
      ),
    );
  }

  Widget _paymentTile(IconData icon, String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          paymentMethod = label;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.25,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8EAF6) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? const Color(0xFF3F51B5) : Colors.transparent),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? const Color(0xFF3F51B5) : Colors.grey),
            const SizedBox(height: 8),
            Text(label, style: GoogleFonts.inter(color: isSelected ? const Color(0xFF3F51B5) : Colors.grey, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}