import 'package:bookkart_flutter/models/dashboard/dashboard_category.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import 'category_book_component.dart';

class CategoryWiseBookComponent extends StatelessWidget {
  final List<DashboardCategory> categoryList;

  CategoryWiseBookComponent({required this.categoryList, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (categoryList.validate().isEmpty) return Offstage();
    return AnimatedListView(
      itemCount: categoryList.length,
      shrinkWrap: true,
      padding: EdgeInsets.all(0),
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return CategoryBookComponent(categoryBookData: categoryList.validate()[index]);
      },
    );
  }
}
