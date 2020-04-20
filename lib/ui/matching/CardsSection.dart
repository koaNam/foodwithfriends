import 'dart:core';

import 'package:flutter/material.dart';
import 'SuggestionCard.dart';
import 'dart:math';

Alignment cardAlign;
Size cardSize;

class CardsSection extends StatefulWidget {
  final int loadThreshold;
  final Function onLoadData;
  final Function itemBuilder;

  CardsSection(
      {BuildContext context,
      this.loadThreshold,
      this.onLoadData,
      this.itemBuilder}) {
    cardAlign = new Alignment(0.0, 0.0);
    cardSize = new Size(MediaQuery.of(context).size.width * 0.9,
        MediaQuery.of(context).size.height);
  }

  @override
  _CardsSectionState createState() => new _CardsSectionState();
}

class _CardsSectionState extends State<CardsSection>
    with SingleTickerProviderStateMixin {
  int cardsCounter = 0;

  List<SuggestionCard> cards = new List();
  AnimationController _controller;

  final Alignment defaultFrontCardAlign = new Alignment(0.0, 0.0);
  Alignment frontCardAlign;
  double frontCardRot = 0.0;

  @override
  void initState() {
    super.initState();
    for (Object o in widget.onLoadData(null)) {
      cards.add(widget.itemBuilder(o, () {
        frontCardAlign = frontCardAlign.add(Alignment(40.0, 0.0));
        this.animateCards();
      }, () {
        frontCardAlign = frontCardAlign.add(Alignment(-40.0, 0.0));
        this.animateCards();
      }));
    }

    frontCardAlign = cardAlign;

    // Init the animation controller
    _controller = new AnimationController(
        duration: new Duration(milliseconds: 700), vsync: this);
    _controller.addListener(() => setState(() {}));
    _controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        changeCardsOrder();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> cardList=new List();

    if(this.cards.length >= 2){
      cardList.add(backCard());
    }
    if(this.cards.length >= 1){
      cardList.add(frontCard());
    }

    cardList.add(_controller.status != AnimationStatus.forward
        ? new SizedBox.expand(
        child: new GestureDetector(
          // While dragging the first card
          onPanUpdate: (DragUpdateDetails details) {
            // Add what the user swiped in the last frame to the alignment of the card
            setState(() {
              // 20 is the "speed" at which moves the card
              frontCardAlign = new Alignment(
                  frontCardAlign.x +
                      20 *
                          details.delta.dx /
                          MediaQuery.of(context).size.width,
                  frontCardAlign.y +
                      40 *
                          details.delta.dy /
                          MediaQuery.of(context).size.height);

              frontCardRot =
                  frontCardAlign.x; // * rotation speed;
            });
          },
          // When releasing the first card
          onPanEnd: (_) {
            // If the front card was swiped far enough to count as swiped
            if (frontCardAlign.x > 3.0) {
              animateCards();
              this.cards.first.onSwipeRight();
            } else if (frontCardAlign.x < -3.0) {
              animateCards();
              this.cards.first.onSwipeLeft();
            } else {
              // Return to the initial rotation and alignment
              setState(() {
                frontCardAlign = defaultFrontCardAlign;
                frontCardRot = 0.0;
              });
            }
          },
        ))
        : new Container(),);

    return new Expanded(
        child: Container(
            color: Colors.white,
            child: new Stack(
              children: cardList
            )
        )
    );
  }

  Widget backCard() {
    return new Align(
      alignment: cardAlign,
      child: new SizedBox.fromSize(
          size: cardSize, child: this.cards[1] as StatelessWidget),
    );
  }

  Widget frontCard() {
    return new Align(
        alignment: _controller.status == AnimationStatus.forward
            ? CardsAnimation.frontCardDisappearAlignmentAnim(
                    _controller, frontCardAlign)
                .value
            : frontCardAlign,
        child: new Transform.rotate(
          angle: (pi / 180.0) * frontCardRot,
          child: new SizedBox.fromSize(
              size: cardSize, child: this.cards[0] as StatelessWidget),
        ));
  }

  void changeCardsOrder() {
    setState(() {
      cards.removeAt(0);

      if (cards.length < widget.loadThreshold) {
        for (Object o in widget.onLoadData(cards.last)) {
          SuggestionCard card = widget.itemBuilder(o, () {
            frontCardAlign = frontCardAlign.add(Alignment(40.0, 0.0));
            this.animateCards();
          }, () {
            frontCardAlign = frontCardAlign.add(Alignment(-40.0, 0.0));
            this.animateCards();
          });
          cards.add(card);
        }
      }

      frontCardAlign = defaultFrontCardAlign;
      frontCardRot = 0.0;
    });
  }

  void animateCards() {
    _controller.stop();
    _controller.value = 0.0;
    _controller.forward();
  }
}

class CardsAnimation {
  static Animation<Alignment> frontCardDisappearAlignmentAnim(
      AnimationController parent, Alignment beginAlign) {
    return new AlignmentTween(
            begin: beginAlign,
            end: new Alignment(
                beginAlign.x > 0 ? beginAlign.x + 30.0 : beginAlign.x - 30.0,
                0.0) // Has swiped to the left or right?
            )
        .animate(new CurvedAnimation(
            parent: parent,
            curve: new Interval(0.0, 0.5, curve: Curves.easeIn)));
  }
}
