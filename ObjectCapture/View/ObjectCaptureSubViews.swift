//
//  ObjectCaptureInitializeView.swift
//  ObjectCapture
//
//  Created by koreadeep32 on 2023/06/16.
//

import SwiftUI
import RealityKit

extension ObjectCapture {
    // MARK: Session State Initialization
    var sessionStateInitView: some View {
        /// Initialize temporary directory for saving captured images
        Button("Prepare") {
            viewModel.setup()
            session.start(imagesDirectory: viewModel.captureDir!)
        }
    }
    
    // MARK: Session State Ready
    var sessionStateReadyView: some View {
        /// ARWorldTrackingConfiguration is called here
        Button("Continue") { let _ = session.startDetecting() }
    }
    
    // MARK: Session State Detecting
    var sessionStateDetectingView: some View {
        /// View allows modifying bounding box
        Button("Start Capture") { session.startCapturing() }
    }
    
    // MARK: Session State Capturing
    var sessionStateCapturingView: some View {
        /// Finish up capture or start new one
        VStack {
            Spacer()
            Text("\(session.numberOfShotsTaken) shots taken")
            if session.userCompletedScanPass {
                HStack {
                    Button("Finish Captures") {
                        session.finish()
                    }
                    Button("New Captures") {
                        isAlertPresented = true
                    }
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .alert(isPresented: $isAlertPresented) {
            Alert(title: Text("Finished Flip"),
                  primaryButton: .default(Text("No Flip"), action: {
                session.beginNewScanPass()
            }), secondaryButton: .default(Text("Flip"), action: {
                session.pause()
                session.beginNewScanPassAfterFlip()
            }))
        }
    }
    
    
    
    // MARK: Session State Completed
    var sessionStateCompletedView: some View {
        /// Run PhotogrammetrySession for Reconstruction
        ReconstructionProgressView(viewModel: viewModel, session: session)
            .task {
                do {
                    var configuration = PhotogrammetrySession.Configuration()
                    let session = try PhotogrammetrySession(
                        input: viewModel.captureDir!)
                    
                    try session.process(requests: [
                        .modelFile(url: viewModel.captureDir!.appendingPathComponent("model.usdz"))
                    ])
                    for try await output in session.outputs {
                        switch output {
                        case .processingComplete:
                            viewModel.handleProcessingComplete()
                        case .inputComplete:
                            print("Input Complete!")
                        case .requestError(let request, let error):
                            print("Request Error: \(request) : \(error)")
                        case .requestComplete(let request, let result):
                            print("Request Complete: \(request) : \(result)")
                        case .requestProgress(_, fractionComplete: let fractionComplete):
                            viewModel.handleRequestProgress(fractionComplete)
                        case .processingCancelled:
                            print("Processing Cancelled!")
                        case .invalidSample(id: let id, reason: let reason):
                            print("Invalid Sample \(id) : \(reason)")
                        case .skippedSample(id: let id):
                            print("Skipped Sample: \(id)")
                        case .automaticDownsampling:
                            print("AutomaticDownsampling")
                        case .requestProgressInfo(let request, let progressInfo):
                            print("Request ProgressInfo: \(request) : \(progressInfo)")
                        @unknown default:
                            print("Unknown Error")
                        }
                    }
                } catch {
                    print("\(error)")
                }
            }
    }
    
    // MARK: Session State Failed
    var sessionStateFailedView: some View {
        Text("Scanning Failed")
    }
}
