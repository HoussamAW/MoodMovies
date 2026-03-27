//
//  CameraViewController.swift
//  MoodMovies
//
//  Created by Houssam on 08/03/2026.
//

import SwiftUI
import AVFoundation
import Vision

// This UIKit controller manages the camera -> it opens the camera, shows the preview, captures frames, and asks Vision to detect faces in each frame
final class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    // Starts the camera session system
    let session = AVCaptureSession()
    
    // Execute the model
    private let analyzer = MoodAnalyzer()
    
    // Background queue used to process camera frames so the UI stays responsive
    private let videoQueue = DispatchQueue(label: "camera.video.queue")
    
   
    
    // Prepares the camera when the screen is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCamera()
    }
    
    private func configureCamera() {
        // 1. Choose which camera to use (front, back, etc.)
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera,for: .video,position: .front) else {
            return
        }
        // 2. Create the input. Without it, the session receives no image
        do {
            let input = try AVCaptureDeviceInput(device: camera)
            // 3. Add it to the session so the app knows which camera to use
            if session.canAddInput(input) {
                session.addInput(input)
            }
            // Safety check in case creating the input fails.
        } catch {
            print("Error input camera:",error)
        }
        
        // 4. Create the preview layer to display the camera image on screen
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.bounds
        view.layer.addSublayer(previewLayer)
        
        // 5. Add the video output
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: videoQueue)
        
        if session.canAddOutput(output) {
            session.addOutput(output)
        }
        
        // 6. Start the session
        session.startRunning()
        
        
        
        
    }
    
    // This method is called automatically very often,
    // every time a new video frame is available
    // This is where we grab the camera image and send it to Vision
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        
        // Captures each frame from the camera
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        // analyze each frame and return the mood
        do {
            if let result = try analyzer.analyze(pixelBuffer: pixelBuffer) {
                print("Mood: \(result.mood.rawValue)")
                print("Confidence: \(result.confidence)")
            } else {
                print("No mood detected")
            }
        } catch {
            print("Mood analysis error: \(error)")
        }
    }
    
}
