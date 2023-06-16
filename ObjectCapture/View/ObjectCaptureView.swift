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
    @State var isReconstructionViewPresented: Bool = false
    
    var body: some View {
        ZStack {
            ObjectCaptureView(session: session)
            if case .initializing = session.state {
                sessionStateInitView
            } else if case .ready = session.state {
                sessionStateReadyView
            } else if case .detecting = session.state {
                sessionStateDetectingView
            } else if case .capturing = session.state {
                sessionStateCapturingView
            } else if case .completed = session.state {
                sessionStateCompletedView
            } else if case .failed( _) = session.state {
                sessionStateFailedView
            }
        }
    }
}
