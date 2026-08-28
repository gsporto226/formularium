import 'dart:typed_data';

import 'package:flutter/material.dart' hide FormFieldState;
import 'package:formularium/features/forms/_extensions/form_field_validators_extension.dart';
import 'package:formularium/features/forms/_implementations/formularium.dart';
import 'package:formularium/features/forms/_implementations/formularium_form_field.dart';
import 'package:formularium/features/forms/_implementations/formularium_mixin.dart';
import 'package:formularium/features/validators/_validators/string_validators.dart';


class Example10 extends StatefulWidget {
  const Example10({super.key});

  @override
  State<Example10> createState() => _Example10State();
}

class _Example10State extends State<Example10> {
  late final _nameController = TextEditingController();
  late final _emailController = TextEditingController();

  late final nameField = FormulariumFormField<String, String>(
    initialValue: '',
    validator: StringValidators.instance.notEmpty().error(),
    enabled: true,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    focusNode: null,
  );

  late final emailField = FormulariumFormField<String, String>(
    initialValue: '',
    validator: StringValidators.instance.isEmail().error(),
    enabled: true,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    focusNode: null,
  );

  late final Formularium<({String email, String name})> form = Formularium.form2(
    first: nameField,
    second: emailField,
    valueCombiner: (String name, String email) => (name: name, email: email),
  );

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('10 - Formulário Completo')),
    body: const SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        
      ),
    ),
  );
}

sealed class UserDocumentation {}

class CPFDocumentation extends UserDocumentation {
  CPFDocumentation({required this.cpf, required this.frontImage, required this.backImage});

  final String cpf;
  final Uint8List frontImage;
  final Uint8List backImage;
}

class CNPJDocumentation extends UserDocumentation {
  CNPJDocumentation({required this.cnpj});

  final String cnpj;
}

class UserAddressData {
  UserAddressData({
    required this.zipCode,
    required this.countryCode,
    required this.stateCode,
    required this.cityCode,
    required this.block,
    required this.street,
    required this.number,
    required this.extra,
  });

  final String zipCode;
  final String countryCode;
  final String stateCode;
  final String cityCode;
  final String block;
  final String street;
  final String number;
  final String? extra;
}

class UserFormData {
  UserFormData({
    required this.name,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.documentation,
    required this.address,
  });

  final String name;
  final String email;
  final String password;
  final String phoneNumber;
  final UserDocumentation documentation;
  final UserAddressData address;
}

class CardData {
  CardData({
    required this.cardCode,
    required this.cardOwnerName,
    required this.validThroughDate,
    required this.securityCode,
  });

  final String cardCode;
  final String cardOwnerName;
  final DateTime validThroughDate;
  final int securityCode;
}

class CarData {
  CarData({required this.model});

  final String model;
}

class FormData {
  FormData({required this.user, required this.card, required this.car});

  final UserFormData user;
  final CardData card;
  final CarData car;
}

class ExampleForm10 with FormulariumMixin<FormData> {
  @override
  late final Formularium<FormData> formularium;
}
