import Foundation
import UIKit

protocol SortOptionsViewControllerDelegate: class {
    var selections: [Selection]{ get }
    func newSelection(at: Int)
}

class SortOptionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    weak var delegate: SortOptionsViewControllerDelegate?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let optionCell = tableView.dequeueReusableCell(withIdentifier: "optionCell", for: indexPath) as? SortOptionTableViewCell, let delegate = delegate else {
            return UITableViewCell()
        }
        let selection = delegate.selections[indexPath.row]
        optionCell.descriptionLabel.text = selection.option.description
        optionCell.accessoryType = selection.isChecked ? .checkmark : .none
        return optionCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.newSelection(at: indexPath.row)
        tableView.reloadData()
    }
    
}

struct Selection {
    let option: Option
    var isChecked: Bool
}

enum Option: Int {
    case lowestToHighestInPrice = 0
    case aToZForMake = 1
    case aToZForModel = 2
    case oldestToNewest = 3
    
    var description: String {
        switch self {
        case .lowestToHighestInPrice:
            return "Lowest to Highest Price"
        case .aToZForMake:
            return "A to Z For Make of Vehicle"
        case .aToZForModel:
            return "A to Z For Model of Vehicle"
        case .oldestToNewest:
            return "Oldest to Newest"
        }
    }
}

class SortOptionTableViewCell: UITableViewCell{
    @IBOutlet weak var descriptionLabel: UILabel!
}
