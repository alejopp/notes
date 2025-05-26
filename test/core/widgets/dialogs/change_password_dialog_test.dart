import 'package:bext_notes/features/profile/presentation/widgets/change_password_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChangePasswordDialog', () {
    testWidgets('Debe renderizar los campos correctamente', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(body: ChangePasswordDialog()),
      ));

      expect(find.byKey(const Key('old_password_field')), findsOneWidget);
      expect(find.byKey(const Key('new_password_field')), findsOneWidget);
      expect(find.byKey(const Key('confirm_password_field')), findsOneWidget);
      expect(find.text('Guardar'), findsOneWidget);
    });

    testWidgets('Debe mostrar errores si se dejan campos vacíos',
        (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(body: ChangePasswordDialog()),
      ));

      await tester.tap(find.text('Guardar'));
      await tester.pump();

      expect(find.text('Requerido'), findsNWidgets(3));
    });

    testWidgets(
        'Debe fallar si la nueva contraseña tiene menos de 6 caracteres',
        (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(body: ChangePasswordDialog()),
      ));

      await tester.enterText(
          find.byKey(const Key('old_password_field')), 'anterior123');
      await tester.enterText(
          find.byKey(const Key('new_password_field')), 'abc');
      await tester.enterText(
          find.byKey(const Key('confirm_password_field')), 'abc');
      await tester.tap(find.text('Guardar'));
      await tester.pump();

      expect(find.text('Debe tener al menos 6 caracteres'), findsOneWidget);
    });

    testWidgets('Debe fallar si las contraseñas nuevas no coinciden',
        (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(body: ChangePasswordDialog()),
      ));

      await tester.enterText(
          find.byKey(const Key('old_password_field')), 'anterior123');
      await tester.enterText(
          find.byKey(const Key('new_password_field')), 'nueva123');
      await tester.enterText(
          find.byKey(const Key('confirm_password_field')), 'diferente123');
      await tester.tap(find.text('Guardar'));
      await tester.pump();

      expect(find.text('Las contraseñas no coinciden'), findsOneWidget);
    });
  });
}
