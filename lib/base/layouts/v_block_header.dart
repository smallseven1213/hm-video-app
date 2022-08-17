import 'package:flutter/material.dart';
import 'package:wgp_video_h5app/base/v_icon_collection.dart';
import 'package:wgp_video_h5app/base/v_loading.dart';
import 'package:wgp_video_h5app/components/v_d_icon.dart';
import 'package:wgp_video_h5app/helpers/getx.dart';
import 'package:wgp_video_h5app/models/index.dart';
import 'package:wgp_video_h5app/styles.dart';

class VBlockHeader extends StatefulWidget {
  final Function refresh;
  final Block block;
  final Channel channel;
  const VBlockHeader(this.block, this.channel,
      {Key? key, required this.refresh})
      : super(key: key);

  @override
  _VBlockHeaderState createState() => _VBlockHeaderState();
}

class _VBlockHeaderState extends State<VBlockHeader> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 53,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          widget.block.isTitle == false
              ? const SizedBox.shrink()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.ideographic,
                  children: [
                    Container(
                      width: 4,
                      height: 10,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      decoration: const BoxDecoration(
                        color: color1,
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    SizedBox(
                      height: 20,
                      child: Text(
                        widget.block.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
          Row(
            children: [
              widget.block.isChange == false
                  ? const SizedBox.shrink()
                  : InkWell(
                      onTap: () async {
                        if (!isLoading) {
                          setState(() {
                            isLoading = true;
                          });
                          await widget.refresh();
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0)),
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          children: [
                            const Text(
                              '換一換',
                              style: TextStyle(fontSize: 13),
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            isLoading
                                ? const VLoading()
                                : const VDIcon(VIcons.refresh),
                          ],
                        ),
                      ),
                    ),
              widget.block.isMore == false
                  ? const SizedBox.shrink()
                  : const SizedBox(width: 20),
              widget.block.isMore == false
                  ? const SizedBox.shrink()
                  : InkWell(
                      onTap: () => {
                        gto('/block/vods/${widget.block.id}/${widget.channel.id}')
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0)),
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: const [
                            Text(
                              '更多',
                              style: TextStyle(fontSize: 13),
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            VDIcon(VIcons.more),
                          ],
                        ),
                      ),
                    ),
            ],
          )
        ],
      ),
    );
  }
}
