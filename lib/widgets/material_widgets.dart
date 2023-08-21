import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

Widget materialEmailTextFormField(
    BuildContext context, TextEditingController controller) {
  return TextFormField(
    controller: controller,
    cursorColor: Theme.of(context).colorScheme.secondary,
    textInputAction: TextInputAction.done,
    decoration: const InputDecoration(labelText: 'Email'),
    autovalidateMode: AutovalidateMode.onUserInteraction,
    validator: (email) => email != null && !EmailValidator.validate(email)
        ? 'Enter a valid email'
        : null,
  );
}

Widget materialPasswordTextFormField(
    BuildContext context, TextEditingController controller) {
  return TextFormField(
    controller: controller,
    cursorColor: Theme.of(context).colorScheme.secondary,
    textInputAction: TextInputAction.next,
    obscureText: true,
    decoration: const InputDecoration(labelText: 'Password'),
    autovalidateMode: AutovalidateMode.onUserInteraction,
    validator: (value) =>
        (value) != null && (value.length < 8) ? 'Enter min 8 characters' : null,
  );
}

Widget materialConfirmPasswordTextFormField(
  BuildContext context,
  TextEditingController confirmController,
  TextEditingController passwordController,
) {
  return TextFormField(
    controller: confirmController,
    cursorColor: Theme.of(context).colorScheme.secondary,
    textInputAction: TextInputAction.next,
    obscureText: true,
    decoration: const InputDecoration(labelText: 'Confirm Password'),
    autovalidateMode: AutovalidateMode.onUserInteraction,
    validator: (value) => (value) != null &&
            (value.length < 8) &&
            (value != passwordController.text)
        ? 'Passwords missmatch!'
        : null,
  );
}

Widget materialElevatedButton(
    Function()? onPressed, String text, IconData icon) {
  return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
      icon: Icon(icon, size: 32),
      label: Text(text, style: const TextStyle(fontSize: 24)),
      onPressed: onPressed);
}

Widget materialText(String text) {
  return Text(
    text,
    textAlign: TextAlign.center,
    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
  );
}
