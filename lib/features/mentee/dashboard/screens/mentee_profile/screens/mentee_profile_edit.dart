import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../auth/controllers/auth_controller.dart';

class MenteeProfileEditScreen extends ConsumerStatefulWidget {
  const MenteeProfileEditScreen({super.key});

  @override
  ConsumerState<MenteeProfileEditScreen> createState() =>
      _MenteeProfileEditScreenState();
}

class _MenteeProfileEditScreenState
    extends ConsumerState<MenteeProfileEditScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController  = TextEditingController();
  final TextEditingController _emailController     = TextEditingController();
  final TextEditingController _phoneController     = TextEditingController();
  final TextEditingController _locationController  = TextEditingController();

  String _dialingCode    = '+1';
  String? _selectedDiscipline;

  static const _primaryBlue = Color(0xFF2D4383);

  static const _disciplines = [
    'Computer Engineering',
    'Mechanical Engineering',
    'Civil Engineering',
    'Electrical Engineering',
    'Information Technology',
    'Electronics & Communication',
    'Other',
  ];

  static const _dialingCodes = ['+1', '+91', '+44', '+61', '+971'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _prefillData());
  }

  void _prefillData() {
    final userData = ref.read(authControllerProvider).fullUserData;
    if (userData == null) return;

    _firstNameController.text = userData["first_name"]?.toString() ?? '';
    _lastNameController.text  = userData["last_name"]?.toString() ?? '';
    _emailController.text     = userData["email"]?["id"]?.toString() ?? '';
    _phoneController.text     = userData["mobile"]?["number"]?.toString() ?? '';
    _locationController.text  = userData["state"]?.toString() ?? '';
    _dialingCode = '+${userData["mobile"]?["dialing_code"]?.toString() ?? "1"}';

    final disc = userData["discipline"]?.toString();
    if (disc != null && _disciplines.contains(disc)) {
      _selectedDiscipline = disc;
    }
    setState(() {});
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFFF8F9FE),
    appBar: AppBar(
      backgroundColor: _primaryBlue,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      title: Text(
        'Edit Profile',
        style: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none, color: Colors.white),
          onPressed: () {},
        ),
      ],
    ),
    body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Blue header + overlapping avatar ─────────────
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // Blue bg strip
              Container(
                height: 80,
                width: double.infinity,
                color: _primaryBlue,
              ),
              // Avatar overlapping
              Positioned(
                top: 30,
                child: GestureDetector(
                  onTap: () {
                    // TODO: pick image
                  },
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const CircleAvatar(
                          radius: 44,
                          backgroundImage:
                              AssetImage('assets/images/logo.png'),
                        ),
                      ),
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: _primaryBlue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt,
                              color: Colors.white, size: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // spacing for overlapping avatar
          const SizedBox(height: 58),

          // ── "Tap to change photo" ─────────────────────────
          const Center(
            child: Text(
              'Tap to change photo',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ),

          const SizedBox(height: 28),

          // ── Rest of the form ──────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PERSONAL INFORMATION',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: _primaryBlue,
                  ),
                ),
                const SizedBox(height: 20),

                _buildLabel('First Name'),
                _buildTextField(controller: _firstNameController, hint: 'Arjun'),

                _buildLabel('Last Name'),
                _buildTextField(controller: _lastNameController, hint: 'Mehta'),

                _buildLabel('Email Address'),
                _buildTextField(
                  controller: _emailController,
                  hint: 'arjun.mehta@university.edu',
                  keyboardType: TextInputType.emailAddress,
                ),

                _buildLabel('Mobile Number'),
                _buildPhoneField(),

                _buildLabel('Location'),
                _buildTextField(
                  controller: _locationController,
                  hint: 'Bengaluru, India',
                ),

                _buildLabel('Discipline'),
                _buildDropdown(),

                const SizedBox(height: 32),

                // ── Save button ─────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Save',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // ── Cancel button ───────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF555555),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  // ── Helpers ─────────────────────────────────────────────────

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF1A1A2E),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF1A1A2E)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.inter(color: Colors.grey, fontSize: 14),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: _primaryBlue, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          // Dialing code dropdown
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _dialingCode,
                style: GoogleFonts.inter(
                    fontSize: 14, color: const Color(0xFF1A1A2E)),
                icon: const Icon(Icons.keyboard_arrow_down,
                    size: 18, color: Colors.grey),
                items: _dialingCodes
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _dialingCode = v);
                },
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Phone number field
          Expanded(
            child: TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF1A1A2E)),
              decoration: InputDecoration(
                hintText: '+91 98765 43210',
                hintStyle:
                    GoogleFonts.inter(color: Colors.grey, fontSize: 14),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      BorderSide(color: Colors.grey.withOpacity(0.2)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: _primaryBlue, width: 1.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _selectedDiscipline,
            hint: Text(
              'Select discipline',
              style: GoogleFonts.inter(color: Colors.grey, fontSize: 14),
            ),
            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down,
                size: 20, color: Colors.grey),
            style:
                GoogleFonts.inter(fontSize: 14, color: const Color(0xFF1A1A2E)),
            items: _disciplines
                .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                .toList(),
            onChanged: (v) => setState(() => _selectedDiscipline = v),
          ),
        ),
      ),
    );
  }
}