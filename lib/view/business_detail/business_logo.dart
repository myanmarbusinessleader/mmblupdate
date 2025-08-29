import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../model/business_listing.dart';

class BusinessLogo extends StatelessWidget {
  const BusinessLogo({
    Key? key,
    required this.bL,
  }) : super(key: key);

  final BusinessListing bL;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: bL.businessLogo.imagePath.isEmpty,
      child: Row(
        children: [
          //Logo
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: CircleAvatar(
              radius: 35,
              backgroundImage: bL.businessLogo.imagePath.isNotEmpty
                  ? NetworkImage(bL.businessLogo.imagePath)
                  : null,
              child: bL.businessLogo.imagePath.isEmpty
                  ? Container(color: Colors.grey[300])
                  : null,
            ),
          ),
          const SizedBox(height: 20),
          //Name
          Expanded(
            child: Text(
              bL.name,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}