import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnimatedCursorState {
  const AnimatedCursorState({
    this.offset = Offset.zero,
    this.size = kDefaultSize,
    this.decoration = kDefaultDecoration,
  });

  static const Size kDefaultSize = Size(40, 40);
  static const BoxDecoration kDefaultDecoration = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(90)),
    color: Colors.black12,
  );
  final BoxDecoration decoration;
  final Offset offset;
  final Size size;
}

class AnimatedCursorProvider extends ChangeNotifier {
  AnimatedCursorProvider();

  AnimatedCursorState state = const AnimatedCursorState();

  void updateCursorPosition(Offset pos) {
    state = AnimatedCursorState(offset: pos);
    notifyListeners();
  }
}

class WebPointer extends StatelessWidget {
  const WebPointer({
    Key? key,
    this.circleColor = Colors.blue,
    this.roundColor = Colors.blue,
    this.roundDuration = 100,
    this.circleDuration = 350,
    this.child,
  }) : super(key: key);
  final Color? circleColor;
  final Color? roundColor;
  final int? roundDuration;
  final int? circleDuration;
  final Widget? child;

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
          final state = provider.state;
          return Stack(
            children: [
              if (child != null) child,
              Positioned.fill(
                child: MouseRegion(
                  opaque: false,
                  cursor: SystemMouseCursors.basic,
                  onHover: (e) => _onCursorUpdate(e, context),
                ),
              ),
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
                        color: Colors.white,
                        border: Border.all(
                          color: roundColor!,
                          width: 1.5,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
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
