import 'package:flutter/material.dart';
import 'package:flutter_app_1/screen/info.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  String gender = "Nam";
  List<String> hobbies = [];

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final imageUrlController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  void _register() {
    if (_formKey.currentState!.validate()) {

Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => Info(
      name: nameController.text,
      imageUrl: imageUrlController.text,
      email: emailController.text,
      phone: phoneController.text,
      gender: gender,
      likeMusic: hobbies.contains("Âm nhạc"),
      likeMovie: hobbies.contains("Phim ảnh"),
      likeBook: hobbies.contains("Sách"),
    ),
  ),
);


      if (passwordController.text != confirmPasswordController.text) {
        _showMessage("Mật khẩu không khớp!");
        return;
      }

      // Nếu tất cả đều hợp lệ
      _showMessage("Đăng ký thành công!");
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Đăng ký")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  "ĐĂNG KÝ TÀI KHOẢN",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                const SizedBox(height: 20),
                _buildTextField("Họ và tên", Icons.person, nameController),
                _buildTextField("Email", Icons.email, emailController),
                _buildTextField("Số điện thoại", Icons.phone, phoneController),
                _buildPasswordField("Mật khẩu", passwordController, obscurePassword, () {
                  setState(() => obscurePassword = !obscurePassword);
                }),
                _buildPasswordField("Xác nhận mật khẩu", confirmPasswordController, obscureConfirmPassword, () {
                  setState(() => obscureConfirmPassword = !obscureConfirmPassword);
                }),
                _buildTextField("URL hình ảnh", Icons.image, imageUrlController),
                const SizedBox(height: 16),
                _buildGenderSelector(),
                const SizedBox(height: 16),
                _buildHobbiesCheckboxes(),
                const SizedBox(height: 24),
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, IconData icon, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "$hint không được để trống";
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordField(String hint, TextEditingController controller, bool obscure, VoidCallback toggle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock),
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          suffixIcon: IconButton(
            icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
            onPressed: toggle,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "$hint không được để trống";
          }
          return null;
        },
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Giới tính", style: TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: ["Nam", "Nữ", "Khác"].map((g) {
            return Expanded(
              child: RadioListTile<String>(
                title: Text(g),
                value: g,
                groupValue: gender,
                onChanged: (value) {
                  setState(() => gender = value!);
                },
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildHobbiesCheckboxes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Sở thích", style: TextStyle(fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 16,
          children: ["Âm nhạc", "Phim ảnh", "Sách"].map((hobby) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  value: hobbies.contains(hobby),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        hobbies.add(hobby);
                      } else {
                        hobbies.remove(hobby);
                      }
                    });
                  },
                ),
                Text(hobby),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.check),
            label: const Text("ĐĂNG KÝ"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: _register,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.exit_to_app),
            label: const Text("Thoát"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}
