import 'package:flutter/material.dart';

class CustomSearchBarWidget extends StatelessWidget {
  final bool searching;
  final Function? onTextChanged;
  final VoidCallback? onCancelSearch;
  final TextEditingController? textEditingController;

  const CustomSearchBarWidget({
    super.key,
    required this.searching,
    this.onTextChanged,
    this.onCancelSearch,
    this.textEditingController,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: false,
      pinned: false,
      automaticallyImplyLeading: false,
      expandedHeight: 100.h,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(bottom: 16.h, left: 16.w, right: 16.w),
        title: SizedBox(
          height: 40,
          child: TextField(
            onChanged: (value) {
              onTextChanged?.call(value);
            },
            controller: textEditingController,
            style: TextStyle(
              decoration: TextDecoration.none,
              decorationThickness: 0,
              fontSize: 14.sp,
            ),
            decoration: InputDecoration(
              hintText: context.searchBreadHint,
              hintStyle: TextStyle(fontSize: 12.sp, color: Colors.grey),
              filled: true,
              prefixIcon: searching
                  ? GestureDetector(
                      onTap: () {
                        onCancelSearch?.call();
                      },
                      child: Icon(Icons.clear),
                    )
                  : Icon(
                      Icons.search,
                    ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
