// platform_utils.dart

export 'platform_utils_stub.dart' // 默认导出
    if (dart.library.html) 'platform_utils_web.dart' // Web 平台
    if (dart.library.io) 'platform_utils_mobile.dart'; // 原生平台
