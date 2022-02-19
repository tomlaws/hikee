import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikee/components/core/avatar.dart';
import 'package:hikee/components/core/shimmer.dart';
import 'package:hikee/models/topic.dart';
import 'package:hikee/themes.dart';
import 'package:hikee/utils/time.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class TopicTile extends StatefulWidget {
  final Topic? topic;
  final void Function()? onTap;
  const TopicTile({Key? key, this.topic, this.onTap}) : super(key: key);

  @override
  _TopicTileState createState() => _TopicTileState();
}

class _TopicTileState extends State<TopicTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [Themes.lightShadow]),
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: widget.onTap ??
              () {
                if (widget.topic != null)
                  Get.toNamed('/topics/${widget.topic!.id}');
              },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      width: 48,
                      child: widget.topic == null
                          ? Shimmer(
                              height: 48,
                              width: 48,
                              radius: 24,
                            )
                          : Avatar(user: widget.topic!.user, height: 48),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              widget.topic == null
                                  ? Shimmer(fontSize: 16, width: 120)
                                  : Expanded(
                                      child: Text(widget.topic!.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16)),
                                    ),
                              widget.topic == null
                                  ? Shimmer(fontSize: 16, width: 48)
                                  : Row(
                                      children: [
                                        Icon(
                                          LineAwesomeIcons.thumbs_up,
                                          size: 14,
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Text(widget.topic!.likeCount.toString())
                                      ],
                                    )
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          widget.topic == null
                              ? Shimmer(width: 88, fontSize: 12)
                              : Text(widget.topic!.user.nickname,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.black54)),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  widget.topic == null
                                      ? Shimmer(width: 64, fontSize: 12)
                                      : Text(
                                          '${widget.topic!.replyCount} replies',
                                          style: TextStyle(fontSize: 12)),
                                  Icon(
                                    Icons.chevron_right,
                                    size: 14,
                                  ),
                                ],
                              ),
                              widget.topic == null
                                  ? Shimmer(width: 64, fontSize: 12)
                                  : Text(
                                      TimeUtils.timeAgoSinceDate(
                                          widget.topic!.createdAt),
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.black54))
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Container(
                    //   margin: EdgeInsets.symmetric(horizontal: 8),
                    //   decoration: BoxDecoration(
                    //       color: Colors.grey[300],
                    //       borderRadius: BorderRadius.circular(3.0)),
                    //   width: 6,
                    //   height: 6,
                    // ),
                    // Text(
                    //   TimeUtils.timeAgoSinceDate(widget.topic.createdAt),
                    //   style: TextStyle(color: Colors.grey[500]),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
