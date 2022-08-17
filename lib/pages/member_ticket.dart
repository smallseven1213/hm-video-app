import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:wgp_video_h5app/helpers/index.dart';
import 'package:wgp_video_h5app/models/redemption.dart';
import 'package:wgp_video_h5app/styles.dart';

import '../components/upper_case_text_formatter.dart';
import '../providers/redemption_provider.dart';

class MemberTicketPage extends StatefulWidget {
  final String? refer;
  const MemberTicketPage({Key? key, this.refer}) : super(key: key);

  @override
  _MemberTicketPageState createState() => _MemberTicketPageState();
}

class _MemberTicketPageState extends State<MemberTicketPage>
    with TickerProviderStateMixin {
  late TabController tabController;
  int tabIndex = 0;
  bool isChecked = false;
  int paymentMethod = 0;
  int status = 0;
  bool isLoading = false;
  bool isValid = false;
  String code = "";
  List<Widget> records = [];
  @override
  void initState() {
    tabController = TabController(
      initialIndex: 0,
      length: 3,
      vsync: this,
    );
    tabController.addListener(() {
      changeTab(tabController.index);
    });

    loadRecords();

    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  loadRecords() {
    Get.find<RedemptionProvider>().records().then((value) => {
      setState(() {
        records.clear();
        if (value.length<= 0) {
          records.add(noMoreData()) ;

        } else {
          records.add(Row(
            children: [
              buildC("兌換名稱", gs().width / 2.518, color7),
              buildC("", gs().width / 4.87, color7),
              buildC("兌換時間", gs().width / 2.518, color7),
            ],
          ));
          value.forEach((element) {records.add(buildRow(element));});
        }
      })
    });
  }

  void changeTab(int index) {
    tabController.animateTo(
      index,
      duration: Duration.zero,
      curve: Curves.linear,
    );
    setState(() {
      tabIndex = index;
    });
  }

  bool validate(String value) {
    return value.length >= 6 && value.length <= 12  && RegExp("[A-Za-z0-9]").hasMatch(value);
  }
 Widget buildRow(Redemption e) {
  return  Row(
      children: [
        buildC(e.name!, gs().width / 2.518, Colors.white),
        buildC("", gs().width / 4.87, Colors.white),
        buildC(DateFormat('yyyy/MM/dd HH:mm')
            .format(DateTime.parse(e
            .updatedAt
            .toString())), gs().width / 2.518, Colors.white),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        // title: Text(widget.title),
        backgroundColor: color1,
        shadowColor: Colors.transparent,
        toolbarHeight: 48,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: color1,
        ),
        leading: widget.refer == 'home'
            ? Container()
            : InkWell(
                onTap: () {
                  back();
                },
                enableFeedback: true,
                child: const Icon(
                  Icons.arrow_back_ios,
                  size: 14,
                ),
              ),
        title: Stack(
          children: [
            Transform(
              transform: Matrix4.translationValues(-26, 0, 0),
              child: const Center(
                child: Text(
                  '序號兌換',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                SizedBox(
                  width: gs().width - 76,
                  height: 30,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: TextFormField(
                      inputFormatters: [
                        UpperCaseTextFormatter(),
                        FilteringTextInputFormatter.allow(
                            RegExp("[A-Za-z0-9]")),
                        LengthLimitingTextInputFormatter(12),
                      ],
                      style: const TextStyle(
                          // backgroundColor: Colors.white,
                          ),
                      onChanged: (text) {
                        setState(() {
                          isValid = validate(text);
                          code = text.toUpperCase();
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xfff2f2f2),
                        contentPadding: const EdgeInsets.only(left: 16),
                        suffixIconColor: const Color.fromRGBO(167, 167, 167, 1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        hintText: '請輸入兌換序號',
                        hintStyle: const TextStyle(
                          fontSize: 14,
                          color: Color(0xffb3b3b3),
                        ),
                        focusColor: Colors.white,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    Get.find<RedemptionProvider>().redeem(code).then((value) async =>
                    await alertModal(
                        title: '提示', content: value)).then((value) => {
                          loadRecords(),
                    });
                  },
                  child: Container(
                    width: 60,
                    height: 28,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(
                      top: 6,
                      bottom: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isValid ? color1 : const Color(0xfff2f2f2),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Text(
                      '兌換',
                      style: isValid
                          ? const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: Colors.black)
                          : const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: Color(0xffb3b3b3)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            SizedBox(
              height: 36,
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                SizedBox(
                  width: 16,
                ),
                !isValid && code.isNotEmpty
                    ? Padding(
                        padding:
                            EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        child: Text("請輸入12位英文或英字",
                            style: TextStyle(
                                fontSize: 12,
                                height: 1.17,
                                color: Color(0xff979797))))
                    : Container(),
              ]),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: const [
              Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
                  child: Text(
                    "兌換記錄",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff979797)),
                  )),
            ]),
            Column(
                children: records
            )
          ],
        ),
      ),
    );
  }

  Container buildC(String text, double width, Color color) {
    return Container(
      width: width,
      height: 42,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(
        top: 8,
        bottom: 8,
      ),
      decoration: BoxDecoration(
        color: color,
        border: const Border(
          bottom: BorderSide(width: 1.5, color: color7),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
      ),
    );
  }

  Widget noMoreData() {
    return Column(
      children: [
        SizedBox(
          height: gs().height /4.91,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image: AssetImage(
                  'assets/png/icon-empty@3x.png'),
              height: 107,width: 80
              ,),
            const SizedBox(
              height: 18,
            ),
            Text(
              '沒有更多紀錄',
              style: TextStyle(color: color5),
            ),
          ],
        )
      ],
    );
  }

  Future<void> alertModal({String title = '', String content = ''}) async {
    return showDialog(
      context: context,
      builder: (_ctx) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          titlePadding: EdgeInsets.zero,
          title: null,
          contentPadding: EdgeInsets.zero,
          content: Container(
            height: 150,
            padding:
            const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  content,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.normal),
                ),
                const SizedBox(
                  height: 16,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      color: color1,
                    ),
                    child: const Text('確認'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}
