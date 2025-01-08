import 'package:flutter/material.dart';
import 'package:sponge_app/const/color_const.dart';
import 'package:sponge_app/data/review/review_check_response.dart';
import 'package:sponge_app/screen/review/write_review.dart';

class TrainerProfileReview extends StatefulWidget {
  final ReviewCheckResponse reviewCheckResponse;
  final int trainerId;
  final String name;
  final double score;

  const TrainerProfileReview(
      {super.key, required this.reviewCheckResponse, required this.name, required this.trainerId, required this.score});

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
                '1',
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
              HalfStar(size: 20),
            ],
          ),
        ],
      ),
    );
  }
}

class HalfStar extends StatelessWidget {
  final double size;

  const HalfStar({this.size = 24.0, super.key});

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
