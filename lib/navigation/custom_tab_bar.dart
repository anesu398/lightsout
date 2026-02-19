import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lightsout/assets.dart' as app_assets;
import 'package:lightsout/models/tab_item.dart';
import 'package:rive/rive.dart' hide LinearGradient;

class CustomTabBar extends StatefulWidget {
  const CustomTabBar({Key? key, required this.onTabChange}) : super(key: key);

  final Function(int tabIndex) onTabChange;

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  final List<TabItem> _icons = TabItem.tabItemsList;

  int _selectedTab = 0;

  void _onRiveIconInit(Artboard artboard, index) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      _icons[index].stateMachine,
    );
    artboard.addController(controller!);

    _icons[index].status = controller.findInput<bool>('active') as SMIBool;
  }

  void onTabPress(int index) {
    if (_selectedTab != index) {
      setState(() {
        _selectedTab = index;
      });
      widget.onTabChange(index);

      _icons[index].status!.change(true);
      Future.delayed(const Duration(seconds: 1), () {
        _icons[index].status!.change(false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Container(
              padding: const EdgeInsets.all(6),
              constraints: const BoxConstraints(maxWidth: 768),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                color: const Color(0xE6FFFFFF),
                border: Border.all(color: const Color(0xFFE5E5EA)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x17000000),
                    blurRadius: 24,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(_icons.length, (index) {
                  final icon = _icons[index];
                  final isSelected = _selectedTab == index;

                  return Expanded(
                    key: icon.id,
                    child: CupertinoButton(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      borderRadius: BorderRadius.circular(18),
                      color:
                          isSelected ? const Color(0xFFEEF4FF) : Colors.transparent,
                      child: AnimatedOpacity(
                        opacity: isSelected ? 1 : 0.55,
                        duration: const Duration(milliseconds: 220),
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              top: -4,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 220),
                                height: 3,
                                width: isSelected ? 18 : 0,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0A84FF),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 34,
                              width: 34,
                              child: RiveAnimation.asset(
                                app_assets.iconsRiv,
                                stateMachines: [icon.stateMachine],
                                artboard: icon.artboard,
                                onInit: (artboard) {
                                  _onRiveIconInit(artboard, index);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      onPressed: () => onTabPress(index),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
