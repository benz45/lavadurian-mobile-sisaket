import 'dart:async';

import 'package:LavaDurian/Screens/Operation/operation_screen.dart';
import 'package:LavaDurian/Screens/Register_Success/components/background.dart';
import 'package:LavaDurian/components/rounded_button.dart';
import 'package:LavaDurian/components/rounded_input_field.dart';
import 'package:LavaDurian/components/showSnackBar.dart';
import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/createStore_model.dart';
import 'package:LavaDurian/models/profile_model.dart';
import 'package:LavaDurian/models/setting_model.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:http/http.dart' as Http;
import 'dart:convert';
import 'dart:io';

class Body extends StatefulWidget {
  final bool backArrowButton;
  Body({this.backArrowButton});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // ! Controller text data
  CreateStoreModel initCreateStoreModel;
  UserModel initUserModel;

  final _textNameValue = TextEditingController();
  final _textSloganValue = TextEditingController();
  final _textPhone1Value = TextEditingController();
  final _textPhone2Value = TextEditingController();
  final _textAboutValue = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Start listening to changes.
    initCreateStoreModel = context.read<CreateStoreModel>();
    initUserModel = context.read<UserModel>();
    _textNameValue.addListener(_onChangeNameValue);
    _textSloganValue.addListener(_onChangeTextSloganValue);
    _textPhone1Value.addListener(_onChangeTextPhone1Value);
    _textPhone2Value.addListener(_onChangeTextPhone2Value);
    _textAboutValue.addListener(_onChangeTextAboutValue);
  }

  _onChangeNameValue() {
    initCreateStoreModel.setNameValue = _textNameValue.text;
  }

  _onChangeTextSloganValue() {
    initCreateStoreModel.setSloganValue = _textSloganValue.text;
  }

  _onChangeTextPhone1Value() {
    initCreateStoreModel.setPhone1Value = _textPhone1Value.text;
  }

  _onChangeTextPhone2Value() {
    initCreateStoreModel.setPhone2Value = _textPhone2Value.text;
  }

  _onChangeTextAboutValue() {
    initCreateStoreModel.setAboutValue = _textAboutValue.text;
  }

  // Carousel controller.
  CarouselController carouselController = CarouselController();

  // Input  Formater Limit 250.
  List<TextInputFormatter> limitingTextInput = [LengthLimitingTextInputFormatter(250)];

  // Mask Formater Phone Number
  var maskFormatter = MaskTextInputFormatter(mask: '###-###-####', filter: {"#": RegExp(r'[0-9]')});

  @override
  Widget build(BuildContext context) {
    // Provider model.
    StoreModel storeModel = Provider.of<StoreModel>(context, listen: false);
    CreateStoreModel createStoreModel = Provider.of<CreateStoreModel>(context);
    SettingModel settingModel = Provider.of<SettingModel>(context, listen: false);

    // Jump page with animation
    void carouselControllerAnimateToPage(int page) {
      // Fix error "RRect argument contained a NaN value"
      FocusScope.of(context).unfocus();
      carouselController.animateToPage(
        page,
        duration: Duration(milliseconds: 800),
        curve: Curves.fastOutSlowIn,
      );
      createStoreModel.setCurrentIndexPage = page;
    }

    // Size for custom screen.
    Size size = MediaQuery.of(context).size;
    final font = Theme.of(context).textTheme;

    // ! Validate data page one
    Future _valdatatePageOne() async {
      if (createStoreModel.getNameValue == null || createStoreModel.getNameValue == "") {
        showSnackBar(context, 'กรุณากรอกชื่อร้านค้า');

        carouselControllerAnimateToPage(0);
        return false;
      }

      if (createStoreModel.getSloganValue == null || createStoreModel.getSloganValue == "") {
        showSnackBar(context, 'กรุณากรอกข้อมูลสโลแกนร้านค้า');
        carouselControllerAnimateToPage(0);
        return false;
      }

      if (createStoreModel.getAboutValue == null || createStoreModel.getAboutValue == "") {
        showSnackBar(context, 'กรุณาบรรยายข้อมูลเกี่ยวกับร้านค้า');
        carouselControllerAnimateToPage(0);

        return false;
      }
      // * Validate data page one success!
      return true;
    }

    // ! Validate data page two
    Future _valdatatePageTwo() async {
      if (createStoreModel.getChosenDistrict == null) {
        showSnackBar(context, 'กรุณาเลือกเขตอำเภอ');
        carouselControllerAnimateToPage(1);
        return false;
      }

      if (createStoreModel.getPhone1Value == null || createStoreModel.getPhone1Value == "") {
        showSnackBar(context, 'กรุณากรอกหมายเลขติดต่อ');
        carouselControllerAnimateToPage(1);
        return false;
      }

      // * Validate data page two success!
      return true;
    }

    // ! Future on submit create.
    Future<void> _onSubmit() async {
      FocusScope.of(context).unfocus();
      bool resultvalidatePageOne;
      bool resultvalidatePageTwo;
      resultvalidatePageOne = await _valdatatePageOne();

      if (resultvalidatePageOne) {
        resultvalidatePageTwo = await _valdatatePageTwo();
      }

      if (resultvalidatePageOne && resultvalidatePageTwo) {
        Map<String, dynamic> data = {
          'name': createStoreModel.getNameValue.toString().trim(),
          'slogan': createStoreModel.getSloganValue.toString().trim(),
          'about': createStoreModel.getAboutValue.toString().trim(),
          'phone1': createStoreModel.getPhone1Value.toString().trim(),
          'phone2': createStoreModel.getPhone2Value.toString().trim(),
          'district': storeModel.district.keys.firstWhere((k) => storeModel.district[k] == createStoreModel.getChosenDistrict),
          'status': 0.toString(),
        };

        try {
          // get current user token
          String token = settingModel.value['token'];
          final response = await Http.post(
            '${settingModel.baseURL}/${settingModel.endPointAddStore}',
            body: data,
            headers: {HttpHeaders.authorizationHeader: "Token $token"},
          );

          if (response.statusCode == 200) {
            var jsonData = json.decode(utf8.decode(response.bodyBytes));

            // Convert data type from response api.
            Map<String, dynamic> toMap() => {
                  "id": jsonData["data"]["store"]["id"],
                  "owner": jsonData["data"]["store"]["owner"],
                  "name": jsonData["data"]["store"]["name"],
                  "slogan": jsonData["data"]["store"]["slogan"],
                  "about": jsonData["data"]["store"]["about"],
                  "phone1": jsonData["data"]["store"]["phone1"],
                  "phone2": jsonData["data"]["store"]["phone2"],
                  "district": jsonData["data"]["store"]["district"],
                  "status": int.parse(jsonData["data"]["store"]["status"]),
                };

            storeModel.addStore = toMap();
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String currentStoreById = 'USERID_${initUserModel.value['id']}_CURRENT_STORE';
            prefs.setInt(currentStoreById, toMap()['id']);
            createStoreModel.clear();

            // * Navigate operation screen and show snackbar create store success
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
              builder: (_) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scaffoldKey.currentState.showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(
                            Icons.check,
                            color: Colors.green[600],
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Text('สร้างร้านค้าสำเร็จ')
                        ],
                      ),
                    ),
                  );
                });
                return Scaffold(
                  key: _scaffoldKey,
                  body: OperationScreen(),
                );
              },
            ), (Route<dynamic> route) => false);
          } else {
            showSnackBar(context, "เกิดข้อผิดพลาด Response status : ${response.statusCode}");
          }
        } catch (e) {
          print(e);
          showSnackBar(context, "เกิดข้อผิดพลาดไม่สามารถสร้างร้านค้าได้");
        }
      } else {
        showSnackBar(context, "กรุณาตรวจสอบข้อมูลอีกครั้ง");
      }
    }

    return Background(
      child: Stack(
        overflow: Overflow.visible,
        children: [
          SizedBox(
            height: size.height,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    height: size.height * 0.32,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 7.0),
                          child: Text(
                            "สร้างร้านค้าของคุณ",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                          ),
                        ),
                        Text(
                          "ทุเรียนภูเขาไฟศรีสะเกษ",
                          style: TextStyle(fontWeight: FontWeight.bold, color: kTextSecondaryColor),
                        ),
                        SizedBox(height: size.height * 0.04),
                      ],
                    ),
                  ),
                  Consumer<CreateStoreModel>(builder: (_, consumerCreateStoreModel, c) {
                    return Container(
                      child: CarouselSlider(
                        carouselController: carouselController,
                        options: CarouselOptions(
                            viewportFraction: 1.0,
                            initialPage: 0,
                            enableInfiniteScroll: false,
                            height: size.height * 0.6,
                            onPageChanged: (index, reason) {
                              consumerCreateStoreModel.setCurrentIndexPage = index;
                            }),
                        items: [
                          // ! Page 1
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // * _nameValue
                              RoundedInputField(
                                hintText: "ชื่อร้านค้า",
                                controller: _textNameValue,
                                icon: Icons.storefront_rounded,
                                textInputAction: TextInputAction.next,
                                inputFormatters: limitingTextInput,
                              ),
                              // * _sloganValue
                              RoundedInputField(
                                hintText: "สโลแกนร้านค้า",
                                icon: Icons.star_outline_rounded,
                                controller: _textSloganValue,
                                textInputAction: TextInputAction.next,
                                inputFormatters: limitingTextInput,
                              ),
                              // * _aboutValue
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                padding: EdgeInsets.symmetric(horizontal: 26, vertical: 5),
                                width: size.width * 0.8,
                                decoration: BoxDecoration(
                                  color: kPrimaryLightColor,
                                  borderRadius: BorderRadius.circular(29),
                                ),
                                child: TextField(
                                  cursorColor: kPrimaryColor,
                                  maxLines: 2,
                                  textInputAction: TextInputAction.next,
                                  controller: _textAboutValue,
                                  decoration: InputDecoration(
                                    hintText: 'เกี่ยวกับร้านค้า',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              RoundedButton(
                                text: 'ถัดไป',
                                press: () async {
                                  // ! Fix error "RRect argument contained a NaN value"
                                  FocusScope.of(context).unfocus();
                                  bool result = await _valdatatePageOne();
                                  if (result) {
                                    carouselController.nextPage(
                                      duration: Duration(milliseconds: 800),
                                      curve: Curves.fastOutSlowIn,
                                    );
                                    consumerCreateStoreModel.setCurrentIndexPage = (consumerCreateStoreModel.getCurrentIndexPage) + 1;
                                  }
                                },
                              ),
                            ],
                          ),

                          // ! Page 2
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // * _chosenDistrict
                              GestureDetector(
                                onTap: () {
                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (context) {
                                      // * Init state dialog only.
                                      int selectedRadio = storeModel.district.entries
                                              .map((e) => "${e.value}")
                                              .toList()
                                              .indexOf(consumerCreateStoreModel.getChosenDistrict) ??
                                          0;

                                      return AlertDialog(
                                        title: Text(
                                          'เลือกอำเภอ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(18),
                                          ),
                                        ),
                                        content: StatefulBuilder(
                                          builder: (context, setDialogState) {
                                            return Container(
                                              width: size.width * 0.8,
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: storeModel.district.entries.map((e) => e.key).toList().length,
                                                itemBuilder: (context, index) {
                                                  return RadioListTile(
                                                    title: Text(
                                                      '${storeModel.district.entries.map((e) => "${e.value}").toList()[index]}'
                                                          .replaceAll("", "\u{200B}"),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    value: index,
                                                    groupValue: selectedRadio ?? 0,
                                                    onChanged: (value) {
                                                      // * set state dialog only.
                                                      setDialogState(() {
                                                        selectedRadio = value;
                                                      });

                                                      // * set state global only.
                                                      consumerCreateStoreModel.setChosenDistrict =
                                                          storeModel.district.entries.map((e) => "${e.value}").toList()[value];
                                                      Navigator.pop(context);
                                                    },
                                                    selected: index == selectedRadio ? true : false,
                                                    activeColor: kPrimaryColor,
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(29),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 36, vertical: 18),
                                    width: size.width * 0.8,
                                    color: kPrimaryLightColor,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${consumerCreateStoreModel.getChosenDistrict ?? 'เขตอำเภอ'}',
                                          style: TextStyle(color: kTextPrimaryColor.withOpacity(0.62), fontSize: font.subtitle1.fontSize),
                                        ),
                                        Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          color: kTextSecondaryColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              //  * _phone1Value
                              RoundedInputField(
                                hintText: "หมายเลขโทรศัพท์",
                                icon: Icons.phone_iphone,
                                controller: _textPhone1Value,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  maskFormatter,
                                ],
                              ),
                              // * _phone2Value
                              RoundedInputField(
                                hintText: "หมายเลขโทรศัพท์สำรอง (ถ้ามี)",
                                icon: Icons.phone,
                                controller: _textPhone2Value,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  maskFormatter,
                                ],
                              ),

                              RoundedButton(text: 'ยืนยัน', press: () async => await _onSubmit()),
                            ],
                          ),
                        ],
                      ),
                    );
                  })
                ],
              ),
            ),
          ),
          // ! Smooth Indicator

          CreateStoreAnimatedSmoothIndicator(),

          // ignore: todo
          // TODO: Back page button
          // if (widget.backArrowButton != null && widget.backArrowButton)
          Positioned(
            child: ClipOval(
              child: Material(
                color: Colors.white.withOpacity(0.3),
                child: InkWell(
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.arrow_back_rounded),
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            top: size.height * 0.04,
            left: size.height * 0.04,
          ),
        ],
      ),
    );
  }
}

class CreateStoreAnimatedSmoothIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Positioned(
      width: size.width,
      bottom: size.height * 0.07,
      child: Center(
        child: Container(child: Consumer<CreateStoreModel>(
          builder: (_, createStoreModel, c) {
            return AnimatedSmoothIndicator(
              activeIndex: createStoreModel.getCurrentIndexPage,
              count: 2,
              effect: ExpandingDotsEffect(
                activeDotColor: kPrimaryColor.withOpacity(0.75),
                dotColor: kTextSecondaryColor.withOpacity(0.2),
                dotHeight: size.height * 0.0175,
                dotWidth: size.height * 0.0175,
                expansionFactor: 2,
              ),
            );
          },
        )),
      ),
    );
  }
}
