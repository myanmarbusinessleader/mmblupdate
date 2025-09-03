import 'package:flutter/material.dart';
import 'package:mmbl/constant/emergency.dart';

import '../../utils/other/intent_method.dart';

class EmergencyView extends StatelessWidget {
  const EmergencyView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: emergencyList.length,
      itemBuilder: (context, index) {
        final emergency = emergencyList[index];
        return Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
          child: Container(
            color: Colors.red,
            height: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CircleAvatar(
                  radius: 50,
                  child: Image.asset(
                    emergency.image,
                    fit: BoxFit.contain,
                    width: 60,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      emergency.mmName,
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(color: Colors.white),
                    ),
                    Text(
                      emergency.enName,
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: Colors.white),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => makePhoneCall(emergency.phone),
                  icon: const Icon(Icons.phone, color: Colors.white, size: 35),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
