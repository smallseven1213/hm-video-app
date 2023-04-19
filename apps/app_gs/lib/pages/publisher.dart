import 'package:app_gs/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import '../screens/vendor_videos/list.dart';
import '../widgets/button.dart';

class PublisherPage extends StatefulWidget {
  final int id;
  const PublisherPage({Key? key, required this.id}) : super(key: key);

  @override
  _VendorVideosPageState createState() => _VendorVideosPageState();
}

class _VendorVideosPageState extends State<PublisherPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '',
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Button(
                    text: '最新',
                    size: 'small',
                    onPressed: () => _tabController.animateTo(0),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: Button(
                    text: '最熱',
                    size: 'small',
                    onPressed: () => _tabController.animateTo(1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          VendorVideoList(
            type: 'new',
            publisherId: widget.id,
          ),
          VendorVideoList(
            type: 'hot',
            publisherId: widget.id,
          ),
        ],
      ),
    );
  }
}
