import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/filter_screen_controller.dart';

import '../screens/filter/options.dart';
import '../screens/filter/result.dart';
import '../widgets/custom_app_bar.dart';

class FilterPage extends StatelessWidget {
  const FilterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: CustomAppBar(
          title: '篩選',
        ),
        body: FilterScrollView());
  }
}

class FilterScrollView extends StatefulWidget {
  const FilterScrollView({super.key});

  @override
  _FilterScrollViewState createState() => _FilterScrollViewState();
}

class _FilterScrollViewState extends State<FilterScrollView> {
  final ScrollController _scrollController = ScrollController();
  bool _showSelectedBar = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 120) {
        if (!_showSelectedBar) {
          setState(() {
            _showSelectedBar = true;
          });
        }
      } else {
        if (_showSelectedBar) {
          setState(() {
            _showSelectedBar = false;
          });
        }
      }

      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadNextPage();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadNextPage() async {
    final controller = Get.find<FilterScreenController>();
    controller.loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomScrollView(
          controller: _scrollController,
          slivers: [
            FilterOptions(),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 10,
              ),
            ),
            FilterResult(),
          ],
        ),
        if (_showSelectedBar) _buildSelectedBar(),
      ],
    );
  }

  Widget _buildSelectedBar() {
    final controller = Get.find<FilterScreenController>();
    return GestureDetector(
      onTap: () {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: Container(
        color: Colors.black.withOpacity(0.8),
        padding: EdgeInsets.all(8),
        width: double.infinity,
        height: 40,
        child: GetBuilder<FilterScreenController>(
          builder: (controller) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: controller.selectedOptions.entries
                    .map(
                      (entry) => entry.value
                          .where((element) => element != null)
                          .map(
                            (value) => Container(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                controller.findName(entry.key, value),
                                style: TextStyle(color: Color(0xFFF4D743)),
                              ),
                            ),
                          )
                          .toList(),
                    )
                    .expand((element) => element)
                    .toList(),
              ),
            );
          },
        ),
      ),
    );
  }
}
