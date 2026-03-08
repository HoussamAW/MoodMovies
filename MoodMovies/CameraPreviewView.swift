//
//  CameraPreviewView.swift
//  MoodMovies
//
//  Created by Houssam on 08/03/2026.
//

import SwiftUI

// This SwiftUI view lets us embed a UIKit view controller
struct CameraPreviewView: UIViewControllerRepresentable {
    
    // Creates the UIKit view controller that displays the camera
    func makeUIViewController(context: Context) -> CameraViewController {
        CameraViewController()
    }
    
    // Updates the view controller if SwiftUI data changes
    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {
        // Nothing here for the moment
    }
}
