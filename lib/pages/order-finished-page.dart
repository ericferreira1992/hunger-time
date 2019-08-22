import 'package:flutter/material.dart';

class OrderFinishedPage extends StatefulWidget {
  String orderId;

  OrderFinishedPage(this.orderId);

  @override
  _OrderFinishedPageState createState() => _OrderFinishedPageState();
}

class _OrderFinishedPageState extends State<OrderFinishedPage> with SingleTickerProviderStateMixin {

  String get orderId => widget.orderId;

  AnimationController _controller;
  @override
  void initState() {

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this
    )..forward();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pedido'),
        centerTitle: true
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: CurvedAnimation(parent: _controller, curve: Interval(0.0, 1.0)),
          child: Padding(
            padding: EdgeInsets.only(left: 25, right: 25, bottom: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    ..._getDoneContainer(),
                    ..._getTexts()
                  ],
                )
              ],
            )
          )
        )
      ),
    );
  }

  List<Widget> _getDoneContainer() {
    return [
      ScaleTransition(
        scale: CurvedAnimation(parent: _controller, curve: Interval(0.3, 0.75)),
        child: Container(
          margin: EdgeInsets.only(bottom: 10),
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
          child: FadeTransition(
            opacity: CurvedAnimation(parent: _controller, curve: Interval(0.7, 1.0)),
            child: Icon(
              Icons.done,
              size: 60,
              color: Colors.white,
            ),
          )
        ),
      ),
      Padding(
        padding: EdgeInsets.only(bottom: 15),
        child: Text(
          'Pedido feito!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30,
            height: .85,
            fontWeight: FontWeight.bold,
            color: Colors.green
          ),
        ),
      )
    ];
  }

  List<Widget> _getTexts() {
    return [
      RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(
            fontSize: 20,
            height: .9,
            color: Colors.black87,
            fontWeight: FontWeight.w300
          ),
          children: [
            TextSpan(text: 'O código do seu pedido é:'),
          ]
        ),
      ),
      SizedBox(height: 10),
      Card(
        child: InkWell(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              orderId,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.black87
              )
            ),
          ),
          onTap: () {
            
          },
        ),
      ),
      SizedBox(height: 20),
      Container(
        height: 60,
        child: OutlineButton(
          padding: EdgeInsets.symmetric(horizontal: 20),
          color: Colors.transparent,
          textColor: Theme.of(context).primaryColor,
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 1
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: Text(
            'Continuar comprando',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            )
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    ];
  }
}