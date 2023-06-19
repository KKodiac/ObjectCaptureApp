//
//  ReconstructionProgressView.swift
//  ObjectCapture
//
//  Created by koreadeep32 on 2023/06/16.
//

import SwiftUI
import RealityKit

struct ReconstructionProgressView: View {
    @ObservedObject var viewModel: ObjectCapture.ViewModel
    @ObservedObject var session: ObjectCaptureSession
    @State var isPresentingProcessedAsset: Bool = false
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack {
                ObjectCapturePointCloudView(session: session)
                if viewModel.isProcessingComplete {
                    Button {
                        isPresentingProcessedAsset = true
                    } label: {
                        VStack {
                            Text("Model Processing is Complete!")
                            Text("Click Here to Check out the Asset.")
                        }
                    }
                    .buttonStyle(.borderedProminent)
                } else {
                    ProgressView(value: viewModel.requestProcessPercentage) {
                        Text("Processing... \(String(localized: viewModel.requestProcessingStage?.stringDescription ?? ""))")
                    }
                    .progressViewStyle(.circular)
                }
            }
        }
        .sheet(isPresented: $isPresentingProcessedAsset) {
            ARQuickLookView(name: "model", allowScaling: true, captureDir: viewModel.captureDir!)
        }
    }
}

