import 'package:flutter/material.dart';

class OperationPageFour extends StatelessWidget {
  const OperationPageFour({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * .85,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Divider(),
            Center(
              child: Text('Store Coming soon...'),
            )
          ],
        ),
      ),
    );
  }
}
