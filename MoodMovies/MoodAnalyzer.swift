//
//  MoodAnalyzer.swift
//  MoodMovies
//
//  Created by Houssam Dine Abdoul Wahab on 27/03/2026.
//

import Vision
import CoreML

enum Mood: String {
    case happy
    case sad
    case angry
    case disgust
    case fear
    case surprise
    case unknown
}

final class MoodAnalyzer {
    // call Vision
    private let request: VNCoreMLRequest
    
    // load and configure the Core ML model
    init() {
        do {
            let config = MLModelConfiguration()
            let model = try MoodClassifier(configuration: config).model
            let visionModel = try VNCoreMLModel(for: model)

            let request = VNCoreMLRequest(model: visionModel)
            request.imageCropAndScaleOption = .centerCrop
            self.request = request
        } catch {
            fatalError("Error loading model : \(error)")
        }
    }
    
    // analyze images from the camera and return mood predicted
    func analyze(pixelBuffer: CVPixelBuffer) throws -> (mood: Mood, confidence: Float)? {
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        try handler.perform([request])

        guard let results = request.results as? [VNClassificationObservation],
              let first = results.first else {
            return nil
        }

        let mood = mapLabelToMood(first.identifier)
        return (mood, first.confidence)
    }
    
    // convert model label to mood label
    private func mapLabelToMood(_ label: String) -> Mood {
        switch label.lowercased() {
        case "happy":
            return .happy
        case "sad":
            return .sad
        default:
            return .unknown
        }
    }
    
}
