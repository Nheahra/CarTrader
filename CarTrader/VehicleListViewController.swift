import UIKit

class CarsModel {

    var vehicles = [Vehicle]()
    var selections: [Selection] = [
        Selection(option: .aToZForMake, isChecked: false),
        Selection(option: .aToZForModel, isChecked: false),
        Selection(option: .oldestToNewest, isChecked: false),
        Selection(option: .lowestToHighestInPrice, isChecked: false)
    ]
    var selectedIndex = 0

    init() {
        let generator = VehiclesGenerator()
        self.vehicles = generator.vehicles
    }
    
    func newSelection(at index: Int) {
        selections[index].isChecked = !selections[index].isChecked
        //use an index for the selections to figure out the mutable factor?
        for selection in selections {
            if selection.isChecked{
//                this sorts everything with the right hierarchy(<- make this mutable? User should be able to list the hierarchy they want to sort by)...but will always sort EVERYTHING
//                        vehicles.sort { (leftCar, rightCar) -> Bool in
//                            return (leftCar.make, leftCar.model, leftCar.year, leftCar.price) < (rightCar.make, rightCar.model, rightCar.year, rightCar.price)
//                            }
                //this will not preserve the hierarchy, but will sort only the selection
                switch selection.option {
                    case .aToZForMake:
                        vehicles.sort { (leftCar, rightCar) -> Bool in
                            return leftCar.make < rightCar.make
                        }
                    case .aToZForModel:
                        vehicles.sort { (leftCar, rightCar) -> Bool in
                            return leftCar.model < rightCar.model
                        }
                    case .oldestToNewest:
                        vehicles.sort { (leftCar, rightCar) -> Bool in
                            return leftCar.year < rightCar.year
                        }
                    case .lowestToHighestInPrice:
                        vehicles.sort { (leftCar, rightCar) -> Bool in
                            return leftCar.price < rightCar.price
                        }
                }
            }
        }
    }
    
}

class CarsCell: UITableViewCell {
    
    @IBOutlet weak var makeLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
}

class VehicleDetailViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    var vehicle: Vehicle?
    
    func setVehicleData(with vehicle: Vehicle) {
        self.vehicle = vehicle
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.text = "id: \(String(describing: vehicle?.id)) | make: \(String(describing: vehicle?.make)) | model: \(String(describing: vehicle?.model)) | type: \(String(describing: vehicle?.type))"
    }
}

class VehicleListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var model: CarsModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        model = CarsModel()
    }
    
    deinit {
        print("Vehicle list was deallocated")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vehicleViewController = segue.destination as? VehicleDetailViewController {
            vehicleViewController.vehicle = model.vehicles[model.selectedIndex]
        } else if let optionsViewController = segue.destination as? SortOptionsViewController {
            optionsViewController.delegate = self
        }
        super.prepare(for: segue, sender: sender)
    }
}

extension VehicleListViewController: SortOptionsViewControllerDelegate{
    var selections: [Selection]{
        return model.selections
    }
    func newSelection(at index: Int) {
        model.newSelection(at: index)
        tableView.reloadData()
    }
}

extension VehicleListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.vehicles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let vehicleCell = tableView.dequeueReusableCell(withIdentifier: "carsCell", for: indexPath) as? CarsCell else {
            return UITableViewCell()
        }
        let vehicle = model.vehicles[indexPath.row]
        vehicleCell.makeLabel.text = "Make: " + vehicle.make
        vehicleCell.modelLabel.text = "Model: " + vehicle.model
        vehicleCell.yearLabel.text = "Year: \(vehicle.year)"
        return vehicleCell
    }
}

extension VehicleListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("User selected row: \(indexPath.row)")
        model.selectedIndex = indexPath.row
        performSegue(withIdentifier: "showDetails", sender: self)
    }
}
