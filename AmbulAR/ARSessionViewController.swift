// SPDX-License-Identifier: AGPL-3.0-or-later
// Copyright © 2026 Jia Liu

import UIKit
import ARKit

class ARSessionViewController: UIViewController {

    private let arView = ARSCNView()
    private let configuration = ARWorldTrackingConfiguration()
    private let sessionController = SessionController()

    private let actionButton = UIButton(type: .system)
    private let finishButton = UIButton(type: .system)
    private let distanceLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupARView()
        setupConfiguration()
        setupUI()
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

    private func setupUI() {
        distanceLabel.font = .monospacedDigitSystemFont(ofSize: 36, weight: .medium)
        distanceLabel.textColor = .white
        distanceLabel.textAlignment = .center
        distanceLabel.text = "0.000 m"
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(distanceLabel)

        actionButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        actionButton.setTitle("Start", for: .normal)
        actionButton.backgroundColor = .systemBlue
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.layer.cornerRadius = 12
        actionButton.addTarget(self, action: #selector(handleAction), for: .touchUpInside)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(actionButton)

        finishButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        finishButton.setTitle("Finish", for: .normal)
        finishButton.backgroundColor = .systemRed
        finishButton.setTitleColor(.white, for: .normal)
        finishButton.layer.cornerRadius = 12
        finishButton.addTarget(self, action: #selector(handleFinish), for: .touchUpInside)
        finishButton.translatesAutoresizingMaskIntoConstraints = false
        finishButton.isHidden = true
        view.addSubview(finishButton)

        NSLayoutConstraint.activate([
            distanceLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            distanceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            actionButton.widthAnchor.constraint(equalToConstant: 120),
            actionButton.heightAnchor.constraint(equalToConstant: 50),

            finishButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            finishButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            finishButton.widthAnchor.constraint(equalToConstant: 100),
            finishButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func handleAction() {
        sessionController.handleAction()
        updateUI()
    }

    @objc private func handleFinish() {
        sessionController.finish()
        updateUI()
    }

    private func updateUI() {
        let state = sessionController.state
        switch state {
        case .idle:
            actionButton.setTitle("Start", for: .normal)
            actionButton.backgroundColor = .systemBlue
            actionButton.isHidden = false
            finishButton.isHidden = true
        case .tracking:
            actionButton.setTitle("Pause", for: .normal)
            actionButton.backgroundColor = .systemOrange
            actionButton.isHidden = false
            finishButton.isHidden = false
        case .paused:
            actionButton.setTitle("Continue", for: .normal)
            actionButton.backgroundColor = .systemGreen
            actionButton.isHidden = false
            finishButton.isHidden = false
        case .finished:
            actionButton.setTitle("Reset", for: .normal)
            actionButton.backgroundColor = .systemBlue
            actionButton.isHidden = false
            finishButton.isHidden = true
        }
    }
}

extension ARSessionViewController: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        let cameraPosition = frame.camera.transform.columns.3
        let position = simd_float3(cameraPosition.x, cameraPosition.y, cameraPosition.z)

        if sessionController.state == .tracking {
            sessionController.update(with: position)
        }

        if sessionController.state == .paused {
            sessionController.setPausedPosition(position)
        }

        let distance = sessionController.totalDistance
        distanceLabel.text = String(format: "%.3f m", distance)
    }
}