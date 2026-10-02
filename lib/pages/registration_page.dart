import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/user_storage.dart';
import 'user_info_page.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  // Ключ формы для validate()
  final _formKey = GlobalKey<FormState>();

  // Controller для каждого поля
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _storyController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmController = TextEditingController();

  // FocusNode для каждого поля
  final _nameFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _storyFocus = FocusNode();
  final _passFocus = FocusNode();
  final _confirmFocus = FocusNode();

  bool _hidePass = true;
  bool _hideConfirm = true;

  static final _emailRegExp =
      RegExp(r'^[A-Za-z0-9._%+\-]+@[A-Za-z0-9\-]+(\.[A-Za-z0-9\-]+)*\.[A-Za-z]{2,}$');
  static final _digitsRegExp = RegExp(r'^[0-9]+$');

  @override
  void dispose() {
    for (final c in [
      _nameController,
      _phoneController,
      _emailController,
      _storyController,
      _passController,
      _confirmController,
    ]) {
      c.dispose();
    }
    for (final f in [
      _nameFocus,
      _phoneFocus,
      _emailFocus,
      _storyFocus,
      _passFocus,
      _confirmFocus,
    ]) {
      f.dispose();
    }
    super.dispose();
  }

  // ---------- Валидаторы ----------

  String? _validateName(String? v) {
    if (v == null || v.trim().isEmpty) return 'Name is required';
    return null;
  }

  String? _validatePhone(String? v) {
    if (v == null || v.trim().isEmpty) return 'Phone number is required';
    if (!_digitsRegExp.hasMatch(v.trim())) {
      return 'Phone number must contain digits only';
    }
    return null;
  }

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    if (!_emailRegExp.hasMatch(v.trim())) return 'Enter a valid email address';
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (v.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? _validateConfirm(String? v) {
    if (v == null || v.isEmpty) return 'Please confirm your password';
    if (v != _passController.text) return 'Passwords do not match';
    return null;
  }

  // ---------- Отправка формы ----------

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    await UserStorage.save(UserData(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      story: _storyController.text.trim(),
    ));

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const UserInfoPage()),
    );
  }

  // Переход к следующему полю
  void _next(FocusNode node) => FocusScope.of(context).requestFocus(node);

  // Кнопка очистки (красная корзина) для поля
  Widget _clearButton(TextEditingController c) => IconButton(
        icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
        onPressed: () => c.clear(),
      );

  OutlineInputBorder _roundBorder(Color color, [double width = 1.5]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide(color: color, width: width),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Form'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Full Name
              TextFormField(
                controller: _nameController,
                focusNode: _nameFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => _next(_phoneFocus),
                validator: _validateName,
                decoration: InputDecoration(
                  labelText: 'Full Name *',
                  prefixIcon: const Icon(Icons.person),
                  suffixIcon: _clearButton(_nameController),
                  enabledBorder: _roundBorder(Colors.black),
                  focusedBorder: _roundBorder(Colors.black, 2),
                  errorBorder: _roundBorder(Colors.red),
                  focusedErrorBorder: _roundBorder(Colors.red, 2),
                ),
              ),
              const SizedBox(height: 14),

              // Phone Number (только цифры)
              TextFormField(
                controller: _phoneController,
                focusNode: _phoneFocus,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onFieldSubmitted: (_) => _next(_emailFocus),
                validator: _validatePhone,
                decoration: InputDecoration(
                  labelText: 'Phone Number *',
                  helperText: 'Phone format: (XXX)XXX-XXXX',
                  prefixIcon: const Icon(Icons.call),
                  suffixIcon: _clearButton(_phoneController),
                  enabledBorder: _roundBorder(Colors.black),
                  focusedBorder: _roundBorder(Colors.black, 2),
                  errorBorder: _roundBorder(Colors.red),
                  focusedErrorBorder: _roundBorder(Colors.red, 2),
                ),
              ),
              const SizedBox(height: 14),

              // Email
              TextFormField(
                controller: _emailController,
                focusNode: _emailFocus,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => _next(_storyFocus),
                validator: _validateEmail,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 20),

              // Life Story
              TextFormField(
                controller: _storyController,
                focusNode: _storyFocus,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                maxLines: 3,
                inputFormatters: [LengthLimitingTextInputFormatter(100)],
                decoration: const InputDecoration(
                  labelText: 'Life Story',
                  helperText: 'Keep it short, this is just a demo',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Password
              TextFormField(
                controller: _passController,
                focusNode: _passFocus,
                obscureText: _hidePass,
                maxLength: 8,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => _next(_confirmFocus),
                validator: _validatePassword,
                decoration: InputDecoration(
                  labelText: 'Password *',
                  prefixIcon: const Icon(Icons.security),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _hidePass ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () => setState(() => _hidePass = !_hidePass),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Confirm Password
              TextFormField(
                controller: _confirmController,
                focusNode: _confirmFocus,
                obscureText: _hideConfirm,
                maxLength: 8,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(),
                validator: _validateConfirm,
                decoration: InputDecoration(
                  labelText: 'Confirm Password *',
                  prefixIcon: const Icon(Icons.border_color),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _hideConfirm ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () =>
                        setState(() => _hideConfirm = !_hideConfirm),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Submit
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6AAB6E),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: _submit,
                  child: const Text(
                    'Submit Form',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
