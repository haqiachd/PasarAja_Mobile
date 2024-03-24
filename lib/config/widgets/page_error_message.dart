import 'package:flutter/cupertino.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';

class PageErrorMessage extends StatelessWidget {
  final OnFailureState onFailureState;

  const PageErrorMessage({
    super.key,
    required this.onFailureState,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            "MESSAGE -> ${onFailureState.message}",
          ),
          Text(
            "DIO ERRROR -> ${onFailureState.dioException!.error.toString()}",
          ),
        ],
      ),
    );
  }
}