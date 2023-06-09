import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '/providers/general.dart';


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
      setState(() {
        _barcode = codiBarresLLegit(AccioBarresSeleccionat.intentLectura, result.rawContent);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void _onQRViewCreated(QRViewController controller) {

    _qrViewController = controller;
    _qrViewController!.scannedDataStream.listen((scanData) {
      setState(() {
        _barcode = codiBarresLLegit(AccioBarresSeleccionat.intentLectura, scanData.code!);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scanner (${getNombreModoScaner()})'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                (modoScanner == 0) ? _buildCameraPreview() : _buildQRView(),
              ],
            ),
          ),
          SizedBox(height: 16),
          Text(
            '$_barcode',
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
            onPressed: () {
              codiBarresLLegit(AccioBarresSeleccionat.llegitCodi, _barcode);
              Navigator.pop(context);
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
          return CameraPreview(_cameraController!);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildQRView() {
    return QRView(
      key
          : qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.red,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: 300,
      ),
      overlayMargin: EdgeInsets.only(bottom: 120),
      // animationDuration: const Duration(milliseconds: 300),
      onPermissionSet: (ctrl, p) => _animationController?.forward(),
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