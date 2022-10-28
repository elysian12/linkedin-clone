import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PostShimmerWidget extends StatelessWidget {
  const PostShimmerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 10, bottom: 10),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    width: 48.0,
                    height: 48.0,
                  ),
                  Column(
                    children: [
                      Container(
                        width: 100,
                        height: 8.0,
                        color: Colors.white,
                        margin: const EdgeInsets.only(bottom: 5),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        width: 100,
                        height: 8.0,
                        color: Colors.white,
                      ),
                      Container(
                        width: 100,
                        height: 8.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    width: 10,
                    height: 8.0,
                    color: Colors.red,
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    width: w,
                    height: 8.0,
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 5),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    width: w,
                    height: 8.0,
                    color: Colors.white,
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    width: w,
                    height: 8.0,
                    color: Colors.white,
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    width: w,
                    height: 8.0,
                    color: Colors.white,
                  ),
                  Container(
                    width: w,
                    height: 8.0,
                    color: Colors.white,
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 15),
                width: w,
                height: 200,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
