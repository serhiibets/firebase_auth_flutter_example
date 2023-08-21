import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget cupertinoEmailTextFormField(
  BuildContext context,
  TextEditingController controller,
) {
  return CupertinoTextFormFieldRow(
    controller: controller,
    cursorColor: Theme.of(context).colorScheme.secondary,
    textInputAction: TextInputAction.done,
    keyboardType: TextInputType.text,
    autofocus: true,
    placeholder: "Email",
    decoration: BoxDecoration(
        border: Border.all(
            color: Theme.of(context).colorScheme.background, width: 1),
        borderRadius: BorderRadius.circular(10)),
    placeholderStyle:
        TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.secondary),
    autovalidateMode: AutovalidateMode.onUserInteraction,
    validator: (email) => email != null && !EmailValidator.validate(email)
        ? 'Enter a valid email'
        : null,
  );
}

Widget cupertinoPasswordTextFormField(
  BuildContext context,
  TextEditingController controller,
) {
  return CupertinoTextFormFieldRow(
    controller: controller,
    cursorColor: Theme.of(context).colorScheme.secondary,
    textInputAction: TextInputAction.done,
    keyboardType: TextInputType.text,
    autofocus: true,
    obscureText: true,
    placeholder: "Password",
    decoration: BoxDecoration(
        border: Border.all(
            color: Theme.of(context).colorScheme.background, width: 1),
        borderRadius: BorderRadius.circular(10)),
    placeholderStyle:
        TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.secondary),
    autovalidateMode: AutovalidateMode.onUserInteraction,
    validator: (value) =>
        (value) != null && (value.length < 8) ? 'Enter min 8 characters' : null,
  );
}

Widget cupertinoConfirmPasswordTextFormField(
  BuildContext context,
  TextEditingController controller,
) {
  return CupertinoTextFormFieldRow(
    controller: controller,
    cursorColor: Theme.of(context).colorScheme.secondary,
    textInputAction: TextInputAction.done,
    keyboardType: TextInputType.text,
    obscureText: true,
    autofocus: true,
    placeholder: "Confirm Password",
    decoration: BoxDecoration(
        border: Border.all(
            color: Theme.of(context).colorScheme.background, width: 1),
        borderRadius: BorderRadius.circular(10)),
    placeholderStyle:
        TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.secondary),
    autovalidateMode: AutovalidateMode.onUserInteraction,
    validator: (value) =>
        (value) != null && (value.length < 8) ? 'Passwords missmatch!' : null,
  );
}

Widget cupertinoButton(Function()? onPressed, String text) {
  return CupertinoButton.filled(
      onPressed: onPressed,
      borderRadius: BorderRadius.circular(100),
      minSize: 30,
      alignment: Alignment.center,
      child: Text(text, style: const TextStyle(fontSize: 24)));
}

Widget cupertinoText(String text) {
  return Text(
    text,
    textAlign: TextAlign.center,
    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
  );
}
