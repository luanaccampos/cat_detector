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

  List<Widget> drawBoxes(Size size) {
    List<Widget> l = [];
    if (r.isEmpty) return l;

    l.add(Container(child: img));

    int i = 0;

    while (i < r.length) {
      double factorX = size.width;
      double factorY = r[i] / r[i] * size.width;
      double x = r[i + 1],
          y = r[i + 2],
          w = r[i + 3] - r[i + 1],
          h = r[i + 4] - r[i + 2];

      l.add(Positioned(
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
      ));

      i += 5;
    }

    return l;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text('Gatinho_net'),
        centerTitle: true,
      ),
      body: Stack(
        children: drawBoxes(MediaQuery.of(context).size),
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
