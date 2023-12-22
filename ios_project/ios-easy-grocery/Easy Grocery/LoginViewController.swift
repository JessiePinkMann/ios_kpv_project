import UIKit

class LoginViewController: UIViewController {
    let nameLabel = UILabel()
    let descLabel = UILabel()
    
    let continueButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.isToolbarHidden = true
        view.backgroundColor = .systemGray6
        
        self.hideKeyboardWhenTappedAround()
        setupLoginViewSV()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        navigationController?.isToolbarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func setupLoginViewSV() {
        continueButton.setTitle("Продолжить", for: .normal)
        continueButton.addTarget(self, action: #selector(continueButtonPressed), for: .touchUpInside)
        continueButton.setTitleColor(.white, for: .normal)
        continueButton.backgroundColor = .systemBlue
        continueButton.layer.cornerRadius = 8
        continueButton.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .medium)
        continueButton.setHeight(48)
//        continueButton.setWidth(48)
        continueButton.startAnimatingPressActions()
        continueButton.layer.applyShadow(2.0)
        view.addSubview(continueButton)
        continueButton.pin(to: view, [.left, .right], 48)
        continueButton.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, 64)
        
        nameLabel.text = "Easy Grocery"
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont(name: "Happy Monkey", size: 52)
        nameLabel.textColor = UIColor.black
        nameLabel.font = nameLabel.font.withSize(52)
    
        descLabel.text = "помощник для людей с ограничениями питания"
        descLabel.textAlignment = .center
        descLabel.font = UIFont(name: "Fira Sans", size: 20)
        descLabel.textColor = UIColor.black
        descLabel.lineBreakMode = .byWordWrapping
        descLabel.numberOfLines = 2
        
        view.addSubview(nameLabel)
        view.addSubview(descLabel)
        
        nameLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 256)
        nameLabel.pinCenterX(to: view)
        
        descLabel.pinTop(to: nameLabel.bottomAnchor)
        descLabel.pinCenterX(to: view)
        descLabel.setWidth(256)
    }
    
    @objc
    private func continueButtonPressed() {
        loggedIn()
    }
}

extension LoginViewController: PreferencesDelegate {
    func loggedIn() {
        print("Logged in invoked")
        let preferencesViewController = PreferencesViewController()
        preferencesViewController.viewControllerDelegate = self

        navigationController?.pushViewController(preferencesViewController, animated: true)
    }
    
    func switchToSearch() {
        print("Search invoked")
        let searchViewController = SearchPageViewController()

        navigationController?.pushViewController(searchViewController, animated: true)
    }
}

