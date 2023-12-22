import UIKit

final class PreferencesViewController: UIViewController {
    private var excludeSet = Set<String>()
    
    private let cellAddField =  UITextField(frame: CGRect(x: 20, y: 100, width: 300, height: 40))
    
    private var presetsButton = UIBarButtonItem()
    private var manualButton = UIBarButtonItem()
    
    private let presetsUIButton = UIButton()
    private let manualUIButton = UIButton()
    
    let presetsTableVC = CheckboxTableViewController()
    let manualTableVC = CheckboxTableViewController()
    
    var viewControllerDelegate: PreferencesDelegate?
    
    var currentView = 0
//    private var isLoggedIn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        navigationController?.isToolbarHidden = false
        self.hideKeyboardWhenTappedAround()
        setupUI()

        let isLoggedIn = UserDefaults.standard.bool(forKey: "is_authenticated")
        
        if isLoggedIn {
            excludeSet = Set(ParsingHelper.getExcludePreferences())
        }
        print("Loggedin:", isLoggedIn, "exclude:", excludeSet)
        
        if (!isLoggedIn) {
            presetsTableVC.configure(items: ParsingHelper.parseJSONFile(filename: "Presets") ?? [])
            manualTableVC.configure(items: ParsingHelper.parseJSONFile(filename: "Manual") ?? [])
        } else {
            presetsTableVC.configure(items: ParsingHelper.loadSavedJSONFile(filename: "Presets") ?? [], selectedItems: ParsingHelper.loadSavedJSONFile(filename: "PresetsSelected") ?? [])
            manualTableVC.configure(items: ParsingHelper.loadSavedJSONFile(filename: "Manual") ?? [], selectedItems: ParsingHelper.loadSavedJSONFile(filename: "ManualSelected") ?? [])
        }
        
        manualUpdated()
        presetsUpdated()
        
        presetsPressed()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationController?.isToolbarHidden = false
        
    }
    
    // MARK:- Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupField(cellAddField)
        view.addSubview(cellAddField)
        manualTableVC.tableView.tableHeaderView = cellAddField
        
        setupNavbar()
        setupToolbar()
    }
    
    private func setupToolbar() {
        presetsUIButton.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        presetsUIButton.setTitle("Предустановки", for: .normal)
        presetsUIButton.addTarget(self, action: #selector(presetsPressed), for: .touchUpInside)
        
        manualUIButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        manualUIButton.setTitle("Выбрать вручную", for: .normal)
        manualUIButton.addTarget(self, action: #selector(manualPressed), for: .touchUpInside)

        for button in [presetsUIButton, manualUIButton] {
            button.setTitleColor(.systemBlue, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .medium)
            button.sizeToFit()
            button.scaleImage(1.5)
            
            button.centerVertically()
        }
        
        presetsUIButton.setColor(.systemBlue)
        manualUIButton.setColor(.systemGray2)
        
        updateToolBar()
    }
    
    private func updateToolBar() {
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        
        presetsButton = UIBarButtonItem(customView: presetsUIButton)
        manualButton = UIBarButtonItem(customView: manualUIButton)
        
        self.toolbarItems = [flexibleSpace, presetsButton, flexibleSpace, manualButton, flexibleSpace]
    }
    
    private func setupNavbar() {
        navigationItem.title = "Предпочтения"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(goBackPressed)
        )
        navigationItem.leftBarButtonItem?.tintColor = .label
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Готово",
            style: .done,
            target: self,
            action: #selector(donePressed)
        )
    }
    
    private func setupField(_ field: UITextField) {
        field.placeholder = "Добавить исключение..."
        field.backgroundColor = .white
        field.font = UIFont.systemFont(ofSize: 15)
        
        field.autocorrectionType = UITextAutocorrectionType.no
        field.keyboardType = UIKeyboardType.default
        field.returnKeyType = UIReturnKeyType.done
        field.clearButtonMode = UITextField.ViewMode.whileEditing
        field.textAlignment = .left
        field.setLeftPaddingPoints(10)
        field.setRightPaddingPoints(10)
//            field.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        field.delegate = self
        field.layer.cornerRadius = 8
//            field.layer.applyShadow(2.0)
        field.setHeight(48)
    }
    
    // MARK:- Update actions
    
    private func addExcludedItem() {
        if let text = cellAddField.text {
            self.excludeSet.formUnion([text])
            let tempCell = CheckboxCell(title: text, excludes: [text])
            if !manualTableVC.items.contains(tempCell) {
                manualTableVC.items.append(tempCell)
                manualTableVC.selectedItems.append(tempCell)
                manualTableVC.tableView.beginUpdates()
                manualTableVC.tableView.insertRows(at: [IndexPath(row: manualTableVC.items.count-1, section: 0)], with: .automatic)
                manualTableVC.tableView.endUpdates()
            }
        }
        
    }
    
    private func presetsUpdated() {
        for cell in presetsTableVC.selectedItems {
            self.excludeSet.formUnion(cell.excludes)
            for item in cell.excludes {
                let tempCell = CheckboxCell(title: item, description: "", excludes: [item])
                if !manualTableVC.items.contains(tempCell) {
                    manualTableVC.items.append(tempCell)
                }
                if !manualTableVC.selectedItems.contains(tempCell) {
                    manualTableVC.selectedItems.append(tempCell)
                }
            }
        }
        debugCellSet(presetsTableVC.selectedItems)
        debugCellSet(manualTableVC.selectedItems)
    }
    
    private func manualUpdated() {
        var tempSet = Set<String>()
        for cell in manualTableVC.selectedItems {
            tempSet.formUnion(cell.excludes)
        }
        self.excludeSet = tempSet
        
        let tempSelected = presetsTableVC.selectedItems
        for cell in tempSelected {
            for item in cell.excludes {
                if !self.excludeSet.contains(item) {
                    presetsTableVC.selectedItems.removeAll { $0 == cell }
                    break
                }
            }
        }
        
        debugCellSet(presetsTableVC.selectedItems)
        debugCellSet(manualTableVC.selectedItems)
    }
    
    private func debugCellSet(_ items: [CheckboxCell]) {
        print(items.count)
        for item in items {
            print(item.title, terminator: ", ")
        }
        print()
    }
    
    // MARK:- objc Button actions
    
    @objc
    private func presetsPressed() {
        currentView = 0
        print("Presets pressed")
        manualUIButton.setColor(.systemGray2)
        presetsUIButton.setColor(.systemBlue)
        updateToolBar()
        manualUpdated()
        manualTableVC.dismiss(animated: false)
        
        addChild(presetsTableVC)
        view.addSubview(presetsTableVC.view)
        
        presetsTableVC.updateTableViewSelection()
        
        presetsTableVC.view.translatesAutoresizingMaskIntoConstraints = false
        presetsTableVC.view.pin(to: view, [.top, .bottom, .left, .right])

        presetsTableVC.didMove(toParent: self)
    }
    
    @objc
    private func manualPressed() {
        currentView = 1
        print("Manual pressed")
        presetsUIButton.setColor(.systemGray2)
        manualUIButton.setColor(.systemBlue)
        updateToolBar()
        presetsUpdated()
        presetsTableVC.dismiss(animated: false)
        
//        setupField(cellAddField)
//        view.addSubview(cellAddField)

        addChild(manualTableVC)
        view.addSubview(manualTableVC.view)

        manualTableVC.updateTableViewSelection()

        manualTableVC.view.translatesAutoresizingMaskIntoConstraints = false
        manualTableVC.view.pinTop(to: view, 6)
        manualTableVC.view.pin(to: view, [.bottom, .left, .right])

//        manualTableVC.tableView.tableHeaderView = cellAddField

        manualTableVC.didMove(toParent: self)
    }
    
    @objc
    private func goBackPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func donePressed() {
        if currentView == 0 {
            presetsUpdated()
        } else if currentView == 1 {
            manualUpdated()
        }
        print("Done pressed")
        ParsingHelper.setExcludePreferences(Array(self.excludeSet))
        
        ParsingHelper.saveJSONFile(filename: "Manual", items: manualTableVC.items)
        ParsingHelper.saveJSONFile(filename: "ManualSelected", items: manualTableVC.selectedItems)
        ParsingHelper.saveJSONFile(filename: "Presets", items: presetsTableVC.items)
        ParsingHelper.saveJSONFile(filename: "PresetsSelected", items: presetsTableVC.selectedItems)
        
        logIn()
        viewControllerDelegate?.switchToSearch()
    }
    
    func logIn() {
        let def = UserDefaults.standard
        def.set(true, forKey: "is_authenticated")
        def.synchronize()
    }
}

protocol PreferencesDelegate {
    func loggedIn()
    func switchToSearch()
}

// MARK:- UITextFieldDelegate
extension PreferencesViewController: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // return NO to disallow editing.
        print("TextField should begin editing method called")
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        // became first responder
        print("TextField did begin editing method called")
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
        print("TextField should snd editing method called")
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
        print("TextField did end editing method called")
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        // if implemented, called in place of textFieldDidEndEditing:
        print("TextField did end editing with reason method called")
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // return NO to not change text
        print("While entering the characters this method gets called")
        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        // called when clear button pressed. return NO to ignore (no notifications)
        print("TextField should clear method called")
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // called when 'return' key pressed. return NO to ignore.
        print("TextField should return method called")
        if (cellAddField.text?.count ?? 0 > 0) {
            addExcludedItem()
        }
    
        cellAddField.text = ""
        textField.resignFirstResponder()
        // may be useful: textField.resignFirstResponder()
        return true
    }

}
