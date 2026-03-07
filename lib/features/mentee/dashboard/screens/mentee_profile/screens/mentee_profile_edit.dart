import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../auth/controllers/auth_controller.dart';


class MenteeProfileEditScreen extends ConsumerStatefulWidget {
  const MenteeProfileEditScreen({super.key});

  @override
  ConsumerState<MenteeProfileEditScreen> createState() => _MenteeProfileEditScreenState();
}

class _MenteeProfileEditScreenState extends ConsumerState<MenteeProfileEditScreen> {
  // Controllers for handling input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _disciplineController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _prefillData();
    });
  }

  void _prefillData() {
    final authState = ref.read(authControllerProvider);
    final userData = authState.fullUserData;
    
    if (userData != null) {
      _nameController.text = "${userData["first_name"] ?? ""} ${userData["last_name"] ?? ""}".trim();
      _emailController.text = userData["email"]?["id"]?.toString() ?? "";
      _phoneController.text = "+${userData["mobile"]?["dialing_code"]?.toString() ?? "91"} ${userData["mobile"]?["number"]?.toString() ?? ""}";
      _disciplineController.text = userData["discipline"]?.toString() ?? "";
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _disciplineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF333333)),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          "Edit Profile",
          style: TextStyle(color: Color(0xFF333333), fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // TODO: Implement Save Logic
              context.pop();
            },
            child: const Text(
              "Save",
              style: TextStyle(color: Color(0xFF2D4383), fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Profile Photo Edit Section
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/logo.png'),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFF2D4383),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // 2. Personal Information Header
            const Text(
              "PERSONAL INFORMATION",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),

            // 3. Input Fields
            _buildTextField("Full Name", _nameController, Icons.person_outline),
            _buildTextField("Email Address", _emailController, Icons.email_outlined, keyboardType: TextInputType.emailAddress),
            _buildTextField("Phone Number", _phoneController, Icons.phone_outlined, keyboardType: TextInputType.phone),
            _buildTextField("Discipline", _disciplineController, Icons.book_outlined),
            
            const SizedBox(height: 20),

            // 4. Additional Info Note
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Color(0xFF2D4383), size: 20),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Your institution information can only be updated by contacting support.",
                      style: TextStyle(fontSize: 13, color: Color(0xFF2D4383)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label, 
    TextEditingController controller, 
    IconData icon, 
    {TextInputType keyboardType = TextInputType.text}
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF333333)),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(fontSize: 15),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: const Color(0xFF2D4383), size: 20),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF2D4383), width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}