import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/navigation.dart';
import 'package:shared/utils/handle_url.dart';
import 'package:shared/widgets/sid_image.dart';
import 'package:shared/controllers/bottom_navigator_controller.dart';
import '../enums/navigation_type.dart';
import '../utils/platform_utils.dart';

final _logger = Logger();

class FloatingButton extends StatefulWidget {
  final NavigationType type;

  const FloatingButton({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  State<FloatingButton> createState() => _FloatingButtonState();
}

class _FloatingButtonState extends State<FloatingButton> {
  late final BottomNavigatorController _bottomNavigatorController;
  final bool _isStandalone = isInStandaloneMode();
  bool _isVisible = true;
  Navigation? _fabLinkData;

  Offset _position = Offset.zero; // 初始位置
  late Size _screenSize;

  @override
  void initState() {
    super.initState();
    _initializeController();

    // 在首次渲染后获取屏幕尺寸并设置初始位置
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _screenSize = MediaQuery.of(context).size;
        _position = Offset(
          _screenSize.width > 800 ? 800 - 85 : _screenSize.width - 85,
          _screenSize.height - 250,
        );
      });
    });
  }

  void _initializeController() {
    _bottomNavigatorController = Get.find<BottomNavigatorController>();
    _bottomNavigatorController.fetchFabData(widget.type);
  }

  @override
  void dispose() {
    _bottomNavigatorController.dispose();
    super.dispose();
  }

  void _handleFabPress(String path) {
    final parsedUrl = Uri.parse(path);

    if (_isHttpUrl(path)) {
      handleHttpUrl(path);
    } else if (_hasDepositType(parsedUrl)) {
      handleGameDepositType(context, path);
    } else if (_hasDefaultScreenKey(parsedUrl)) {
      handleDefaultScreenKey(context, path);
    } else {
      handlePathWithId(context, path);
    }
  }

  bool _isHttpUrl(String path) =>
      path.startsWith('http://') ||
      path.startsWith('https://') ||
      path.startsWith('*');

  bool _hasDepositType(Uri parsedUrl) =>
      parsedUrl.queryParameters.containsKey('depositType');

  bool _hasDefaultScreenKey(Uri parsedUrl) =>
      parsedUrl.queryParameters.containsKey('defaultScreenKey');

  void _hideFab() {
    setState(() => _isVisible = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isStandalone || !_isVisible) {
      return const SizedBox.shrink();
    }

    return Obx(() {
      if (!_shouldShowFab()) {
        return const SizedBox.shrink();
      }

      _fabLinkData = _bottomNavigatorController.fabLink[0];

      return Positioned(
        left: _position.dx,
        top: _position.dy,
        child: GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              _position += details.delta;
              _position = Offset(
                _position.dx.clamp(0.0, _screenSize.width - 70),
                _position.dy.clamp(0.0, _screenSize.height - 100),
              );
            });
          },
          child: _buildFabWithCloseButton(),
        ),
      );
    });
  }

  bool _shouldShowFab() {
    final isActiveKeyExists =
        _bottomNavigatorController.activeKey.value.isNotEmpty;
    final isHomePage = isActiveKeyExists &&
        _bottomNavigatorController
            .isHome(_bottomNavigatorController.activeKey.value);
    final hasFabLink = _bottomNavigatorController.fabLink.isNotEmpty;

    final isNotH5PromotionDownload =
        widget.type != NavigationType.h5PromotionDownload;
    final isH5PromotionDownloadOnWeb =
        widget.type == NavigationType.h5PromotionDownload && kIsWeb;

    return (isHomePage && hasFabLink) &&
        (isNotH5PromotionDownload || isH5PromotionDownloadOnWeb);
  }

  Widget _buildFabWithCloseButton() {
    return SizedBox(
      height: 100,
      width: 70,
      child: Stack(
        fit: StackFit.expand,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.transparent,
            elevation: 0,
            onPressed: () => _handleFabPress(_fabLinkData!.path!),
            child: Container(
              margin: const EdgeInsets.only(top: 4),
              child: SidImage(
                key: ValueKey(_fabLinkData!.id),
                sid: _fabLinkData!.photoSid!,
                width: 65,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 10,
            child: GestureDetector(
              onTap: _hideFab,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.white60,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  size: 12,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
