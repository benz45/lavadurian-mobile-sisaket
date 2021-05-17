import 'dart:async';

import 'package:LavaDurian/Screens/Operation/operation_screen.dart';
import 'package:LavaDurian/Screens/Register_Success/components/background.dart';
import 'package:LavaDurian/Screens/UploadImageProductScreen/upload_image_product_screen.dart';
import 'package:LavaDurian/components/rounded_button.dart';
import 'package:LavaDurian/components/rounded_input_field.dart';
import 'package:LavaDurian/components/showSnackBar.dart';
import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/createProduct_model.dart';
import 'package:LavaDurian/models/profile_model.dart';
import 'package:LavaDurian/models/setting_model.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:http/http.dart' as Http;
import 'dart:convert';
import 'dart:io';

class Body extends StatefulWidget {
  final bool backArrowButton;
  final int storeID;

  Body({this.backArrowButton, @required this.storeID});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // ! Controller text data
  CreateProductModel initCreateProductModel;
  UserModel initUserModel;

  final _textProductValue = TextEditingController();
  final _textProductWeight = TextEditingController();
  final _textProductPrice = TextEditingController();
  final _textProductDetail = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Start listening to changes.
    initCreateProductModel = context.read<CreateProductModel>();

    initUserModel = context.read<UserModel>();

    // Controller textfield product value (จำนวนลูกทุเรียนกที่มีขาย)
    _textProductValue.addListener(_onChangeTextProductValue);

    // Controller textfield product weight (น้ำหนักทุเรียน)
    _textProductWeight.addListener(_onChangeTextProductWeight);

    // Controller textfield product price (ราคาทุเรียน)
    _textProductPrice.addListener(_onChangeTextProductPrice);

    // Controller textfield product detail (รายละเอียดสินค้า)
    _textProductDetail.addListener(_onChangeProductDetail);
  }

  _onChangeProductDetail() {
    initCreateProductModel.setProductDetail = _textProductDetail.text;
  }

  _onChangeTextProductValue() {
    initCreateProductModel.setProductValue = _textProductValue.text;
  }

  _onChangeTextProductWeight() {
    initCreateProductModel.setProductWeight = _textProductWeight.text;
  }

  _onChangeTextProductPrice() {
    initCreateProductModel.setProductPrice = _textProductPrice.text;
  }

  // Carousel controller.
  CarouselController carouselController = CarouselController();

  // Input  Formater Limit 250.
  List<TextInputFormatter> limitingTextInput = [LengthLimitingTextInputFormatter(250)];

  @override
  Widget build(BuildContext context) {
    // Provider model.
    ProductModel productModel = Provider.of<ProductModel>(context, listen: false);
    CreateProductModel createProductModel = Provider.of<CreateProductModel>(context);
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
      createProductModel.setCurrentIndexPage = page;
    }

    // Size for custom screen.
    Size size = MediaQuery.of(context).size;
    final font = Theme.of(context).textTheme;

    // ! Validate data page one
    Future _valdatatePageOne() async {
      if (createProductModel.getChosenGene == null || createProductModel.getChosenGene == "") {
        showFlashBar(context, message: 'กรุณาเลือกสายพันธ์ุทุเรียน', warning: true);

        if (createProductModel.getCurrentIndexPage != 0) {
          carouselControllerAnimateToPage(0);
        }
        return false;
      }

      if (createProductModel.getChosenGrade == null || createProductModel.getChosenGrade == "") {
        showFlashBar(context, message: 'กรุณาเลือกเกรดทุเรียน', warning: true);

        if (createProductModel.getCurrentIndexPage != 0) {
          carouselControllerAnimateToPage(0);
        }
        return false;
      }

      if (createProductModel.getProductDetail == null || createProductModel.getProductDetail == "") {
        showFlashBar(context, message: 'กรุณาระบุข้อมูลเกี่ยวกับสินค้า', warning: true);
        if (createProductModel.getCurrentIndexPage != 0) {
          carouselControllerAnimateToPage(0);
        }
        return false;
      }
      // * Validate data page one success!
      return true;
    }

    // ! Validate data page two
    Future _valdatatePageTwo() async {
      if (createProductModel.getChosenStatus == null || createProductModel.getChosenStatus == "") {
        showFlashBar(context, message: 'กรุณาสถานะการขาย', warning: true);
        if (createProductModel.getCurrentIndexPage != 1) {
          carouselControllerAnimateToPage(1);
        }
        return false;
      }

      if (createProductModel.getProductValue == null) {
        showFlashBar(context, message: 'กรุณาระบุจำนวนทุเรียนที่มีขาย', warning: true);

        if (createProductModel.getCurrentIndexPage != 1) {
          carouselControllerAnimateToPage(1);
          return false;
        }
        return false;
      } else if (createProductModel.getProductValue.length > 8) {
        // จำนวนไม่เกิน 10^7 ลูก
        showFlashBar(context, message: 'กรุณาระบุจำนวนทุเรียนตามความเป็นจริง', warning: true);
        return false;
      }

      if (createProductModel.getProductWeight == null || createProductModel.getProductWeight == "") {
        showFlashBar(context, message: 'กรุณาระบุน้ำหนักของทุเรียน', warning: true);

        if (createProductModel.getCurrentIndexPage != 1) {
          carouselControllerAnimateToPage(1);
          return false;
        }
        return false;
      } else if (createProductModel.getProductWeight.length > 5) {
        // น้ำหนักไม่เกิน 99.99 กก.
        showFlashBar(context, message: 'กรุณาระบุน้ำหนักทุเรียนตามความเป็นจริง', warning: true);
        return false;
      }

      if (createProductModel.getProductPrice == null || createProductModel.getProductPrice == "") {
        showFlashBar(context, message: 'กรุณาระบุราคาของทุเรียน', warning: true);

        if (createProductModel.getCurrentIndexPage != 1) {
          carouselControllerAnimateToPage(1);
          return false;
        }
        return false;
      } else if (createProductModel.getProductPrice.length > 8) {
        // จำนวนไม่เกิน 10^7 ลูก
        showFlashBar(context, message: 'กรุณาระบุราคาทุเรียนตามความเป็นจริง', warning: true);
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
        // get current user token
        String token = settingModel.value['token'];

        Map<String, dynamic> data = {
          'store_id': widget.storeID.toString(),
          'grade': productModel.productGrade.keys.firstWhere((k) => productModel.productGrade[k] == createProductModel.getChosenGrade),
          'gene': productModel.productGene.keys.firstWhere((k) => productModel.productGene[k] == createProductModel.getChosenGene),
          'values': createProductModel.getProductValue.toString(),
          'price': createProductModel.getProductPrice.toString(),
          'weight': createProductModel.getProductWeight.toString(),
          'desc': createProductModel.getProductDetail.toString(),
          'status': productModel.productStatus.keys.firstWhere((k) => productModel.productStatus[k] == createProductModel.getChosenStatus),
        };

        try {
          final response = await Http.post(
            '${settingModel.baseURL}/${settingModel.endPointAddProduct}',
            body: data,
            headers: {HttpHeaders.authorizationHeader: "Token $token"},
          );

          var jsonData = jsonDecode(utf8.decode(response.bodyBytes));

          if (jsonData['status']) {
            // Set new product to list
            List<Map<String, dynamic>> products = productModel.products;
            products.add(jsonData['data']['product']);

            // update state
            productModel.products = products;

            createProductModel.clear();

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductImageUpload(
                  productId: jsonData['data']['product']['id'],
                  onPressed: () {
                    showFlashBar(context,
                        title: 'สร้างสินค้าสำเร็จ', message: 'ระบบกำลังอัพเดทข้อมูลและเผยแผร่ไปยังผู้ซื้อ', success: true, duration: 3500);
                    // * Navigate operation screen and show snackbar create store success
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                      builder: (_) {
                        return Scaffold(
                          key: _scaffoldKey,
                          body: OperationScreen(),
                        );
                      },
                    ), (Route<dynamic> route) => false);
                  },
                ),
              ),
            );
          } else {
            showFlashBar(context, message: 'บันทึกข้อมูลไม่สำเร็จ', error: true);
          }
        } catch (e) {
          showFlashBar(context, message: 'เกิดข้อผิดพลาดไม่สามารถสร้างสินค้าได้', error: true);
        }
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
                            "สร้างสินค้าของคุณ",
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
                  Consumer<CreateProductModel>(builder: (_, consumerCreateProductModel, c) {
                    return Container(
                      child: CarouselSlider(
                        carouselController: carouselController,
                        options: CarouselOptions(
                            viewportFraction: 1.0,
                            initialPage: 0,
                            enableInfiniteScroll: false,
                            height: size.height * 0.6,
                            onPageChanged: (index, reason) {
                              consumerCreateProductModel.setCurrentIndexPage = index;
                            }),
                        items: [
                          // ! Page 1
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (context) {
                                      // * Init state dialog only.
                                      int selectedRadio = productModel.productGene.entries
                                              .map((e) => "${e.value}")
                                              .toList()
                                              .indexOf(consumerCreateProductModel.getChosenGene) ??
                                          0;

                                      return AlertDialog(
                                        title: Text(
                                          'สายพันธุ์',
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
                                                itemCount: productModel.productGene.entries.map((e) => e.key).toList().length,
                                                itemBuilder: (context, index) {
                                                  return RadioListTile(
                                                    title: Text(
                                                      '${productModel.productGene.entries.map((e) => "${e.value}").toList()[index]}'
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
                                                      consumerCreateProductModel.setChosenGene =
                                                          productModel.productGene.entries.map((e) => "${e.value}").toList()[value];
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
                                          '${consumerCreateProductModel.getChosenGene ?? 'สายพันธุ์'}',
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
                              // * Grade
                              GestureDetector(
                                onTap: () {
                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (context) {
                                      // * Init state dialog only.
                                      int selectedRadio = productModel.productGrade.entries
                                              .map((e) => "${e.value}")
                                              .toList()
                                              .indexOf(consumerCreateProductModel.getChosenGrade) ??
                                          0;

                                      return AlertDialog(
                                        title: Text(
                                          'เกรดทุเรียน',
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
                                                itemCount: productModel.productGrade.entries.map((e) => e.key).toList().length,
                                                itemBuilder: (context, index) {
                                                  return RadioListTile(
                                                    title: Text(
                                                      '${productModel.productGrade.entries.map((e) => "${e.value}").toList()[index]}'
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
                                                      consumerCreateProductModel.setChosenGrade =
                                                          productModel.productGrade.entries.map((e) => "${e.value}").toList()[value];
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
                                          '${consumerCreateProductModel.getChosenGrade ?? 'เกรดทุเรียน'}',
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

                              // * _productDetail
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
                                  maxLines: 3,
                                  textInputAction: TextInputAction.next,
                                  controller: _textProductDetail,
                                  decoration: InputDecoration(
                                    hintText: 'รายละเอียดเกี่ยวกับสินค้า',
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
                                    consumerCreateProductModel.setCurrentIndexPage = (consumerCreateProductModel.getCurrentIndexPage) + 1;
                                  } else {
                                    showFlashBar(context, message: 'กรุณาระบุข้อมูลให้ครบถ้วนตามความเป็นจริง', warning: true);
                                  }
                                },
                              ),
                            ],
                          ),

                          // ! Page 2
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              //  * _productStatus
                              GestureDetector(
                                onTap: () {
                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (context) {
                                      // * Init state dialog only.
                                      int selectedRadio = productModel.productStatus.entries
                                              .map((e) => "${e.value}")
                                              .toList()
                                              .indexOf(consumerCreateProductModel.getChosenStatus) ??
                                          0;

                                      return AlertDialog(
                                        title: Text(
                                          'สถานะการขาย',
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
                                                itemCount: productModel.productStatus.entries.map((e) => e.key).toList().length,
                                                itemBuilder: (context, index) {
                                                  return RadioListTile(
                                                    title: Text(
                                                      '${productModel.productStatus.entries.map((e) => "${e.value}").toList()[index]}'
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
                                                      consumerCreateProductModel.setChosenStatus =
                                                          productModel.productStatus.entries.map((e) => "${e.value}").toList()[value];
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
                                          '${consumerCreateProductModel.getChosenStatus ?? 'สถานะการขาย'}',
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
                              //  * _productValue
                              RoundedInputField(
                                hintText: "จำนวนที่มีขาย (ลูก)",
                                icon: Icons.drag_indicator_outlined,
                                controller: _textProductValue,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly], // Onl
                              ),

                              //  * _productWeight
                              RoundedInputField(
                                hintText: "น้ำหนักเฉลี่ยต่อลูก (กิโลกรัม)",
                                icon: Icons.snooze_outlined,
                                controller: _textProductWeight,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))], // Onl
                              ),
                              //  * _productPrice
                              RoundedInputField(
                                hintText: "ราคาต่อกิโลกรัม (บาท)",
                                icon: Icons.money,
                                controller: _textProductPrice,
                                textInputAction: TextInputAction.go,
                                keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly], // Onl
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

          CreateProductAnimatedSmoothIndicator(),
          // ! Back page button
          /* if (widget.backArrowButton != null && widget.backArrowButton)
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
            ), */
        ],
      ),
    );
  }
}

class CreateProductAnimatedSmoothIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Positioned(
      width: size.width,
      bottom: size.height * 0.07,
      child: Center(
        child: Container(child: Consumer<CreateProductModel>(
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
