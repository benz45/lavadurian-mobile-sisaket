import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:LavaDurian/constants.dart';

class ViewOrderScreen extends StatefulWidget {
  final String hero;
  final String gene;
  final String status;
  const ViewOrderScreen({Key key, this.hero, this.status, this.gene})
      : super(key: key);

  @override
  _ViewOrderScreenState createState() => _ViewOrderScreenState();
}

class _ViewOrderScreenState extends State<ViewOrderScreen> {
  AnimationController animateController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: false,
              elevation: 0,
              shadowColor: Colors.grey[50].withOpacity(0.3),
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              pinned: true,
              title: Container(
                child: Flash(
                  duration: Duration(milliseconds: 450),
                  manualTrigger: true,
                  controller: (controller) => animateController = controller,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ClipOval(
                        child: Material(
                          color: Colors.white.withOpacity(0.25),
                          child: InkWell(
                            child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(Icons.arrow_back_rounded),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      // ignore: todo
                      // TODO: Next Future!
                    ],
                  ),
                ),
              ),
              expandedHeight: 460.0,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Hero(
                        tag: 'image${widget.hero}',
                        child: Container(
                          height: 400,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit
                                  .cover, //I assumed you want to occupy the entire space of the card
                              image: AssetImage(
                                'assets/images/example.png',
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(12.0),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 6.0),
                              decoration: BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.circular(7.5),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2),
                                child: Text(
                                  "${widget.status}",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14.0),
                                ),
                              ),
                            ),
                            Hero(
                              tag: 'gene${widget.hero}',
                              child: SizedBox(
                                width: double.infinity,
                                child: Material(
                                  color: Colors.transparent,
                                  child: Text(
                                    "${widget.gene}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
