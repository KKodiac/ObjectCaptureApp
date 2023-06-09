//
//  ObjectCaptureView.swift
//  ObjectCapture
//
//  Created by koreadeep32 on 2023/06/09.
//

import SwiftUI
import RealityKit

struct ObjectCapture: View {
    @StateObject var session = ObjectCaptureSession()
    @StateObject var viewModel = ViewModel()
    @State var isAlertPresented: Bool = false
    
    var body: some View {
        ZStack {
            ObjectCaptureView(session: session)
            if case .initializing = session.state {
                // MARK: Initialize temporary directory for saving captured images
                Button("Prepare") {
                    try? FileManager.default.removeItem(at: FileManager.default.temporaryDirectory)
                    session.start(imagesDirectory: FileManager.default.temporaryDirectory)
                }
            } else if case .ready = session.state {
                // MARK: ARWorldTrackingConfiguration is called here
                Button("Continue") { let _ = session.startDetecting() }
            } else if case .detecting = session.state {
                // MARK: View allows modifying bounding box
                Button("Start Capture") { session.startCapturing() }
            } else if case .capturing = session.state {
                // MARK: Finish up capture or start new one
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
            } else if case .completed = session.state {
                // MARK: Run PhotogrammetrySession for Reconstruction
                Button("Reconstruct") { viewModel.run() }
            } else if case .failed(let error) = session.state {
                Text("Scanning Failed \(error.localizedDescription)")
            }
        }
        .alert(isPresented: $isAlertPresented) {
            Alert(title: Text("Finished Flip"),
                  primaryButton: .default(Text("No Flip"), action: {
                session.beginNewScanPass()
            }), secondaryButton: .default(Text("Flip"), action: {
                session.beginNewScanPassAfterFlip()
            }))
        }
    }
}
