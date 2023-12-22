import UIKit
import AVFoundation
import Vision

class BarcodeScannerViewController: UIViewController {
    
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer!
    var code = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the camera input and start the capture session
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            return
        }
        
        // Set up the capture output and its metadata object types
        let metadataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417, .qr, .dataMatrix]
        } else {
            return
        }
        
        // Set up the preview layer for displaying the camera output
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        // Start the capture session
        captureSession.startRunning()
    }
    
    private func setupRectangle() {
        let barcodeRectView = BarcodeScannerRectView()
        barcodeRectView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(barcodeRectView)
        barcodeRectView.pinCenterX(to: view.centerXAnchor)
        barcodeRectView.pinCenterY(to: view.centerYAnchor)
        barcodeRectView.pinWidth(to: view, 0.8)
        barcodeRectView.pinHeight(to: view, 0.6)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Stop the capture session when the view disappears
        captureSession.stopRunning()
    }
}

extension BarcodeScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Get the first detected barcode and display its string value
        guard let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject else { return }
        guard let stringValue = metadataObject.stringValue else { return }
        
        code = stringValue
        
        let scannedProductVC = ScannedProductPageViewController()
        
        ParsingHelper.checkBarcode(code) { productViewModel in
            DispatchQueue.main.async {
                scannedProductVC.configure(with: productViewModel)
                let navController = UINavigationController(rootViewController: scannedProductVC)
                self.present(navController, animated: true)
            }
        }
        
        // Stop the capture session to prevent further processing
        captureSession.stopRunning()
    }
}
