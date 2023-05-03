//
//  TextRecognizer.swift
//  VisionKit-Example
//
//  Created by Cédric Bahirwe on 03/05/2023.
//

import Foundation
import Vision
import VisionKit

final class TextRecognizer {
    private let cameraScan: VNDocumentCameraScan
    private let queue = DispatchQueue(label: "com.auca.textrecognizer.scan",
                                      qos: .default,
                                      attributes: [],
                                      autoreleaseFrequency: .workItem)

    init(cameraScan: VNDocumentCameraScan) {
        self.cameraScan = cameraScan
    }


    // A function to recognize text from images and return an array of recognized text per page.
    func recognizeText(withCompletionHandler completionHandler: @escaping ([String]) -> Void) {
        // Execute the text recognition task asynchronously on a private DispatchQueue.
        queue.async {
            // Extract the CGImages of all pages of the VNDocumentCameraScan object.
            let images = (0..<self.cameraScan.pageCount).compactMap({
                self.cameraScan.imageOfPage(at: $0).cgImage
            })
            
            // Create an array of tuples containing the CGImages and the VNRecognizeTextRequests for each page.
            let imagesAndRequests = images.map({ (image: $0, request: VNRecognizeTextRequest()) })
            
            // Process each page of the document.
            let textPerPage = imagesAndRequests.map { image, request -> String in
                // Create a VNImageRequestHandler for the current page image.
                let handler = VNImageRequestHandler(cgImage: image, options: [:])
                do {
                    // Perform the text recognition request for the page.
                    try handler.perform([request])
                    // Extract the recognized text from the request results.
                    guard let observations = request.results else { return "" }
                    return observations.compactMap({ $0.topCandidates(1).first?.string }).joined(separator: "\n")
                }
                catch {
                    // Print the error message if text recognition fails for the current page.
                    print(error)
                    return ""
                }
            }
            DispatchQueue.main.async {
                completionHandler(textPerPage)
            }
        }
    }
}
