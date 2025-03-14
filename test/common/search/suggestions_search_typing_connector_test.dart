import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_typeahead/src/common/base/suggestions_controller.dart';
import 'package:flutter_typeahead/src/common/search/suggestions_search_typing_connector.dart';

void main() {
  group('SuggestionsSearchTypingConnector', () {
    late SuggestionsController controller;
    late TextEditingController textEditingController;
    late FocusNode focusNode;

    setUp(() {
      controller = SuggestionsController();
      textEditingController = TextEditingController();
      focusNode = FocusNode();
    });

    tearDown(() {
      controller.dispose();
      textEditingController.dispose();
      focusNode.dispose();
    });

    testWidgets(
        'opens the suggestions list when the text changes and the box is closed and the field does not require to be focued',
        (WidgetTester tester) async {
      controller.open();
      controller.close(retainFocus: true);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SuggestionsSearchTypingConnector(
              controller: controller,
              textEditingController: textEditingController,
              focusNode: focusNode,
              requiresFocus: false,
              child: const SizedBox(),
            ),
          ),
        ),
      );

      expect(controller.isOpen, isFalse);

      textEditingController.text = 'test';
      await tester.pump();

      expect(controller.isOpen, isTrue);
    });

    testWidgets(
        'opens the suggestions list when the text changes, the box is closed and the field requires and has focus',
        (WidgetTester tester) async {
      controller.open();
      controller.close(retainFocus: true);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SuggestionsSearchTypingConnector(
              controller: controller,
              textEditingController: textEditingController,
              focusNode: focusNode,
              requiresFocus: true,
              child: const SizedBox(),
            ),
          ),
        ),
      );

      expect(controller.isOpen, isFalse);

      textEditingController.text = 'test';

      await tester.pump();

      expect(controller.isOpen, isTrue);
    });

    testWidgets(
        'does not open the suggestions list when the text changes, the box is closed and the field requires focus but does not have it',
        (WidgetTester tester) async {
      controller.open();
      controller.close(retainFocus: false);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SuggestionsSearchTypingConnector(
              controller: controller,
              textEditingController: textEditingController,
              focusNode: focusNode,
              requiresFocus: true,
              child: const SizedBox(),
            ),
          ),
        ),
      );

      expect(controller.isOpen, isFalse);

      textEditingController.text = 'test';
      await tester.pump();

      expect(controller.isOpen, isFalse);
    });
  });
}
