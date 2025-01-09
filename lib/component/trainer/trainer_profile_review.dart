import 'package:flutter/material.dart';
import 'package:sponge_app/const/color_const.dart';
import 'package:sponge_app/data/review/review_check_response.dart';
import 'package:sponge_app/data/review/review_response.dart';
import 'package:sponge_app/screen/review/write_review.dart';

class TrainerProfileReview extends StatefulWidget {
  final ReviewCheckResponse reviewCheckResponse;
  final int trainerId;
  final String name;
  final double score;
  final List<ReviewResponse> reviewList;

  const TrainerProfileReview(
      {super.key, required this.reviewCheckResponse, required this.name, required this.trainerId, required this.score, required this.reviewList});

  @override
  State<TrainerProfileReview> createState() => _TrainerProfileReviewState();
}

class _TrainerProfileReviewState extends State<TrainerProfileReview> {


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                '리뷰',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(width: 8),
              Text(
                widget.reviewList.length.toString(),
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w700, color: mainGrey),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (!widget.reviewCheckResponse.reviewCheck)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.name} 훈련사님에게',
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    const Text(
                      '리뷰를 남겨보세요',
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                SizedBox(
                  width: 120,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WriteReview(trainerId: widget.trainerId,),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: mainYellow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: BorderSide.none,
                    ),
                    child: const Text(
                      '리뷰쓰기',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                widget.score.toString(),
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(width: 8),
              ...List.generate(5, (index) {
                if (index < widget.score.floor()) {
                  // 정수 부분: 꽉 찬 별
                  return Icon(
                    Icons.star,
                    color: mainYellow,
                    size: 25,
                  );
                } else if (index < widget.score && widget.score - index >= 0.5) {
                  // 소수 부분: 반 별
                  return HalfStar();
                } else {
                  // 나머지: 빈 별
                  return Icon(
                    Icons.star,
                    color: lightGrey,
                    size: 25,
                  );
                }
              }),
            ],
          ),
          SizedBox(height: 8,),

        ],
      ),
    );
  }
}

class HalfStar extends StatelessWidget {
  final double size;

  const HalfStar({this.size = 25.0, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Icon(
            Icons.star,
            size: size,
            color: lightGrey,
          ),
          ClipRect(
            clipper: HalfClipper(),
            child: Icon(
              Icons.star,
              size: size,
              color: mainYellow,
            ),
          ),
        ],
      ),
    );
  }
}

class HalfClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, size.width / 2, size.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return false;
  }
}
