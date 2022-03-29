import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:woocommerce/models/product_category.dart';
import 'package:woostore_pro/screens/categories/widgets/verticalTabs.dart';

import '../../../controllers/navigationController.dart';
import '../../../shared/image/extendedCachedImage.dart';
import '../../../themes/colors.dart';
import '../../../themes/themeGuide.dart';

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
    for (int i = 0; i < DsCategoryTree.length; i++) {
      tabs.add(Tab(
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            //width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Text(
                DsCategoryTree[i].name,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'CeraRound',
                ),
              ),
            ),
          ),
        ),
      ));
      content.add(CategoriesContent(i: i));
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
          indicatorColor: Colors.blue.shade900,
          selectedTabBackgroundColor: AppColors.backgroundLight,
          backgroundColor: Colors.indigoAccent,
          tabBackgroundColor: Colors.white,
          indicatorSide: IndicatorSide.start,
          // unselectedTabBackgroundColor: Colors.grey[200],
          indicatorWidth: 5,
          initialIndex: 0,
          contentScrollAxis: Axis.vertical,
          tabsWidth: 120,
          disabledChangePageFromContentView: true,
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

class CategoriesContent extends StatelessWidget {
  const CategoriesContent({
    Key key,
    @required this.i,
  }) : super(key: key);

  final int i;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: AppColors.backgroundLight,
      //            itemCount: catList[i]["subCat"].length,
      child: Padding(
        padding: const EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 4),
        child: ListView.builder(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemCount: DsCategoryTree[i].secCat.length,
            itemBuilder: (x, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.backgroundLight,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          //color: Colors.teal.shade50,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 4),
                            child: Text(
                              DsCategoryTree[i].secCat[index].name,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'CeraRound',
                              ),
                            ),
                          ),
                        ),
                        // Divider(
                        //   color: Colors.grey[300],
                        // ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 4),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount:
                            DsCategoryTree[i].secCat[index].thirdCats.length,
                            itemBuilder: (BuildContext context, int i2) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 2),
                                child: InkWell(
                                  onTap: () {
                                    NavigationController.navigator.push(
                                      CategorisedProductsRoute(category: DsCategoryTree[i].secCat[index]
                                          .thirdCats[i2]),
                                    );
                                  },
                                  child: new Container(
                                    //padding: ThemeGuide.padding5,
                                    decoration: BoxDecoration(
                                      color: theme.backgroundColor,
                                      borderRadius: ThemeGuide.borderRadius5,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            DsCategoryTree[i].secCat[index]
                                                .thirdCats[i2].name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            size: 18,
                                            color: Colors.grey.shade400,
                                          )
                                        ],
                                      ),
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
    );
  }
}
class PrimaryCategory{
  int id ;
  String name ;
  List<SecondaryCategory> secCat;
  PrimaryCategory({this.id, this.name, this.secCat});
}


class SecondaryCategory{
  int id ;
  String name ;
  List<WooProductCategory> thirdCats;
  SecondaryCategory({this.id, this.name, this.thirdCats});
}


List<PrimaryCategory> DsCategoryTree =[
  PrimaryCategory(id: 1,name: 'Restorative',secCat: [
    SecondaryCategory(id: 1,name: 'Consumables',thirdCats:[
      const WooProductCategory(id: 58,name:'Composite')
    ] )
  ]),
];

