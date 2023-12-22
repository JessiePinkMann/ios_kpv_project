import UIKit

final class SearchPageViewController: UIViewController {
    private var imageView = UIImageView()
    
    var cameraButton = UIBarButtonItem()
    var searchButton = UIBarButtonItem()
    var settingsButton = UIBarButtonItem()
    
    var cameraUIButton = UIButton()
    var searchUIButton = UIButton()
    var settingsUIButton = UIButton()

    var currentView = 0
    
    var hideExcludedEnabled = false
    
    let settingsViewController = SettingsViewController()
    let productTableViewController = ProductCollectionViewController()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        navigationController?.isToolbarHidden = true
        settingsViewController.switchDelegate = self
        setupUI()
        
        searchPressed()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationController?.isToolbarHidden = true
        setupUI()
        searchPressed()
    }
    
    // MARK:- Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        setupNavbar()
    }
    
    private func setupNavbar() {
        navigationItem.title = "Поиск"

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "camera.fill"),
            style: .plain,
            target: self,
            action: #selector(cameraPressed) //#selector(goBackPressed)
        )
        navigationItem.leftBarButtonItem?.tintColor = .label
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "line.horizontal.3"),
            style: .done,
            target: self,
            action: #selector(settingsPressed)
        )
        navigationItem.rightBarButtonItem?.tintColor = .label
    }
    
    private func chooseButton(_ chosenButton: UIButton) {
        for button in [cameraUIButton, settingsUIButton, searchUIButton] {
            button.setColor(.systemGray2)
        }
        chosenButton.setColor(.systemBlue)
    }
    
    // MARK:- objc Button actions
    
    @objc
    private func searchPressed() {
        currentView = 1
        print("Search pressed. Hide excluded:", self.hideExcludedEnabled)
        chooseButton(searchUIButton)
//        updateToolBar()
        
        productTableViewController.hideExcludedEnabled = self.hideExcludedEnabled
        addChild(productTableViewController)
        view.addSubview(productTableViewController.view)
        productTableViewController.collectionView.reloadData()
        productTableViewController.view.pin(to: view, [.top, .bottom, .left, .right])
    }
    
    @objc
    private func cameraPressed() {
        currentView = 0
        print("Camera pressed")
        chooseButton(cameraUIButton)
        let barcodeScannerVC = BarcodeScannerViewController()
        navigationController?.pushViewController(barcodeScannerVC, animated: true)
//        present(barcodeScannerVC, animated: true)

//        updateToolBar()
    }
    
    @objc
    private func settingsPressed() {
        print("Settings pressed")
        navigationController?.pushViewController(settingsViewController, animated: true)
    }
}

extension SearchPageViewController: SettingsHideSwitchDelegate {
    func hideExcluded() {
        self.hideExcludedEnabled = true
    }
    
    func showExcluded() {
        self.hideExcludedEnabled = false
    }
}
