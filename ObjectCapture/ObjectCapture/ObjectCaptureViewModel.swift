//
//  ObjectCaptureViewModel.swift
//  ObjectCapture
//
//  Created by koreadeep32 on 2023/06/09.
//

import Foundation
import RealityKit
import SwiftUI



extension ObjectCaptureView {
    final class ViewModel: ObservableObject {
        static var directory: URL? {
            try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask,
                                         appropriateFor: nil, create: false).appendingPathComponent("Images/")
        }
    }
}
