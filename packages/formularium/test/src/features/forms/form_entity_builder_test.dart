import 'package:flutter/material.dart' hide FormFieldState;
import 'package:flutter_test/flutter_test.dart';
import 'package:formularium/features/forms/_data_types/form_field_state.dart';
import 'package:formularium/features/forms/_data_types/form_field_status.dart';
import 'package:formularium/features/forms/_interfaces/form_entity_interface.dart';
import 'package:formularium/features/forms/_widgets/form_entity_builder.dart';

class _TestEntity implements IFormEntity<String> {
  _TestEntity({
    FormFieldStatus<String> status = const Pending(),
    FormFieldState state = FormFieldState.pure,
    bool enabled = true,
  }) : $status = ValueNotifier(status),
       $state = ValueNotifier(state),
       $enabled = ValueNotifier(enabled);
  @override
  final ValueNotifier<FormFieldStatus<String>> $status;
  @override
  final ValueNotifier<FormFieldState> $state;
  @override
  final ValueNotifier<bool> $enabled;

  @override
  FormFieldStatus<String> get status => $status.value;

  @override
  FormFieldState get state => $state.value;

  @override
  bool get enabled => $enabled.value;

  @override
  set enabled(bool value) => $enabled.value = value;

  @override
  FormFieldStatus<String> validate() => $status.value;

  @override
  FormFieldStatus<String> validateDirty() => validate();

  @override
  void reset() {}

  @override
  void clear() {}
}

void main() {
  group('FormEntityBuilder', () {
    testWidgets('should build with initial values', (tester) async {
      final entity = _TestEntity();
      bool? capturedEnabled;

      await tester.pumpWidget(
        MaterialApp(
          home: FormEntityBuilder<String>(
            entity: entity,
            builder: (context, entity, enabled, state, status, child) {
              capturedEnabled = enabled;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(capturedEnabled, true);
    });

    testWidgets('should rebuild when enabled changes', (tester) async {
      final entity = _TestEntity();
      int buildCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: FormEntityBuilder<String>(
            entity: entity,
            builder: (context, entity, enabled, state, status, child) {
              buildCount++;
              return Text(enabled ? 'enabled' : 'disabled');
            },
          ),
        ),
      );

      expect(buildCount, 1);
      expect(find.text('enabled'), findsOneWidget);

      entity.enabled = false;
      await tester.pump();
      expect(buildCount, 2);
      expect(find.text('disabled'), findsOneWidget);
    });

    testWidgets('should rebuild when status changes', (tester) async {
      final entity = _TestEntity();
      int buildCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: FormEntityBuilder<String>(
            entity: entity,
            builder: (context, entity, enabled, state, status, child) {
              buildCount++;
              return Text(status is Valid ? 'Valid' : 'Other');
            },
          ),
        ),
      );

      expect(buildCount, 1);
      expect(find.text('Other'), findsOneWidget);

      entity.$status.value = const Valid<String>(transformed: 'ok');
      await tester.pump();
      expect(buildCount, 2);
      expect(find.text('Valid'), findsOneWidget);
    });

    testWidgets('should rebuild when state changes', (tester) async {
      final entity = _TestEntity();
      int buildCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: FormEntityBuilder<String>(
            entity: entity,
            builder: (context, entity, enabled, state, status, child) {
              buildCount++;
              return Text(state == FormFieldState.dirty ? 'dirty' : 'pure');
            },
          ),
        ),
      );

      expect(buildCount, 1);

      entity.$state.value = FormFieldState.dirty;
      await tester.pump();
      expect(buildCount, 2);
      expect(find.text('dirty'), findsOneWidget);
    });

    testWidgets('should pass child widget', (tester) async {
      final entity = _TestEntity();
      Widget? capturedChild;

      await tester.pumpWidget(
        MaterialApp(
          home: FormEntityBuilder<String>(
            entity: entity,
            builder: (context, entity, enabled, state, status, child) {
              capturedChild = child;
              return const SizedBox();
            },
            child: const Text('child'),
          ),
        ),
      );

      expect(capturedChild, isA<Text>());
      expect((capturedChild! as Text).data, 'child');
    });
  });
}
