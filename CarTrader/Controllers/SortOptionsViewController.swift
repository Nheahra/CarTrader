import Foundation
import UIKit

protocol SortOptionsViewControllerDelegate: class {
    var selections: [SortSelection]{ get }
    func newSelection(at: Int)
    func selectionsCompleted()
    func moveSelection(at source: IndexPath, to destination: IndexPath)
}

class SortOptionsViewController: UIViewController {
    
    weak var delegate: SortOptionsViewControllerDelegate?
    private var isInEditMode = false
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonPressed))
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(editButtonPressed))
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("Sort options are being dismissed")
        delegate?.selectionsCompleted()
    }
    
    @objc func doneButtonPressed() {
        _ = navigationController?.popViewController(animated: true)
    }
    @objc func editButtonPressed() {
        isInEditMode = !isInEditMode
        tableView.isEditing = isInEditMode
        navigationItem.rightBarButtonItem?.style = isInEditMode ? .plain : .done
    }
}
extension SortOptionsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate?.selections.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let optionCell = tableView.dequeueReusableCell(withIdentifier: "optionCell", for: indexPath) as? SortOptionTableViewCell, let delegate = delegate else {
            return UITableViewCell()
        }
        let selection = delegate.selections[indexPath.row]
        optionCell.descriptionLabel.text = selection.option.displayName
        optionCell.accessoryType = selection.isChecked ? .checkmark : .none
        return optionCell
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.UITableViewCell.EditingStyle {
        return UITableViewCell.UITableViewCell.EditingStyle.none
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        delegate?.moveSelection(at: sourceIndexPath, to: destinationIndexPath)
    }
}
extension SortOptionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.newSelection(at: indexPath.row)
        tableView.reloadData()
    }
}
class SortOptionTableViewCell: UITableViewCell {
    @IBOutlet weak var descriptionLabel: UILabel!
}
