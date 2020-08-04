import 'package:flutter/cupertino.dart';
import 'package:porsche_app/app/presentation/components/a/a_divider.dart';
import 'package:porsche_app/app/presentation/theme/app_theme.dart';
import 'package:porsche_app/app/util/composite_disposable_mixin.dart';

class Images extends StatefulWidget {
  final List<String> images;

  const Images({Key key, @required this.images}) : super(key: key);

  @override
  _ImagesState createState() => _ImagesState();
}

class _ImagesState extends State<Images> with CompositeDisposableMixin {
  final PageController _pageController = PageController();
  int position = 0;

  @override
  void initState() {
    super.initState();
    _pageController
      ..addListener(() {
        setState(() {
          position = _pageController.page.round();
        });
      })
      ..disposeWith(this);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        PageView.builder(
          controller: _pageController,
          itemBuilder: (_, i) => Image.network(
            widget.images[i],
            fit: BoxFit.fitWidth,
          ),
          itemCount: widget.images.length,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.images.length,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: SizedBox(
                    width: 34.0,
                    child: ADivider(
                      color: position == index
                          ? Thm.of(context).primaryColor
                          : Thm.of(context).secondaryDarker50Color,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0)
          ],
        ),
      ],
    );
  }
}
