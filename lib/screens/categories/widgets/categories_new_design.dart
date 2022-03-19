import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:woostore_pro/screens/categories/widgets/verticalTabs.dart';

import '../../../themes/colors.dart';

class CategoriesNewDesign extends StatelessWidget {
  const CategoriesNewDesign({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Categories(),
    );
  }
}

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  var styles = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w100,
    fontFamily: 'CeraRound',
  );
  List<Tab> tabs = [];
  List<Widget> content = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < catList.length; i++) {
      tabs.add(Tab(
        child: Container(
          height: 30,
          width: double.infinity,
          child: Center(
            child: Text(
              catList[i]["name"],
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w400,
                fontFamily: 'CeraRound',
              ),
            ),
          ),
        ),
      ));
      content.add(Container(
        //color: AppColors.lightGrey,
        //            itemCount: catList[i]["subCat"].length,
        child: Padding(
          padding: const EdgeInsets.only(top: 3, left: 2, right: 2, bottom: 4),
          child: ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: catList[i]["subCat"].length,
              itemBuilder: (x, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Colors.grey[300],
                          )),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 6, left: 6, right: 6),
                            child: Text(
                              catList[i]["subCat"][index]['name'],
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'CeraRound',
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.grey[300],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              itemCount:
                                  catList[i]["subCat"][index]['dubCat'].length,
                              gridDelegate:
                                  new SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2),
                              itemBuilder: (BuildContext context, int i2) {
                                return Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: InkWell(
                                    onTap: () {
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (_) =>
                                      //             SingleSubCatScreen(catList[i]
                                      //                     ["subCat"][index]
                                      //                 ['dubCat'][i2]['name'])));
                                    },
                                    child: new Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              color: Colors.white,
                                              child: CachedNetworkImage(
                                                height: double.infinity,
                                                width: double.infinity,
                                                imageUrl: catList[i]["subCat"]
                                                        [index]['dubCat'][i2]
                                                    ['image'],
                                                //placeholder: (context, url) => CircularProgressIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text(
                                              catList[i]["subCat"][index]
                                                  ['dubCat'][i2]['name'],
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'CeraRound',
                                              ),
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              overflow: TextOverflow.fade,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // child: new Text(data[index]
                                      //     ['image']), //just for testing, will fill with image later
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      )),
                );
              }),
        ),
      ));
    }
  }

/* */
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Material(
        child: VerticalTabs(
          tabTextStyle: TextStyle(),
          tabsShadowColor: Colors.grey[200],
          indicatorColor: Colors.deepOrange,
          selectedTabBackgroundColor: Colors.teal.shade50,
          backgroundColor: Colors.indigoAccent,
          tabBackgroundColor: Colors.white,
          indicatorSide: IndicatorSide.start,
          // unselectedTabBackgroundColor: Colors.grey[200],
          indicatorWidth: 5,
          initialIndex: 0,
          contentScrollAxis: Axis.vertical,
          tabsWidth: 120,disabledChangePageFromContentView: true,
          tabs: tabs,
          contents: content,
        ),
      ),
    );
  }

  Widget tabsContent(String caption, [String description = '']) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(20),
      color: Colors.black12,
      child: Column(
        children: <Widget>[
          Text(
            caption,
            style: TextStyle(fontSize: 25),
          ),
          Divider(
            height: 20,
            color: Colors.black45,
          ),
          Text(
            description,
            style: TextStyle(fontSize: 15, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

List catList = [
  {
    "id": "1",
    "name": "Restorative",
    "image":
        "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
    'subCat': [
      {
        "id": "1",
        "name": "Consumables",
        "image":
            "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
        'dubCat': [
          {
            "id": "1",
            "name": "Composite",
            "image":
                "https://images.dentalkart.com/media/catalog/product/m/e/metaceraseal10.jpg",
          },
          {
            "id": "2",
            "name": "Acid Etch&bonding Agents",
            "image":
                "https://images.dentalkart.com/media/catalog/product/m/e/metaceraseal10.jpg",
          },
          {
            "id": "3",
            "name": "Amalgam",
            "image":
                "https://images.dentalkart.com/media/catalog/product/m/e/metaceraseal10.jpg",
          },
          {
            "id": "4",
            "name": "GLASS Ionomer &Cements",
            "image":
                "https://images.dentalkart.com/media/catalog/product/m/e/metaceraseal10.jpg",
          },
          {
            "id": "5",
            "name": "Base Liners",
            "image":
                "https://images.dentalkart.com/media/catalog/product/m/e/metaceraseal10.jpg",
          },
          {
            "id": "6",
            "name": "Matrix Materials &Wedges",
            "image":
                "https://images.dentalkart.com/media/catalog/product/m/e/metaceraseal10.jpg",
          },
          {
            "id": "7",
            "name": "Isolation Materials",
            "image":
                "https://images.dentalkart.com/media/catalog/product/m/e/metaceraseal10.jpg",
          },
          {
            "id": "8",
            "name": "Finishing & Polidhing",
            "image":
                "https://images.dentalkart.com/media/catalog/product/m/e/metaceraseal10.jpg",
          },
          {
            "id": "9",
            "name": "Bleaching Kits",
            "image":
                "https://images.dentalkart.com/media/catalog/product/m/e/metaceraseal10.jpg",
          },
          {
            "id": "10",
            "name": "Caries Detectors",
            "image":
                "https://images.dentalkart.com/media/catalog/product/m/e/metaceraseal10.jpg",
          },
          {
            "id": "11",
            "name": "Temporary Fillings",
            "image":
                "https://images.dentalkart.com/media/catalog/product/m/e/metaceraseal10.jpg",
          },
          {
            "id": "12",
            "name": "Dental Burs",
            "image":
                "https://images.dentalkart.com/media/catalog/product/m/e/metaceraseal10.jpg",
          },
          {
            "id": "13",
            "name": "Crown Forms",
            "image":
                "https://images.dentalkart.com/media/catalog/product/m/e/metaceraseal10.jpg",
          },
          {
            "id": "14",
            "name": "Prevention",
            "image":
                "https://images.dentalkart.com/media/catalog/product/m/e/metaceraseal10.jpg",
          },
        ]
      },
      {
        "id": "2",
        "name": "Instruments",
        "image":
            "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
        'dubCat': [
          {
            "id": "1",
            "name": "MAT1",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "2",
            "name": "MAT2",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "3",
            "name": "MAT3",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "4",
            "name": "MAT4",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
        ]
      },
      {
        "id": "3",
        "name": "Equipment",
        "image":
            "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
        'dubCat': [
          {
            "id": "1",
            "name": "MAT1",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "2",
            "name": "MAT2",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "3",
            "name": "MAT3",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "4",
            "name": "MAT4",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
        ]
      },
    ]
  },
  {
    "id": "2",
    "name": "Endodontics",
    "image":
        "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
    'subCat': [
      {
        "id": "1",
        "name": "Consumables",
        "image":
            "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
        'dubCat': [
          {
            "id": "1",
            "name": "MAT1",
            "image":
                "https://images.dentalkart.com/media/catalog/product/m/e/metaceraseal10.jpg",
          },
          {
            "id": "2",
            "name": "MAT2",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "3",
            "name": "MAT3",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/u/gutta-percha-6_-2.jpg",
          },
          {
            "id": "4",
            "name": "MAT4",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/p/gp_point_diadent.jpg",
          },
        ]
      },
      {
        "id": "2",
        "name": "Instruments",
        "image":
            "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
        'dubCat': [
          {
            "id": "1",
            "name": "MAT1",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "2",
            "name": "MAT2",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "3",
            "name": "MAT3",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "4",
            "name": "MAT4",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
        ]
      },
      {
        "id": "3",
        "name": "Equipment",
        "image":
            "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
        'dubCat': [
          {
            "id": "1",
            "name": "MAT1",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "2",
            "name": "MAT2",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "3",
            "name": "MAT3",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "4",
            "name": "MAT4",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
        ]
      },
    ]
  },
  {
    "id": "3",
    "name": "Prosthetics",
    "image":
        "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
    'subCat': [
      {
        "id": "1",
        "name": "Consumables",
        "image":
            "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
        'dubCat': [
          {
            "id": "1",
            "name": "MAT1",
            "image":
                "https://images.dentalkart.com/media/catalog/product/m/e/metaceraseal10.jpg",
          },
          {
            "id": "2",
            "name": "MAT2",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "3",
            "name": "MAT3",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/u/gutta-percha-6_-2.jpg",
          },
          {
            "id": "4",
            "name": "MAT4",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/p/gp_point_diadent.jpg",
          },
        ]
      },
      {
        "id": "2",
        "name": "Instruments",
        "image":
            "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
        'dubCat': [
          {
            "id": "1",
            "name": "MAT1",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "2",
            "name": "MAT2",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "3",
            "name": "MAT3",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "4",
            "name": "MAT4",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
        ]
      },
      {
        "id": "3",
        "name": "Equipment",
        "image":
            "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
        'dubCat': [
          {
            "id": "1",
            "name": "MAT1",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "2",
            "name": "MAT2",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "3",
            "name": "MAT3",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "4",
            "name": "MAT4",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
        ]
      },
    ]
  },
  {
    "id": "4",
    "name": "Perio & Surgery",
    "image":
        "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
    'subCat': [
      {
        "id": "1",
        "name": "Consumables",
        "image":
            "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
        'dubCat': [
          {
            "id": "1",
            "name": "MAT1",
            "image":
                "https://images.dentalkart.com/media/catalog/product/m/e/metaceraseal10.jpg",
          },
          {
            "id": "2",
            "name": "MAT2",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "3",
            "name": "MAT3",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/u/gutta-percha-6_-2.jpg",
          },
          {
            "id": "4",
            "name": "MAT4",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/p/gp_point_diadent.jpg",
          },
        ]
      },
      {
        "id": "2",
        "name": "Instruments",
        "image":
            "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
        'dubCat': [
          {
            "id": "1",
            "name": "MAT1",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "2",
            "name": "MAT2",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "3",
            "name": "MAT3",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "4",
            "name": "MAT4",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
        ]
      },
      {
        "id": "3",
        "name": "Equipment",
        "image":
            "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
        'dubCat': [
          {
            "id": "1",
            "name": "MAT1",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "2",
            "name": "MAT2",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "3",
            "name": "MAT3",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "4",
            "name": "MAT4",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
        ]
      },
    ]
  },
  {
    "id": "5",
    "name": "Implant",
    "image":
        "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
    'subCat': [
      {
        "id": "1",
        "name": "Consumables",
        "image":
            "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
        'dubCat': [
          {
            "id": "1",
            "name": "MAT1",
            "image":
                "https://images.dentalkart.com/media/catalog/product/m/e/metaceraseal10.jpg",
          },
          {
            "id": "2",
            "name": "MAT2",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "3",
            "name": "MAT3",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/u/gutta-percha-6_-2.jpg",
          },
          {
            "id": "4",
            "name": "MAT4",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/p/gp_point_diadent.jpg",
          },
        ]
      },
      {
        "id": "2",
        "name": "Instruments",
        "image":
            "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
        'dubCat': [
          {
            "id": "1",
            "name": "MAT1",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "2",
            "name": "MAT2",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "3",
            "name": "MAT3",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "4",
            "name": "MAT4",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
        ]
      },
      {
        "id": "3",
        "name": "Equipment",
        "image":
            "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
        'dubCat': [
          {
            "id": "1",
            "name": "MAT1",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "2",
            "name": "MAT2",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "3",
            "name": "MAT3",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "4",
            "name": "MAT4",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
        ]
      },
    ]
  },
  {
    "id": "6",
    "name": "Orthodontics",
    "image":
        "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
    'subCat': [
      {
        "id": "1",
        "name": "Consumables",
        "image":
            "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
        'dubCat': [
          {
            "id": "1",
            "name": "MAT1",
            "image":
                "https://images.dentalkart.com/media/catalog/product/m/e/metaceraseal10.jpg",
          },
          {
            "id": "2",
            "name": "MAT2",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "3",
            "name": "MAT3",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/u/gutta-percha-6_-2.jpg",
          },
          {
            "id": "4",
            "name": "MAT4",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/p/gp_point_diadent.jpg",
          },
        ]
      },
      {
        "id": "2",
        "name": "Instruments",
        "image":
            "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
        'dubCat': [
          {
            "id": "1",
            "name": "MAT1",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "2",
            "name": "MAT2",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "3",
            "name": "MAT3",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "4",
            "name": "MAT4",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
        ]
      },
      {
        "id": "3",
        "name": "Equipment",
        "image":
            "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
        'dubCat': [
          {
            "id": "1",
            "name": "MAT1",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "2",
            "name": "MAT2",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "3",
            "name": "MAT3",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "4",
            "name": "MAT4",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
        ]
      },
    ]
  },
  {
    "id": "7",
    "name": "Consumables",
    "image":
        "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
    'subCat': [
      {
        "id": "1",
        "name": "Consumables",
        "image":
            "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
        'dubCat': [
          {
            "id": "1",
            "name": "MAT1",
            "image":
                "https://images.dentalkart.com/media/catalog/product/m/e/metaceraseal10.jpg",
          },
          {
            "id": "2",
            "name": "MAT2",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "3",
            "name": "MAT3",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/u/gutta-percha-6_-2.jpg",
          },
          {
            "id": "4",
            "name": "MAT4",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/p/gp_point_diadent.jpg",
          },
        ]
      },
      {
        "id": "2",
        "name": "Instruments",
        "image":
            "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
        'dubCat': [
          {
            "id": "1",
            "name": "MAT1",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "2",
            "name": "MAT2",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "3",
            "name": "MAT3",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "4",
            "name": "MAT4",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
        ]
      },
      {
        "id": "3",
        "name": "Equipment",
        "image":
            "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
        'dubCat': [
          {
            "id": "1",
            "name": "MAT1",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "2",
            "name": "MAT2",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "3",
            "name": "MAT3",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "4",
            "name": "MAT4",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
        ]
      },
    ]
  },
  {
    "id": "8",
    "name": "Instruments",
    "image":
        "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
    'subCat': [
      {
        "id": "1",
        "name": "Consumables",
        "image":
            "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
        'dubCat': [
          {
            "id": "1",
            "name": "MAT1",
            "image":
                "https://images.dentalkart.com/media/catalog/product/m/e/metaceraseal10.jpg",
          },
          {
            "id": "2",
            "name": "MAT2",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "3",
            "name": "MAT3",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/u/gutta-percha-6_-2.jpg",
          },
          {
            "id": "4",
            "name": "MAT4",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/p/gp_point_diadent.jpg",
          },
        ]
      },
      {
        "id": "2",
        "name": "Instruments",
        "image":
            "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
        'dubCat': [
          {
            "id": "1",
            "name": "MAT1",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "2",
            "name": "MAT2",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "3",
            "name": "MAT3",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "4",
            "name": "MAT4",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
        ]
      },
      {
        "id": "3",
        "name": "Equipment",
        "image":
            "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
        'dubCat': [
          {
            "id": "1",
            "name": "MAT1",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "2",
            "name": "MAT2",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "3",
            "name": "MAT3",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "4",
            "name": "MAT4",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
        ]
      },
    ]
  },
  {
    "id": "9",
    "name": "Equipment",
    "image":
        "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
    'subCat': [
      {
        "id": "1",
        "name": "Consumables",
        "image":
            "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
        'dubCat': [
          {
            "id": "1",
            "name": "MAT1",
            "image":
                "https://images.dentalkart.com/media/catalog/product/m/e/metaceraseal10.jpg",
          },
          {
            "id": "2",
            "name": "MAT2",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "3",
            "name": "MAT3",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/u/gutta-percha-6_-2.jpg",
          },
          {
            "id": "4",
            "name": "MAT4",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/p/gp_point_diadent.jpg",
          },
        ]
      },
      {
        "id": "2",
        "name": "Instruments",
        "image":
            "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
        'dubCat': [
          {
            "id": "1",
            "name": "MAT1",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "2",
            "name": "MAT2",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "3",
            "name": "MAT3",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "4",
            "name": "MAT4",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
        ]
      },
      {
        "id": "3",
        "name": "Equipment",
        "image":
            "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
        'dubCat': [
          {
            "id": "1",
            "name": "MAT1",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "2",
            "name": "MAT2",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "3",
            "name": "MAT3",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "4",
            "name": "MAT4",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
        ]
      },
    ]
  },
  {
    "id": "10",
    "name": "Dental LAB",
    "image":
        "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
    'subCat': [
      {
        "id": "1",
        "name": "Consumables",
        "image":
            "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
        'dubCat': [
          {
            "id": "1",
            "name": "MAT1",
            "image":
                "https://images.dentalkart.com/media/catalog/product/m/e/metaceraseal10.jpg",
          },
          {
            "id": "2",
            "name": "MAT2",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "3",
            "name": "MAT3",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/u/gutta-percha-6_-2.jpg",
          },
          {
            "id": "4",
            "name": "MAT4",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/p/gp_point_diadent.jpg",
          },
        ]
      },
      {
        "id": "2",
        "name": "Instruments",
        "image":
            "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
        'dubCat': [
          {
            "id": "1",
            "name": "MAT1",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "2",
            "name": "MAT2",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "3",
            "name": "MAT3",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "4",
            "name": "MAT4",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
        ]
      },
      {
        "id": "3",
        "name": "Equipment",
        "image":
            "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
        'dubCat': [
          {
            "id": "1",
            "name": "MAT1",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "2",
            "name": "MAT2",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "3",
            "name": "MAT3",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "4",
            "name": "MAT4",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
        ]
      },
    ]
  },
  {
    "id": "11",
    "name": "Services & More",
    "image":
        "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
    'subCat': [
      {
        "id": "1",
        "name": "Consumables",
        "image":
            "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
        'dubCat': [
          {
            "id": "1",
            "name": "MAT1",
            "image":
                "https://images.dentalkart.com/media/catalog/product/m/e/metaceraseal10.jpg",
          },
          {
            "id": "2",
            "name": "MAT2",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "3",
            "name": "MAT3",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/u/gutta-percha-6_-2.jpg",
          },
          {
            "id": "4",
            "name": "MAT4",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/p/gp_point_diadent.jpg",
          },
        ]
      },
      {
        "id": "2",
        "name": "Instruments",
        "image":
            "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
        'dubCat': [
          {
            "id": "1",
            "name": "MAT1",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "2",
            "name": "MAT2",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "3",
            "name": "MAT3",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "4",
            "name": "MAT4",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
        ]
      },
      {
        "id": "3",
        "name": "Equipment",
        "image":
            "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
        'dubCat': [
          {
            "id": "1",
            "name": "MAT1",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "2",
            "name": "MAT2",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "3",
            "name": "MAT3",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
          {
            "id": "4",
            "name": "MAT4",
            "image":
                "https://images.dentalkart.com/media/catalog/product/g/c/gc_soft_liner_1.jpg",
          },
        ]
      },
    ]
  },
];
