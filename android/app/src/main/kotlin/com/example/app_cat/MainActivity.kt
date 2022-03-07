package com.example.app_cat

import android.graphics.BitmapFactory
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.tensorflow.lite.support.image.TensorImage
import org.tensorflow.lite.task.vision.detector.ObjectDetector


class MainActivity: FlutterActivity() {
    private val channel = "teste"
    private val list: MutableList<Float> = ArrayList()

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel).setMethodCallHandler {
            call, result ->

            if(call.method == "get"){
                runObjectDetection(call.arguments as String)
                result.success(list)
            }
        }
    }

    private fun runObjectDetection(path: String){
        list.clear()
        val bitmap = BitmapFactory.decodeFile(path)
        val image = TensorImage.fromBitmap(bitmap)

        val options = ObjectDetector.ObjectDetectorOptions.builder()
            .setMaxResults(5)
            .setScoreThreshold(0.3f)
            .build()
        val detector = ObjectDetector.createFromFileAndOptions(
            this,
            "gatinho_net.tflite",
            options
        )

        val detections = detector.detect(image)

        println(detections)

        for(d in detections){
            list.add(image.height.toFloat())
            list.add(d.boundingBox.left / image.width)
            list.add(d.boundingBox.top / image.height)
            list.add(d.boundingBox.right / image.width)
            list.add(d.boundingBox.bottom / image.height)
        }
    }
}
