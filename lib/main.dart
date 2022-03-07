import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const platform = MethodChannel('teste');
  File? file;
  //OpenPainter painter = OpenPainter();
  Image? img;
  List r = [];

  Future click() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    Stopwatch sw = Stopwatch()..start();
    r = await platform.invokeMethod('get', image?.path);
    log("${sw.elapsedMilliseconds} ms ${r.toString()}");
    sw.stop();

    if (image != null) {
      img = Image.file(File(image.path));
      //painter.set(r);
      setState(() {});
    }
  }

  Widget drawBoxes(Size size) {
    if (r.isEmpty) return Container();

    double factorX = size.width;
    double factorY = r[0] / r[0] * size.width;
    double x = r[1], y = r[2], w = r[3] - r[1], h = r[4] - r[2];

    return Positioned(
      left: x * factorX,
      top: y * factorY,
      width: w * factorX,
      height: h * factorY,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
          color: Colors.yellowAccent,
          width: 3,
        )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text('Gatinho_net'),
      ),
      body: Stack(
        children: [
          Container(
            child: img,
          ),
          drawBoxes(MediaQuery.of(context).size),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: click,
        child: IconButton(
          onPressed: click,
          icon: const Icon(Icons.camera_alt_outlined),
        ),
      ),
    );
  }
}

/*class OpenPainter extends CustomPainter {
  List p = [];
  late Image image;

  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = Colors.yellowAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    log("${size.width} ${size.height}");

    if (p.isNotEmpty) {
      log("${size.width} ${size.height}");
      canvas.drawRect(
          Offset(p[0] * size.width, p[1] * size.height) &
              Size((p[2] - p[0]) * size.width, (p[3] - p[1]) * size.height),
          paint1);
      canvas.drawImage(image, Offset.zero, paint1);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  void set(List P) {
    p = P;
  }
}*/
