// SPDX-License-Identifier: AGPL-3.0-or-later
// Copyright © 2026 Jia Liu

import ARKit

enum TrackingQuality: Equatable {
    case normal
    case limited(reason: ARCamera.TrackingState.Reason)
    case notAvailable
}

extension TrackingQuality {
    var message: String? {
        switch self {
        case .normal:
            return nil
        case .limited(let reason):
            switch reason {
            case .excessiveMotion:
                return "Moving too fast. Tracking quality reduced."
            case .insufficientFeatures:
                return "Low visual features. Tracking quality reduced."
            case .relocalizing:
                return "Recovering tracking. Please wait."
            case .initializing:
                return "Initializing tracking. Please wait."
            @unknown default:
                return "Tracking quality reduced."
            }
        case .notAvailable:
            return "Tracking lost. Please restart session."
        }
    }

    var shouldPause: Bool {
        if case .notAvailable = self { return true }
        return false
    }
}

final class TrackingQualityMonitor {

    var onQualityChange: ((TrackingQuality) -> Void)?
    var currentQuality: TrackingQuality { previousQuality }

    private var previousQuality: TrackingQuality = .normal

    func evaluate(trackingState: ARCamera.TrackingState) -> TrackingQuality {
        let quality: TrackingQuality

        switch trackingState {
        case .normal:
            quality = .normal
        case .limited(let reason):
            quality = .limited(reason: reason)
        case .notAvailable:
            quality = .notAvailable
        @unknown default:
            quality = .limited(reason: .initializing)
        }

        if quality != previousQuality {
            onQualityChange?(quality)
            previousQuality = quality
        }

        return quality
    }

    func reset() {
        previousQuality = .normal
    }
}