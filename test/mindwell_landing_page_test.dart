import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_mhproj/features/landing/presentation/mindwell_landing_page.dart';

import 'helpers/widget_test_utils.dart';

void main() {
  testWidgets('shows login prompt for restricted features before navigating', (tester) async {
    var loginCalled = false;

    await pumpProviderApp(
      tester,
      MindWellLandingPage(
        onOpenBooking: () {},
        onOpenLogin: () {
          loginCalled = true;
        },
      ),
    );

    await tester.ensureVisible(find.text('AI Chatbot'));
    await tester.tap(find.text('AI Chatbot'));
    await tester.pumpAndSettle();

    expect(find.text('Login Required'), findsOneWidget);
    expect(loginCalled, isFalse);

    await tester.tap(find.text('LOGIN NOW'));
    await tester.pumpAndSettle();

    expect(loginCalled, isTrue);
  });

  testWidgets('appointments shortcut invokes booking callback', (tester) async {
    var bookingCalled = false;

    await pumpProviderApp(
      tester,
      MindWellLandingPage(
        onOpenBooking: () {
          bookingCalled = true;
        },
        onOpenLogin: () {},
      ),
    );

    await tester.ensureVisible(find.text('Appointments'));
    await tester.tap(find.text('Appointments'));
    await tester.pumpAndSettle();

    expect(bookingCalled, isTrue);
  });
}
