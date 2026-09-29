// SPDX-License-Identifier: AGPL-3.0-or-later
// Copyright © 2026 Jia Liu

import UIKit
import ARKit

class ARSessionViewController: UIViewController {

    private let arView = ARSCNView()
    private let configuration = ARWorldTrackingConfiguration()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupARView()
        setupConfiguration()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        arView.session.run(configuration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        arView.session.pause()
    }

    private func setupARView() {
        arView.frame = view.bounds
        arView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(arView)
        arView.session.delegate = self
    }

    private func setupConfiguration() {
        configuration.worldAlignment = .gravity
    }
}

extension ARSessionViewController: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        let cameraPosition = frame.camera.transform.columns.3
        let x = cameraPosition.x
        let y = cameraPosition.y
        let z = cameraPosition.z
        print("Camera position: x=\(String(format: "%.3f", x)), y=\(String(format: "%.3f", y)), z=\(String(format: "%.3f", z))")
    }
}