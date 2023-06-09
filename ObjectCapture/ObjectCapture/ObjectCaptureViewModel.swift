//
//  ObjectCaptureViewModel.swift
//  ObjectCapture
//
//  Created by koreadeep32 on 2023/06/09.
//

import Foundation
import RealityKit
import SwiftUI



extension ObjectCapture {
    final class ViewModel: ObservableObject {
        static var directory: URL? {
            try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask,
                                         appropriateFor: nil, create: false).appendingPathComponent("Images/")
        }
        
        func run() {
            do {
                let url = URL(filePath: FileManager.default.currentDirectoryPath)
                let session = try PhotogrammetrySession(input: FileManager.default.temporaryDirectory)
                let waiter = Task {
                    do {
                        for try await output in session.outputs {
                            switch output {
                            case .processingComplete:
                                print("Processing Complete!")
                            case .requestError(let request, let error):
                                print("Request \(String(describing: request)) had an error \(String(describing: error))")
                            case .requestComplete(let request, let result):
                                print("Request Complete!")
                            case .requestProgress(let request, let fractionComplete):
                                print("Request \(String(describing: request)) progress \(String(describing: fractionComplete))!")
                            case .inputComplete:
                                print("Data input complete!")
                            case .invalidSample(let id, let reason):
                                print("Invalid sample \(String(describing: id)) due to \(String(describing: reason))!")
                            case .skippedSample(let id):
                                print("Skipped Sample \(String(describing: id))")
                            case .automaticDownsampling:
                                print("Automatic downsampling applied!")
                            case .processingCancelled:
                                print("Processing was cancelled.")
                            case .requestProgressInfo(_, _):
                                print("Progress INFO")
                            @unknown default:
                                print("Ouput: unhandled message: \(output.localizedDescription)")
                            }
                        }
                    } catch {
                        print("Output: ERROR \(String(describing: error))")
                    }
                }
                
                withExtendedLifetime((session, waiter)) {
                    do {
                        try session.process(requests: [
                            .modelFile(url: url, detail: .reduced, geometry: nil)
                        ])
                        
                        RunLoop.main.run()
                    } catch {
                        print("Failed!")
                    }
                }
            } catch {
                print("Failed Reconstruction!")
            }
        }
    }
}
