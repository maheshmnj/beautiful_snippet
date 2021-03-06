import 'package:beautiful_snippet/exports.dart';
import 'package:beautiful_snippet/models/specsmodel.dart';
import 'package:beautiful_snippet/widgets/bs_dropdown.dart';
import 'package:beautiful_snippet/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SideBar extends StatefulWidget {
  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  Widget _headerBuilder(String title, {Widget? child}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$title',
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: font_h5),
        ),
        child ?? Container()
      ],
    );
  }

  Widget _colorsSelector(Color selectedColor, Function(Color) onChange,
      {List<Color>? colors}) {
    if (colors == null || colors.isEmpty) {
      colors = borderColors;
    }
    return Wrap(
      spacing: 10,
      runSpacing: 5,
      children: List.generate(
          colors.length,
          (x) => GestureDetector(
                onTap: () => onChange(colors![x]),
                child: Container(
                  decoration: BoxDecoration(
                      color: colors![x],
                      border: selectedColor == colors[x]
                          ? Border.all(color: Colors.deepPurple, width: 2)
                          : null),
                  height: 50,
                  width: 50,
                ),
              )),
    );
  }

  late SpecsModel specs;
  @override
  void initState() {
    // TODO: implement initState
    specs = Provider.of<SpecsModel>(context, listen: false);
    selectedTab = titles[0];
    currentSelectedLanguage = specs.language;
    currentSelectedTheme = specs.codeTheme;
    super.initState();
  }

  Widget _tab(String title, bool isSelected, Function(String)? ontap) {
    return Expanded(
      child: GestureDetector(
        onTap: () => ontap!(title),
        child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: isSelected ? grey.withOpacity(0.5) : null,
                borderRadius: BorderRadius.circular(4)),
            padding: const EdgeInsets.symmetric(
                horizontal: padding_small, vertical: 12),
            child: Icon(title == 'Code' ? Icons.code : Icons.color_lens,
                color: isSelected ? black : grey)),
      ),
    );
  }

  Widget _headerTabsBuilder(
      String selected, List<String> titles, Function(String) onChange) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
          titles.length,
          (x) => _tab(
              titles[x], selected == titles[x], (title) => onChange(title))),
    );
  }

  Widget _bodyTabsBuilder(String headerTitle) {
    switch (headerTitle) {
      case 'Snippet':
        return _backgroundTab();
      case 'Code':
        return Column(
          children: [
            SizedBox(
              height: padding_small,
            ),
            _headerBuilder('Language'),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: padding_small),
                child: BsDropdownMenu(
                  selected: currentSelectedLanguage,
                  items: languages,
                  onSelected: (x) {
                    specs.language = x.toLowerCase();
                    setState(() {
                      currentSelectedLanguage = x;
                    });
                  },
                )),
            _headerBuilder('Theme'),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: padding_small),
                child: BsDropdownMenu(
                  selected: currentSelectedTheme,
                  items: themes,
                  onSelected: (x) {
                    specs.codeTheme = x;
                    setState(() {
                      currentSelectedTheme = x;
                    });
                  },
                )),
          ],
        );
      default:
        return Container();
    }
  }

  Widget _headerTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.symmetric(vertical: padding_small),
            decoration: BoxDecoration(
                color: lightGrey, borderRadius: BorderRadius.circular(5)),
            padding: const EdgeInsets.all(padding_small),
            child: _colorsSelector(specs.snippetHeaderColor, (x) {
              specs.snippetHeaderColor = x;
            }, colors: snippetHeaderColors)),
      ],
    );
  }

  Widget _backgroundTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: padding_small),
          child: _headerBuilder('Border',
              child: CupertinoSwitch(
                value: specs.hasBorder,
                onChanged: (x) {
                  specs.hasBorder = x;
                },
              )),
        ),
        specs.hasBorder
            ? Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: lightGrey, borderRadius: BorderRadius.circular(5)),
                padding: const EdgeInsets.symmetric(vertical: padding_medium),
                margin: EdgeInsets.only(bottom: padding_small),
                child: _colorsSelector(specs.borderColor, (x) {
                  specs.borderColor = x;
                }, colors: borderColors))
            : Container(),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: _headerBuilder(
            'Snippet Header',
          ),
        ),
        _headerTab(),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: _headerBuilder(
            'Snippet Background',
          ),
        ),
        Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                color: lightGrey, borderRadius: BorderRadius.circular(5)),
            margin: EdgeInsets.symmetric(vertical: padding_small),
            padding: const EdgeInsets.all(
              padding_medium,
            ),
            child: _colorsSelector(specs.snippetBackgroundColor, (x) {
              specs.snippetBackgroundColor = x;
            }, colors: snippetBackgroundColors)),
      ],
    );
  }

  late String currentSelectedLanguage;
  late String currentSelectedTheme;
  List<String> titles = [
    'Code',
    'Snippet',
  ];
  late String selectedTab;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(padding_medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: padding_small, bottom: padding_medium),
              child: Text(
                'Editor',
                style:
                    TextStyle(fontWeight: FontWeight.w500, fontSize: font_h4),
              ),
            ),
            hMargin(),
            _headerTabsBuilder(selectedTab, titles, (x) {
              setState(() {
                selectedTab = x;
              });
            }),
            hMargin(),
            Container(
                child: IndexedStack(
              index: titles.indexOf(selectedTab),
              children: List.generate(
                  titles.length, (k) => _bodyTabsBuilder(titles[k])),
            )),
          ],
        ),
      ),
    );
  }
}
