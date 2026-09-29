// SPDX-License-Identifier: AGPL-3.0-or-later
// Copyright © 2026 Jia Liu

import UIKit

final class SettingsViewController: UITableViewController {

    private let languages = AppLanguage.allCases

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        title = NSLocalizedString("Settings", comment: "")
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSLocalizedString("Language", comment: "")
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageCell")
            ?? UITableViewCell(style: .default, reuseIdentifier: "LanguageCell")

        let language = languages[indexPath.row]
        cell.textLabel?.text = language.displayName

        if LanguageManager.shared.currentLanguage == language {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let selectedLanguage = languages[indexPath.row]
        LanguageManager.shared.currentLanguage = selectedLanguage

        tableView.reloadData()

        showAlert()
    }

    private func showAlert() {
        let alert = UIAlertController(
            title: NSLocalizedString("Settings", comment: ""),
            message: NSLocalizedString("Language changed. Restart the app to apply.", comment: ""),
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: NSLocalizedString("Done", comment: ""), style: .default))
        present(alert, animated: true)
    }
}