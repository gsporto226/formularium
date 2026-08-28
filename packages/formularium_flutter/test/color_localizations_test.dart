import 'package:flutter_test/flutter_test.dart';
import 'package:formularium_flutter/src/color_localizations.dart';

void main() {
  tearDown(resetFfL10n);
  test('en resolves', () async {
    await initFormulariumFlutterL10n('en');
    expect(ffL10n.validation_invalid_color('red'), '"red" is not a valid color');
  });
  test('pt resolves', () async {
    await initFormulariumFlutterL10n('pt');
    expect(ffL10n.validation_invalid_color('red'), '"red" não é uma cor válida');
  });
}
