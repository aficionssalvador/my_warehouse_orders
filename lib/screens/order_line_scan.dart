import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '/providers/general.dart';

Future<String> showScannerModal(BuildContext context) async {
  final result = await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ScannerScreen(),
        ),
      );
    },
  );
  return result ?? '';
}


class ScannerScreen extends StatefulWidget {
  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen>
    with SingleTickerProviderStateMixin {
  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;
  QRViewController? _qrViewController;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String _barcode = '';
  String _barcodeText = '';
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    codiBarresSeleccionat = "";
    setState(() {
      modoScanner;
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
  //  _qrViewController?.dispose();
    _animationController?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _cameraController =
        CameraController(
            firstCamera, ResolutionPreset.medium, enableAudio: false);
    _initializeControllerFuture = _cameraController!.initialize();
    setState(() {});
  }
  Future<void> _scanBarcode() async {
    try {
      final result = await BarcodeScanner.scan();
      String barcodeText = await codiBarresLLegit(AccioBarresSeleccionat.intentLectura, result.rawContent);
      if (barcodeText.isEmpty) {
        barcodeText = result.rawContent;
      }
      setState(() {
        _barcode = result.rawContent;
        _barcodeText = barcodeText;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _onQRViewCreated(QRViewController controller) async {
    _qrViewController = controller;
    _qrViewController!.scannedDataStream.listen((scanData) async {
      String barcodeText = await codiBarresLLegit(AccioBarresSeleccionat.intentLectura, scanData.code!);
      if (barcodeText.isEmpty) {
        barcodeText = scanData.code!;
      }
      setState(() {
        _barcode = scanData.code!;
        _barcodeText = barcodeText;
      });
    });
  }

/*  Future<void> _scanBarcode() async {
    try {
      final result = await BarcodeScanner.scan();
      setState(() {
        _barcode = result.rawContent;
        _barcodeText = await codiBarresLLegit(AccioBarresSeleccionat.intentLectura, result.rawContent);
        if (_barcodeText.isEmpty) { _barcodeText = _barcode;}
        });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _onQRViewCreated(QRViewController controller) async {

    _qrViewController = controller;
    _qrViewController!.scannedDataStream.listen((scanData) {
      setState(() async {
        _barcode = scanData.code!;
        _barcodeText = await codiBarresLLegit(AccioBarresSeleccionat.intentLectura, scanData.code!);
        if (_barcodeText.isEmpty) { _barcodeText = _barcode;}
      });
    });
  }
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scanner (${getNombreModoScaner()})'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Stack(
              children: [
                (modoScanner == 0) ? _buildCameraPreview() : _buildQRView(),
              ],
            ),
          ),
          SizedBox(height: 16),
          Text(
            '$_barcodeText',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _scanBarcode,
                child: Text('         Scan Barcode         '),
              ),
            ],
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              String xx = await codiBarresLLegit(AccioBarresSeleccionat.llegitCodi, _barcode);
              Navigator.pop(context, _barcode);
            },
            child: Text('         Aceptar         '),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AspectRatio(
            aspectRatio: 0.9,
            child: CameraPreview(_cameraController!),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildQRView() {
    return AspectRatio(
      aspectRatio: 0.9,
      child: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: 300,
        ),
        overlayMargin: EdgeInsets.only(bottom: 120),
        onPermissionSet: (ctrl, p) => _animationController?.forward(),
      ),
    );
  }

  void setNodoScaner()
  {
    int i =modoScanner;
    i++; if (i>1) i = 0;
    modoScanner = i;
    setState(() {
      modoScanner;
    });
  }

  String getNombreModoScaner()
  {
    return (modoScanner==0)?'Foto':'Auto';
  }

}