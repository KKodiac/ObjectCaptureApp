//
//  Extensions.swift
//  ObjectCapture
//
//  Created by koreadeep32 on 2023/06/19.
//

import RealityKit
import SwiftUI

extension ObjectCaptureSession.Feedback {
    var stringDescription: String.LocalizationValue {
        switch self {
        case .environmentLowLight:
            return "Environment Low Light"
        case .environmentTooDark:
            return "Environment Too Dark"
        case .movingTooFast:
            return "Moving Too Fast"
        case .objectNotFlippable:
            return "Object Not Flippable"
        case .objectTooClose:
            return "Object Too Close"
        case .objectTooFar:
            return "Object Too Far"
        case .outOfFieldOfView:
            return "Object is Out of View"
        case .overCapturing:
            return "Overcapturing"
        @unknown default:
            return "Uncomprehensable Feedback"
        }
    }
    
    var id: Int8 {
        switch self {
        case .environmentLowLight:
            return 0
        case .environmentTooDark:
            return 1
        case .movingTooFast:
            return 2
        case .objectNotFlippable:
            return 3
        case .objectTooClose:
            return 4
        case .objectTooFar:
            return 5
        case .outOfFieldOfView:
            return 6
        case .overCapturing:
            return 7
        @unknown default:
            return -1
        }
    }
}

extension PhotogrammetrySession.Output.ProcessingStage {
    var stringDescription: String.LocalizationValue {
        switch self {
        case .imageAlignment:
            return "Aligning Image..."
        case .meshGeneration:
            return "Generating Mesh..."
        case .optimization:
            return "Optimizing..."
        case .pointCloudGeneration:
            return "Generating Point Cloud..."
        case .preProcessing:
            return "Pre-Processing..."
        case .textureMapping:
            return "Mapping Texture..."
        @unknown default:
            return "Uncomprehensable Processing Stage"
        }
    }
}

