import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:_new/main.dart';

void main() {
  testWidgets('Test HomePage Widget', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester
        .pumpWidget(const MyApp()); // Replace MyApp with your app's root widget

    // Navigate to HomePage
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Verify the initial state of the DataTable.
    expect(find.text('Persons Table'), findsOneWidget);
    expect(find.byType(DataTable), findsOneWidget);

    // Verify if the add button is present
    expect(find.byIcon(Icons.add), findsOneWidget);

    // Verify if the DataTable is empty
    expect(find.byType(DataRow), findsNothing);

    // Add a person to the DataTable
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Enter the person details and add
    await tester.enterText(find.byType(TextFormField).first, 'John Doe');
    await tester.enterText(find.byType(TextFormField).at(1), '30');
    await tester.tap(find.text('A+'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('A-').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Verify if the DataTable has one row now
    expect(find.byType(DataRow), findsOneWidget);

    // Edit the added person
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();

    // Change the person details and save
    await tester.enterText(find.byType(TextFormField).first, 'John Smith');
    await tester.enterText(find.byType(TextFormField).at(1), '35');
    await tester.tap(find.text('A-'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('A+').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(TextButton).last);
    await tester.pumpAndSettle();

    // Verify if the person details are updated in the DataTable
    expect(find.text('John Smith'), findsOneWidget);
    expect(find.text('35'), findsOneWidget);
    expect(find.text('A+'), findsOneWidget);

    // Delete the added person
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();

    // Confirm the delete action
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    // Verify if the DataTable is empty again
    expect(find.byType(DataRow), findsNothing);
  });
}
