import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Represents the state of the animated cursor.
class AnimatedCursorState {
  // Default values for state properties.
  const AnimatedCursorState({
    this.offset = Offset.zero,
    this.size = kDefaultSize,
    this.decoration = kDefaultDecoration,
  });

  // Default size for the cursor.
  static const Size kDefaultSize = Size(40, 40);

  // Default decoration for the cursor.
  static const BoxDecoration kDefaultDecoration = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(90)),
    color: Colors.black12,
  );

  // Decoration for the cursor.
  final BoxDecoration decoration;

  // Offset of the cursor.
  final Offset offset;

  // Size of the cursor.
  final Size size;
}

// Provides functionality for updating the state of the animated cursor.
class AnimatedCursorProvider extends ChangeNotifier {
  // Constructor for AnimatedCursorProvider.
  AnimatedCursorProvider();

  // Current state of the cursor.
  AnimatedCursorState state = const AnimatedCursorState();

  // Updates the position of the cursor.
  void updateCursorPosition(Offset pos) {
    state = AnimatedCursorState(offset: pos);
    notifyListeners();
  }
}

// Represents a web pointer widget with an animated cursor.
class WebPointer extends StatelessWidget {
  // Constructor for WebPointer widget.
  const WebPointer({
    Key? key,
    this.circleColor = Colors.blue,
    this.roundColor = Colors.blue,
    this.roundDuration = 100,
    this.circleDuration = 350,
    this.child,
  }) : super(key: key);

  // Color of the circle.
  final Color? circleColor;

  // Color of the round cursor.
  final Color? roundColor;

  // Duration of round cursor animation.
  final int? roundDuration;

  // Duration of circle animation.
  final int? circleDuration;

  // Child widget.
  final Widget? child;

  // Callback function for cursor update event.
  void _onCursorUpdate(PointerEvent event, BuildContext context) => context
      .read<AnimatedCursorProvider>()
      .updateCursorPosition(event.position);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AnimatedCursorProvider(),
      child: Consumer<AnimatedCursorProvider>(
        child: child ?? const SizedBox(),
        builder: (context, provider, child) {
          // Retrieve the current state of the cursor.
          final state = provider.state;
          return Stack(
            children: [
              // If a child widget is provided, display it below the cursor.
              if (child != null) child,
              // Listen for mouse hover events to update cursor position.
              Positioned.fill(
                child: MouseRegion(
                  opaque: false,
                  cursor: SystemMouseCursors.basic,
                  onHover: (e) => _onCursorUpdate(e, context),
                ),
              ),
              // Display the round cursor if the cursor is visible.
              Visibility(
                visible: state.offset != Offset.zero,
                child: AnimatedPositioned(
                  left: state.offset.dx - state.size.width / 1.8,
                  top: state.offset.dy - state.size.height / 1.8,
                  width: state.size.width,
                  height: state.size.height,
                  duration: Duration(milliseconds: roundDuration!),
                  child: IgnorePointer(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 1200),
                      curve: Curves.easeIn,
                      width: state.size.width,
                      height: state.size.height,
                      decoration: BoxDecoration(
                        // Color of the round cursor.
                        color: Colors.white,
                        border: Border.all(
                          // Color of the round cursor border.
                          color: roundColor!,
                          width: 1.5,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
              // Display the circle cursor if the cursor is visible.
              Visibility(
                visible: state.offset != Offset.zero,
                child: AnimatedPositioned(
                  left: state.offset.dx - state.size.width / 7,
                  top: state.offset.dy - state.size.height / 7.2,
                  width: 7,
                  height: 7,
                  duration: Duration(milliseconds: circleDuration!),
                  child: IgnorePointer(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 0),
                      curve: Curves.easeIn,
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        // Color of the circle cursor.
                        color: circleColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
