//
//  ObjectCaptureViewModel.swift
//  ObjectCapture
//
//  Created by koreadeep32 on 2023/06/09.
//

import RealityKit
import SwiftUI

import os

private let logger = Logger.init(subsystem: "ObjectCaptureApp", category: "ViewModel")

extension ObjectCapture {
    final class ViewModel: ObservableObject {
        @Published var captureFolderState: CaptureFolderState?
        @Published var isProcessingComplete: Bool = false
        @Published var requestProcessPercentage: Double = 0.0
        var captureDir: URL? {
            captureFolderState?.captureDir
        }
        
        func setup() {
            do { captureFolderState = try ViewModel.createNewCaptureFolder() }
            catch { logger.error("Setup Error: \(error.localizedDescription)") }
        }
        
        private static func createNewCaptureFolder() throws -> CaptureFolderState {
            guard let newCaptureDir = CaptureFolderState.createCaptureDirectory() else {
                throw SetupError.failed(msg: "Unable to create capture directory!")
            }
            return CaptureFolderState(url: newCaptureDir)
        }
        
        private enum SetupError: Error {
            case failed(msg: String)
        }
        
        func handleProcessingComplete() {
            withAnimation(.easeIn) {
                isProcessingComplete = true
            }
        }
        
        func handleRequestProgress(_ fractionComplete: Double) {
            requestProcessPercentage = fractionComplete
        }
    }
}
