//
//  PointCloud.swift
//  ObjectCapture
//
//  Created by koreadeep32 on 2023/06/09.
//

import SwiftUI
import RealityKit

struct PointCloud: View {
    var session: ObjectCaptureSession
    
    init(session: ObjectCaptureSession) {
        self.session = session
    }
    
    var body: some View {
        ObjectCapturePointCloudView(session: session)
    }
}
