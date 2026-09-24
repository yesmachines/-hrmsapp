import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../../main.dart';
import '../../controller/controller.dart';
import '../../service/model/social_model.dart';

class SocialPostCard extends StatefulWidget {
  const SocialPostCard({
    super.key,
    required this.post,
  });

  final SocialPostModel post;

  @override
  State<SocialPostCard> createState() => _SocialPostCardState();
}

class _SocialPostCardState extends State<SocialPostCard> {
  bool _showReactionPicker = false;

  SocialsController get controller => Get.find<SocialsController>();

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return Container(
      width: double.infinity,
      color: appColors.scaffoldGreyColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: appSize.size16.w,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ProfileImage(
                  image: post.userImage,
                  name: post.userName,
                ),

                SizedBox(
                  width: appSize.size10.w,
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.userName,
                        style: fontStyles.font14Black600.copyWith(
                          color: appColors.profileText,
                        ),
                      ),

                      Text(
                        post.postedTime,
                        style: fontStyles.font12White400.copyWith(
                          color: appColors.subText,
                        ),
                      ),
                    ],
                  ),
                ),

                Icon(
                  Icons.more_horiz,
                  size: appSize.size20.sp,
                  color: appColors.subText,
                ),
              ],
            ),
          ),

          SizedBox(
            height: appSize.size14.h,
          ),

          if (post.description.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: appSize.size16.w,
              ),
              child: Text(
                post.description,
                style: fontStyles.font14LightGrey400.copyWith(
                  color: appColors.profileText,
                ),
              ),
            ),

          SizedBox(
            height: appSize.size12.h,
          ),

          if (post.postImage.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: appSize.size16.w,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  appSize.radius12.r,
                ),
                child: Image.network(
                  post.postImage,
                  width: double.infinity,
                  height: 218.h,
                  fit: BoxFit.cover,
                  errorBuilder: (
                      context,
                      error,
                      stackTrace,
                      ) {
                    return Container(
                      height: 218.h,
                      color: appColors.blackColor.withValues(
                        alpha: 0.15,
                      ),
                      child: Icon(
                        Icons.image_outlined,
                        color: appColors.blackColor,
                        size: 35.sp,
                      ),
                    );
                  },
                ),
              ),
            ),

          SizedBox(
            height: appSize.size14.h,
          ),

          if (post.reactions.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: appSize.size16.w,
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: appSize.size8.w,
                      vertical: appSize.size4.h,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: post.reactions
                          .map(
                            (reaction) => Padding(
                          padding: EdgeInsets.only(
                            right: appSize.size4.w,
                          ),
                          child: Text(
                            reaction,
                            style: TextStyle(
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      )
                          .toList(),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      _showReactionsSheet(
                        context,
                        post,
                      );
                    },
                    child: Text(
                      '${post.reactionCount} reactions',
                      style: fontStyles.font12White400.copyWith(
                        color: appColors.subText,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          SizedBox(
            height: appSize.size8.h,
          ),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: appSize.size16.w,
            ),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [

                Positioned(
                  bottom: appSize.size42.h,
                  child: AnimatedScale(
                    scale: _showReactionPicker ? 1.0 : 0.7,
                    duration: const Duration(
                      milliseconds: 180,
                    ),
                    curve: Curves.easeOutBack,
                    child: AnimatedOpacity(
                      opacity:
                      _showReactionPicker ? 1.0 : 0.0,
                      duration: const Duration(
                        milliseconds: 120,
                      ),
                      child: IgnorePointer(
                        ignoring: !_showReactionPicker,
                        child: _ReactionPopup(
                          onReactionSelected: (
                              String emoji,
                              ) {
                            controller.reactToPost(
                              post,
                              emoji,
                            );

                            setState(() {
                              _showReactionPicker = false;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),


                InkWell(
                  onTap: () {
                    setState(() {
                      _showReactionPicker =
                      !_showReactionPicker;
                    });
                  },
                  borderRadius:
                  BorderRadius.circular(appSize.size8.r),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      vertical: appSize.size8.h,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: appColors.dividerColor
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons
                              .sentiment_satisfied_alt_outlined,
                          size: appSize.size16.sp,
                          color:
                          appColors.subText,
                        ),

                        SizedBox(
                          width: appSize.size4.w,
                        ),

                        Text(
                          'React',
                          style: fontStyles
                              .font14Brand500
                              .copyWith(
                            color:
                            appColors.subText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            height: appSize.size12.h,
          ),
        ],
      ),
    );
  }

  // REACTIONS USERS BOTTOM SHEET

  void _showReactionsSheet(
      BuildContext context,
      SocialPostModel post,
      ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return _ReactionsBottomSheet(
          post: post,
        );
      },
    );
  }
}

// PROFILE IMAGE

class _ProfileImage extends StatelessWidget {
  const _ProfileImage({
    required this.image,
    required this.name,
  });

  final String image;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: appSize.size40.w,
      height: appSize.size40.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: appColors.brandColor,
        image: image.isNotEmpty
            ? DecorationImage(
          image: NetworkImage(image),
          fit: BoxFit.cover,
        )
            : null,
      ),
      alignment: Alignment.center,
      child: image.isEmpty
          ? Text(
        name.isNotEmpty
            ? name[0].toUpperCase()
            : '?',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 14.sp,
        ),
      )
          : null,
    );
  }
}

// FLOATING REACTION POPUP

class _ReactionPopup extends StatelessWidget {
  const _ReactionPopup({
    required this.onReactionSelected,
  });

  final Function(String emoji) onReactionSelected;

  @override
  Widget build(BuildContext context) {
    final reactions = [
      '👍',
      '❤️',
      '😂',
      '😮',
      '😢',
      '🎉',
    ];

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 10.w,
          vertical: 7.h,
        ),
        decoration: BoxDecoration(
          color: appColors.whiteColor,
          borderRadius: BorderRadius.circular(25.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: 0.15,
              ),
              blurRadius: 12,
              offset: const Offset(
                0,
                3,
              ),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: reactions.map(
                (emoji) {
              return GestureDetector(
                onTap: () {
                  onReactionSelected(emoji);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 5.w,
                  ),
                  child: Text(
                    emoji,
                    style: TextStyle(
                      fontSize: 22.sp,
                    ),
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}

// REACTIONS BOTTOM SHEET

class _ReactionsBottomSheet extends StatelessWidget {
  const _ReactionsBottomSheet({
    required this.post,
  });

  final SocialPostModel post;

  @override
  Widget build(BuildContext context) {
    final reactions = post.reactionUsers;

    final int likeCount = reactions
        .where(
          (e) => e.reaction == '👍',
    )
        .length;

    final int loveCount = reactions
        .where(
          (e) => e.reaction == '❤️',
    )
        .length;

    final int clapCount = reactions
        .where(
          (e) => e.reaction == '👏',
    )
        .length;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: appSize.size20.w),
      height: 382.h,
      decoration: BoxDecoration(
        color: appColors.whiteColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(appSize.radius24.r),
        ),
      ),
      child: Column(
        children: [
          // HEADER

          Padding(
            padding: EdgeInsets.fromLTRB(
              appSize.size24.w,
              appSize.size24.h,
              appSize.size24.w,
              appSize.size14.h,
            ),
            child: Row(
              children: [
                Text(
                  'Reactions',
                  style: fontStyles.font16White700.copyWith(
                      color: appColors.blackColor,
                    fontSize: appSize.size18.sp
                  )
                ),
                Spacer(),

                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                   padding: EdgeInsets.all(appSize.size6.sp),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                      appColors.scaffoldGreyColor,
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      size: 14.sp,
                      color: appColors.subText,
                    ),
                  ),
                ),
              ],
            ),
          ),


          SizedBox(
            height: 46.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(
                horizontal: 24.w,
              ),
              children: [
                _ReactionFilter(
                  title: 'All',
                  count: post.reactionCount,
                  selected: true,
                ),

                SizedBox(
                  width: 10.w,
                ),

                _ReactionFilter(
                  emoji: '👍',
                  count: likeCount,
                ),

                SizedBox(
                  width: 10.w,
                ),

                _ReactionFilter(
                  emoji: '❤️',
                  count: loveCount,
                ),

                SizedBox(
                  width: 10.w,
                ),

                _ReactionFilter(
                  emoji: '👏',
                  count: clapCount,
                ),
              ],
            ),
          ),

          SizedBox(
            height: 12.h,
          ),

          Divider(
            height: 1,
            color: appColors.dividerColor
          ),

          // USERS

          Expanded(
            child: reactions.isEmpty
                ? Center(
              child: Text(
                'No reactions yet',
                style: fontStyles
                    .font12White400
                    .copyWith(
                  color:
                  appColors.blackColor,
                ),
              ),
            )
                : ListView.separated(
              itemCount: reactions.length,
              separatorBuilder: (_, __) {
                return Divider(
                  height: 1,
                  color: appColors.dividerColor
                );
              },
              itemBuilder: (
                  context,
                  index,
                  ) {
                final reaction =
                reactions[index];

                return _ReactionUserTile(
                  reaction: reaction,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// REACTION FILTER

class _ReactionFilter extends StatelessWidget {
  const _ReactionFilter({
    this.emoji,
    required this.count,
    this.title,
    this.selected = false,
  });

  final String? emoji;
  final String? title;
  final int count;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: appSize.size14.w,
      ),
      decoration: BoxDecoration(
        color: selected
            ? appColors.brandColor
            : appColors.scaffoldGreyColor,
        borderRadius:
        BorderRadius.circular(appSize.radius24.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (emoji != null)
            Text(
              emoji!,
              style: TextStyle(
                fontSize: appSize.size12.sp,
              ),
            ),

          if (title != null)
            Text(
              title!,
              style: fontStyles.font12White500.copyWith(fontWeight: .w600)
            ),

          SizedBox(
            width: appSize.size4.w,
          ),

          Text(
            '$count',
            style: fontStyles.font12Brand600
              .copyWith(color: selected
                ? appColors.whiteColor
                : appColors.blackColor,)
          ),
        ],
      ),
    );
  }
}

// REACTION USER TILE

class _ReactionUserTile extends StatelessWidget {
  const _ReactionUserTile({
    required this.reaction,
  });

  final SocialReactionModel reaction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: appSize.size24.w,
        vertical: appSize.size12.h,
      ),
      child: Row(
        children: [
          Container(
            width: appSize.size32.w,
            height: appSize.size32.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: appColors.brandColor,
              image: reaction.userImage.isNotEmpty
                  ? DecorationImage(
                image: NetworkImage(
                  reaction.userImage,
                ),
                fit: BoxFit.cover,
              )
                  : null,
            ),
            alignment: Alignment.center,
            child: reaction.userImage.isEmpty
                ? Text(
              reaction.userName.isNotEmpty
                  ? reaction.userName[0]
                  .toUpperCase()
                  : '?',
              style: fontStyles.font16White600
            )
                : null,
          ),

          SizedBox(
            width: appSize.size12.w,
          ),

          Expanded(
            child: Text(
              reaction.userName,
              style: fontStyles.font14Black600,
            ),
          ),

          Text(
            reaction.reaction,
            style: fontStyles.font16MediumGrey400
          ),
        ],
      ),
    );
  }
}