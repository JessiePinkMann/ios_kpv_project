import UIKit

class ScannedProductPageViewController: UIViewController {
    private let productTitleLabel = UILabel()
    private let productDescriptionLabel = UILabel()
    private let productContentsLabel = UILabel()
    private let productCompatibleIcon = UIImageView(image: UIImage(systemName: "exclamationmark.triangle.fill"))
    private let productCompatibleText = UILabel()
    
    let stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: - Private methods
    private func setupUI() {
        setupNavbar()
        view.backgroundColor = .systemBackground
        
        stackView.axis = .vertical
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .systemGray5
        stackView.layer.cornerRadius = 12
        stackView.spacing = 8
        
        [productTitleLabel, productDescriptionLabel, productContentsLabel].forEach {
            $0.font = .systemFont(ofSize: 14, weight: .medium)
            $0.numberOfLines = 10
            $0.lineBreakMode = .byTruncatingTail
            $0.textColor = .label
            
            stackView.addArrangedSubview($0)
            
            $0.pinLeft(to: stackView.layoutMarginsGuide.leadingAnchor)
            $0.pinRight(to: stackView.layoutMarginsGuide.trailingAnchor)
        }
        productTitleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        
        
        let compatibleView = UIView()
        compatibleView.translatesAutoresizingMaskIntoConstraints = false

//        compatibleText.text = "Тут будет текст"
        productCompatibleText.numberOfLines = 1
        productCompatibleText.font = .systemFont(ofSize: 14, weight: .light)
        productCompatibleText.textColor = .label

        productCompatibleIcon.tintColor = .systemRed
        productCompatibleIcon.layer.applyShadow()

        compatibleView.addSubview(productCompatibleIcon)
        compatibleView.addSubview(productCompatibleText)
        
//        compatibleView.setHeight(Int(compatibleText.font.lineHeight))

        productCompatibleIcon.translatesAutoresizingMaskIntoConstraints = false
        productCompatibleText.translatesAutoresizingMaskIntoConstraints = false

//        productCompatibleIcon.setHeight(30)
        productCompatibleIcon.pinLeft(to: compatibleView)
        productCompatibleIcon.pinTop(to: productCompatibleText.topAnchor)
        productCompatibleIcon.pinBottom(to: productCompatibleText.bottomAnchor)
        productCompatibleIcon.setWidth(30)

//        compatibleView.setHeight(48)

//        productCompatibleIcon.pin(to: compatibleView, [.top, .left, .bottom])
        productCompatibleText.pinLeft(to: productCompatibleIcon.trailingAnchor, 6)
        productCompatibleText.pin(to: compatibleView, [.right])

        stackView.addArrangedSubview(compatibleView)
        compatibleView.pin(to: stackView, [.left, .right], 8)
        
        view.addSubview(stackView)
        stackView.pin(to: self.view, [.left, .right], 8)
        stackView.pinTop(to: self.view.safeAreaLayoutGuide.topAnchor, 24)
        stackView.pinBottom(to: self.view.safeAreaLayoutGuide.bottomAnchor, 24)
    }
    
    private func setupNavbar() {
        navigationItem.title = ""
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(closeButtonTapped)
        )
        navigationItem.leftBarButtonItem?.tintColor = .label
    }
    
    private func getBackgroundView() -> UIView {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .systemGray6
        backgroundView.layer.cornerRadius = 8
        backgroundView.layer.applyShadow(3)
        return backgroundView
    }
    
    // MARK: - Public Methods
    public func configure(with viewModel: ProductViewModel) {
        productTitleLabel.text = viewModel.name
        productDescriptionLabel.text = viewModel.description ?? "Описание отсутствует."
        productContentsLabel.text = viewModel.contents ?? "Состав отсутствует."
        
        var shouldExclude = false
        for excludedItem in Set(ParsingHelper.getExcludePreferences()) {
            if ParsingHelper.shouldExcludeProductByItem(excludedItem: excludedItem, product: viewModel) {
                shouldExclude = true
                break
            }
        }
        
        if shouldExclude {
            productCompatibleIcon.isHidden = false
            productCompatibleText.text = "Скорее всего, данный товар вам не подходит."
        } else {
            productCompatibleIcon.isHidden = true
            productCompatibleText.text = "Скорее всего, данный товар вам подходит."
        }
    }
    
    // MARK: - Objc functions    
    @objc
    private func closeButtonTapped() {
        dismiss(animated: true)
//        self.navigationController?.popViewController(animated: true)
    }
}
