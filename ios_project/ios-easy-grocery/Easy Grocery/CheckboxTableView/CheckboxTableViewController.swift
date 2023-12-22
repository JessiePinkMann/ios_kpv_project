import UIKit

class CheckboxTableViewController: UITableViewController {
    var items: [CheckboxCell] = []
    var selectedItems: [CheckboxCell] = []
    var checkboxInActiveType = String("")
    var checkboxActiveType = String("")

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CheckboxTableViewCell.self, forCellReuseIdentifier: "CheckboxCell")
        tableView.allowsSelection = false
        
        updateTableViewSelection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateTableViewSelection()
    }
    
    func updateTableViewSelection() {
        for (row, cell) in items.enumerated() {
            let indexPath = IndexPath(row: row, section: 0)
//            print(row, cell.title)
            if selectedItems.contains(cell) {
                print("contains ", row, cell.title)
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            } else {
                tableView.deselectRow(at: indexPath, animated: false)
                
            }
        }
        tableView.reloadData()
    }


    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect the cell
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(items.count)
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CheckboxCell", for: indexPath) as? CheckboxTableViewCell else {
            fatalError("Unable to dequeue CheckboxTableViewCell")
        }

        let item = items[indexPath.row]
        cell.checkboxTableViewControllerDelegate = self
        cell.titleLabel.text = item.title
        cell.descriptionLabel.text = item.description
        cell.cellInit = item
        cell.checkboxButton.isSelected = selectedItems.contains(item)
//        cell.checkboxButton.addTarget(self, action: #selector(checkboxTapped), for: .touchUpInside)
        
        return cell
    }
    
    func configure(items: [CheckboxCell], selectedItems: [CheckboxCell]? = nil, checkboxInactiveType: String = "square", checkboxActiveType: String = "checkmark.square.fill") {
        self.checkboxActiveType = checkboxActiveType
        self.checkboxInActiveType = checkboxInactiveType
        self.items.append(contentsOf: items)
        self.selectedItems.append(contentsOf: selectedItems ?? [])
    }

    // MARK: - Checkbox button action

//    @objc private func checkboxTapped(sender: CheckboxButton) {
//        print("checkboxTapped invoked")
//        guard let cell = sender.superview as? CheckboxTableViewCell,
//              let indexPath = tableView.indexPath(for: cell) else {
//            return
//        }
//        print("Checkbox ", cell.titleLabel.text ?? "None", " pressed")
//        let item = items[indexPath.row]
//        if sender.isSelected {
//            selectedItems.append(item)
//        } else {
//            if let index = selectedItems.firstIndex(of: item) {
//                selectedItems.remove(at: index)
//            }
//        }
//        print(selectedItems)
//    }
}

protocol CheckboxTableViewControllerDelegate {
    func selectCell(_ cell: CheckboxCell)
    func deselectCell(_ cell: CheckboxCell)
    var checkboxInActiveType: String { get }
    var checkboxActiveType: String { get }
}

extension CheckboxTableViewController: CheckboxTableViewControllerDelegate {
    func selectCell(_ cell: CheckboxCell) {
        selectedItems.append(cell)
        self.selectedItems = Array(Set(self.selectedItems))
    }
    
    func deselectCell(_ cell: CheckboxCell) {
        selectedItems.removeAll { $0 == cell }
    }
}
