class VTabItem {
  final int id;
  final String name;
  final String url;

  VTabItem(this.id, this.name, {this.url = ''});
  isPage() {
    return !(url.startsWith('http://') && url.startsWith('https://')) ||
        url.startsWith('internal://');
  }

  isExternal() {
    return url.startsWith('http://') && url.startsWith('https://');
  }
}

abstract class VTabCollection {
  Map<int, VTabItem> getTabs();
}

class VVideoPlayerTabs implements VTabCollection {
  @override
  Map<int, VTabItem> getTabs() {
    return {
      0: VTabItem(0, '簡介'),
      // 1: VTabItem(1, '評論'),
    };
  }
}

class VActorTabs implements VTabCollection {
  @override
  Map<int, VTabItem> getTabs() {
    return {
      0: VTabItem(0, '長視頻'),
      // 1: VTabItem(1, '短視頻'),
    };
  }
}

class VFavoriteTabs implements VTabCollection {
  @override
  Map<int, VTabItem> getTabs() {
    return {
      0: VTabItem(0, '長視頻'),
      // 1: VTabItem(1, '短視頻'),
      // 2: VTabItem(2, '演員'),
      1: VTabItem(1, '演員'),
    };
  }
}

class VSearchTabs implements VTabCollection {
  @override
  Map<int, VTabItem> getTabs() {
    return {
      0: VTabItem(0, '長視頻'),
      // 1: VTabItem(1, '短視頻'),
    };
  }
}

class VPublisherTabs implements VTabCollection {
  @override
  Map<int, VTabItem> getTabs() {
    return {
      0: VTabItem(0, '最新'),
      1: VTabItem(1, '最熱'),
    };
  }
}

class VMemberMessageTabs implements VTabCollection {
  @override
  Map<int, VTabItem> getTabs() {
    return {
      0: VTabItem(0, '公告'),
      1: VTabItem(1, '系統通知'),
    };
  }
}
