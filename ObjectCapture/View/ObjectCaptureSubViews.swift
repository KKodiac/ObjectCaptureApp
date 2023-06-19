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
        ZStack(alignment: .bottom) {
            Color.white.ignoresSafeArea()
            GroupBox {
                Text("Following materials should be avoided for scanning").font(.headline)
                Text("Reflective")
                Text("Transparent")
                Text("Too Thin")
                Button("Start") {
                    viewModel.setup()
                    session.start(imagesDirectory: viewModel.captureDir!)
                }
                .buttonStyle(.borderedProminent)
                .tint(.purple)
            }
        }
    }
    
    // MARK: Session State Ready
    var sessionStateReadyView: some View {
        /// ARWorldTrackingConfiguration is called here
        ZStack(alignment: .bottom) {
            Color.clear
            GroupBox {
                Text("Point the center circle to the object you'd like to capture").font(.headline)
                Button("Continue") { let _ = session.startDetecting() }
                    .buttonStyle(.borderedProminent)
                    .tint(.purple)
            }
        }
    }
    
    // MARK: Session State Detecting
    var sessionStateDetectingView: some View {
        /// View allows modifying bounding box
        ZStack(alignment: .top) {
            Color.clear.ignoresSafeArea()
            GroupBox {
                Text("You can now begin capture").font(.subheadline)
                Button("Start Capture") { session.startCapturing() }
                    .buttonStyle(.borderedProminent)
                    .tint(.purple)
            }
        }
    }
    
    // MARK: Session State Capturing
    var sessionStateCapturingView: some View {
        /// Finish up capture or start new one
        ZStack(alignment: .top) {
            Color.clear.ignoresSafeArea()
            GroupBox {
                Text("\(session.numberOfShotsTaken) shots taken")
                ForEach(session.feedback.sorted{$0.id < $1.id}, id: \.self) { feedback in
                    Text("\(String(localized: feedback.stringDescription))")
                }.animation(.easeIn)
                if session.userCompletedScanPass {
                    HStack {
                        Button("Finish Captures") {
                            session.finish()
                        }
                        Button("New Captures") {
                            isAlertPresented = true
                            session.pause()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.purple)
                }
            }
        }
        .alert(isPresented: $isAlertPresented) {
            Alert(title: Text("Start a New Scan"),
                  primaryButton: .default(Text("No Flip"), action: {
                session.beginNewScanPass()
            }), secondaryButton: .default(Text("Flip"), action: {
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
                    let session = try PhotogrammetrySession(input: viewModel.captureDir!)
                    
                    try session.process(requests: [
                        .modelFile(url: viewModel.captureDir!.appendingPathComponent("model.usdz"), detail: .reduced)
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
                        case .requestProgressInfo( _, let progressInfo):
                            viewModel.handleRequestProgressInfo(progressInfo.processingStage)
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
