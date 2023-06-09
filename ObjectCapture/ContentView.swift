//
//  ContentView.swift
//  ObjectCapture
//
//  Created by koreadeep32 on 2023/06/09.
//

import SwiftUI
import RealityKit

struct ContentView: View {
    @StateObject var session = ObjectCaptureSession()
    var body: some View {
        ZStack {
            ObjectCaptureView(session: session)
            if case .initializing = session.state {
                Button {
                    try? FileManager.default.removeItem(at: FileManager.default.temporaryDirectory)
                    session.start(imagesDirectory: FileManager.default.temporaryDirectory)
                    print("\(FileManager.default.temporaryDirectory)")
                } label: {
                    Text("Prepare")
                }
            } else if case .ready = session.state {
                Button {
                    session.startDetecting()
                } label: {
                    Text("Continue")
                }
            } else if case .detecting = session.state {
                Button {
                    session.startCapturing()
                } label: {
                    Text("Start Capture")
                }
            } else if case .capturing = session.state {
                VStack {
                    Spacer()
                    Text("\(session.numberOfShotsTaken) shots taken")
                    Button {
                        session.finish()
                    } label: {
                        Text("Finish Capture")
                    }
                }
            } else if case .finishing = session.state {
                HStack {
                    Button {
                        session.beginNewScanPass()
                    } label: {
                        Text("Don't Flip?")
                    }
                    Button {
                        session.beginNewScanPassAfterFlip()
                    } label: {
                        Text("Flip?")
                    }
                }
            } else if case .completed = session.state {
                Button {
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
                        print("Failed Recon")
                    }
                } label: {
                    Text("Reconstruct")
                }
            }
            
        }
    }
}

#Preview {
    ContentView()
}
