import UIKit

final class ProductPageViewController: UIViewController {
    private let productImageView = UIImageView()
    private let productTitleLabel = UILabel()
    private let productDescriptionLabel = UILabel()
    private let productContentsLabel = UILabel()
    private let productQuantityLabel = UILabel() // Volume or the weight of the product
    private let productPriceLabel = UILabel()
    private let productCompatibleIcon = UIImageView(image: UIImage(systemName: "exclamationmark.triangle.fill"))
    private var KCALBackground = UIView()
    
    private var productModel = ProductViewModel("none")
    
    var shopURL = URL(string: "")
    
    private let productToShopButton = UIButton()
    
    let contentView = UIView()
    let scrollView = UIScrollView()
    
    let KCALTable = UITableView()
    
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
        view.backgroundColor = .systemBackground
//        let scrollView = UIScrollView(frame: view.bounds)
//        let scrollView = UIScrollView()
//        scrollView.contentSize.width = 0
//        scrollView.contentSize = CGSize(width: view.bounds.width, height: 2000)
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.pin(to: view, [.top, .left, .right, .bottom])
        scrollView.addSubview(contentView)
        
        setupNavbar()
        setImageView()
        setTitleLabel()
        
        setupToShopButton()
        
        setupPriceLabel()
        setupQuantityLabel()
        
        setDescriptionLabel()
        setContentsLabel()
        setKCALTable()
        
        setOtherInfo()
        
        setupProductCompatibleIcon()
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
//        contentView.pin(to: scrollView, [.top, .bottom, .left, .right])
//        scrollView.backgroundColor = .systemBlue
//        contentView.backgroundColor = .systemRed
        contentView.pinLeft(to: scrollView.contentLayoutGuide.leadingAnchor)
        contentView.pinRight(to: scrollView.contentLayoutGuide.trailingAnchor)
        contentView.pinTop(to: scrollView.contentLayoutGuide.topAnchor)
        contentView.pinBottom(to: scrollView.contentLayoutGuide.bottomAnchor)
        
        contentView.pinCenter(to: scrollView)
        contentView.pinWidth(to: scrollView.frameLayoutGuide.widthAnchor)
//        contentView.pinHeight(to: scrollView.frameLayoutGuide.heightAnchor)
        let equalHeightConstraint = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        equalHeightConstraint.priority = UILayoutPriority(250)
        equalHeightConstraint.isActive = true
        let equalYConstraint = contentView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
        equalYConstraint.priority = UILayoutPriority(250)
        equalYConstraint.isActive = true
        
//        scrollView.contentSize = contentView.frame.size
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
    
    private func setImageView() {
        productImageView.layer.cornerRadius = 8
        productImageView.layer.cornerCurve = .continuous
        productImageView.clipsToBounds = true
        productImageView.contentMode = .scaleAspectFit
        productImageView.backgroundColor = .systemBackground
        contentView.addSubview(productImageView)
        
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        productImageView.setHeight(180)
        productImageView.pinWidth(to: productImageView.heightAnchor)
        productImageView.pin(to: contentView, [.left, .top], 6)
        productImageView.pinRight(to: contentView.centerXAnchor)
    }

    private func setTitleLabel() {
        productTitleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        productTitleLabel.numberOfLines = 4
        productTitleLabel.textColor = .label
        contentView.addSubview(productTitleLabel)
        
        productTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        productTitleLabel.pin(to: contentView, [.top, .right], 6)
        productTitleLabel.pinLeft(to: productImageView.safeAreaLayoutGuide.trailingAnchor, 6)
        productTitleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 16).isActive = true
    }
    
    private func setupQuantityLabel() {
        productQuantityLabel.font = .systemFont(ofSize: 12, weight: .light)
        productQuantityLabel.textColor = .systemGray2
        productQuantityLabel.numberOfLines = 1
        contentView.addSubview(productQuantityLabel)
        
        productQuantityLabel.translatesAutoresizingMaskIntoConstraints = false
        productQuantityLabel.setHeight(Int(productQuantityLabel.font.lineHeight))
        productQuantityLabel.pinLeft(to: productImageView.safeAreaLayoutGuide.trailingAnchor, 6)
        productQuantityLabel.pinBottom(to: productPriceLabel.topAnchor, 6)
        productQuantityLabel.pinRight(to: contentView, 6)
    }
    
    private func setupPriceLabel() {
        productPriceLabel.font = .systemFont(ofSize: 12, weight: .medium)
        productPriceLabel.textColor = .label
        productPriceLabel.numberOfLines = 1
        contentView.addSubview(productPriceLabel)
        
        productPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        productPriceLabel.setHeight(Int(productPriceLabel.font.lineHeight))
        productPriceLabel.pinLeft(to: productImageView.safeAreaLayoutGuide.trailingAnchor, 6)
        productPriceLabel.pinBottom(to: productToShopButton.topAnchor, 8)
        productPriceLabel.pinRight(to: contentView, 6)
    }
    
    private func setupToShopButton() {
        productToShopButton.setTitle("Перейти в магазин", for: .normal)
        productToShopButton.setTitleColor(.white, for: .normal)
        productToShopButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        productToShopButton.backgroundColor = .label
        productToShopButton.tintColor = .white
        
        productToShopButton.layer.cornerRadius = 8
        productToShopButton.layer.applyShadow(3)
        
        productToShopButton.addTarget(self, action: #selector(goToShopTapped), for: .touchUpInside)
        
        productToShopButton.startAnimatingPressActions()
        
        contentView.addSubview(productToShopButton)
        
        productToShopButton.translatesAutoresizingMaskIntoConstraints = false
        productToShopButton.setHeight(48)
        productToShopButton.pinLeft(to: productImageView.safeAreaLayoutGuide.trailingAnchor, 6)
        productToShopButton.pinBottom(to: productImageView.bottomAnchor)
        productToShopButton.pinRight(to: contentView, 12)
    }
    
    private func getBackgroundView() -> UIView {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .systemGray6
        backgroundView.layer.cornerRadius = 8
        backgroundView.layer.applyShadow(3)
        return backgroundView
    }
    
    private func setDescriptionLabel() {
        let descriptionBackgroundView = getBackgroundView()
        contentView.addSubview(descriptionBackgroundView)
        
        let headerLabel = UILabel()
        headerLabel.font = .systemFont(ofSize: 16, weight: .bold)
        headerLabel.text = "Описание"
        headerLabel.textColor = .label
        contentView.addSubview(headerLabel)
        
        productDescriptionLabel.font = .systemFont(ofSize: 14, weight: .regular)
        productDescriptionLabel.numberOfLines = 3
        productDescriptionLabel.lineBreakMode = .byTruncatingTail
        productDescriptionLabel.textColor = .label
        contentView.addSubview(productDescriptionLabel)
        
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.pin(to: contentView, [.left, .right], 24)
        headerLabel.pinTop(to: productImageView.bottomAnchor, 24)
        
        productDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        productDescriptionLabel.pin(to: contentView, [.left, .right], 24)
        productDescriptionLabel.pinTop(to: headerLabel.bottomAnchor, 24)
        
        descriptionBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        descriptionBackgroundView.pinTop(to: headerLabel.topAnchor, -12)
        descriptionBackgroundView.pin(to: productDescriptionLabel, [.left, .bottom, .right], -12)
    }
    
    private func setContentsLabel() {
        let contentsBackgroundView = getBackgroundView()
        contentView.addSubview(contentsBackgroundView)
        
        let headerLabel = UILabel()
        headerLabel.font = .systemFont(ofSize: 16, weight: .bold)
        headerLabel.text = "Состав"
        headerLabel.textColor = .label
        contentView.addSubview(headerLabel)
        
        productContentsLabel.font = .systemFont(ofSize: 14, weight: .regular)
        productContentsLabel.numberOfLines = 15
        productContentsLabel.lineBreakMode = .byTruncatingTail
        productContentsLabel.textColor = .label
        contentView.addSubview(productContentsLabel)
        
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.pin(to: contentView, [.left, .right], 24)
        headerLabel.pinTop(to: productDescriptionLabel.bottomAnchor, 32)
        
        productContentsLabel.translatesAutoresizingMaskIntoConstraints = false
        productContentsLabel.pin(to: contentView, [.left, .right], 24)
        productContentsLabel.pinTop(to: headerLabel.bottomAnchor, 24)
//        productContentsLabel.setHeight(Int(headerLabel.font.lineHeight) * 5)
        
        contentsBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        contentsBackgroundView.pinTop(to: headerLabel.topAnchor, -12)
        contentsBackgroundView.pin(to: productContentsLabel, [.left, .bottom, .right], -12)
    }
    
    private func setKCALTable() {
        let tableBackgroundView = getBackgroundView()
        contentView.addSubview(tableBackgroundView)

        KCALTable.translatesAutoresizingMaskIntoConstraints = false
//        KCALTable.frame = contentView.bounds
        KCALTable.dataSource = self
        KCALTable.delegate = self
        KCALTable.register(TwoColumnTableCell.self, forCellReuseIdentifier: "cell")
        KCALTable.isScrollEnabled = false
        KCALTable.sizeToFit()
        KCALTable.isUserInteractionEnabled = false
        let tableHeader = UILabel()
        tableHeader.font = .systemFont(ofSize: 16, weight: .bold)
        tableHeader.text = "Пищевая ценность на 100 г"
        tableHeader.textColor = .label

        contentView.addSubview(KCALTable)
        contentView.addSubview(tableHeader)

        tableHeader.translatesAutoresizingMaskIntoConstraints = false
        tableHeader.setHeight(Int(tableHeader.font.lineHeight))
        tableHeader.pinTop(to: productContentsLabel.bottomAnchor, 32)
        tableHeader.pin(to: contentView, [.left, .right], 24)

        KCALTable.setHeight(176)
        KCALTable.pinTop(to: tableHeader.bottomAnchor, 12)
        KCALTable.pin(to: contentView, [.left, .right], 24)

        tableBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        tableBackgroundView.pinTop(to: tableHeader.topAnchor, -12)
        tableBackgroundView.pin(to: KCALTable, [.left, .bottom, .right], -12)
    }
    
    private func setOtherInfo() {
        let manufacturer = UILabel()
        let trademark = UILabel()
        let country = UILabel()
        let expiryDate = UILabel()
        manufacturer.text = "Производитель"
        trademark.text = "Торговая марка"
        country.text = "Страна"
        expiryDate.text = "Срок годности"
        
        let modelManufacturerText = productModel.manufacturer
        let modelTrademarkText = productModel.trademark
        let modelCountryText = productModel.country
        let modelExpiryText = productModel.expiresIn
        
        for (label, modelText) in zip([manufacturer, trademark, country, expiryDate], [modelManufacturerText, modelTrademarkText, modelCountryText, modelExpiryText]) {
            let modelLabel = UILabel()
            modelLabel.text = modelText ?? ""
            modelLabel.font = .systemFont(ofSize: 14, weight: .light)
            modelLabel.textColor = .label
            
            label.font = .systemFont(ofSize: 14, weight: .medium)
            label.textColor = .label
            
            contentView.addSubview(label)
            contentView.addSubview(modelLabel)
            
            label.translatesAutoresizingMaskIntoConstraints = false
            label.setHeight(Int(label.font.lineHeight))
            label.pinLeft(to: contentView, 24)
            label.pinRight(to: contentView.centerXAnchor)
            
            modelLabel.translatesAutoresizingMaskIntoConstraints = false
            modelLabel.setHeight(Int(label.font.lineHeight))
            modelLabel.pinLeft(to: contentView.centerXAnchor)
            modelLabel.pinRight(to: contentView, 24)
            modelLabel.pinTop(to: label.topAnchor)
        }
        
        expiryDate.pinTop(to: KCALTable.bottomAnchor, 32)
        manufacturer.pinTop(to: expiryDate.bottomAnchor, 12)
        country.pinTop(to: manufacturer.bottomAnchor, 12)
        trademark.pinTop(to: country.bottomAnchor, 12)
        trademark.pinBottom(to: contentView.bottomAnchor, 8)
    }
    
    private func setupProductCompatibleIcon() {
        productCompatibleIcon.tintColor = .systemRed
        productCompatibleIcon.layer.applyShadow()
        contentView.addSubview(productCompatibleIcon)
        productCompatibleIcon.translatesAutoresizingMaskIntoConstraints = false
        productCompatibleIcon.setHeight(30)
        productCompatibleIcon.setWidth(30)
        productCompatibleIcon.pin(to: contentView, [.left, .top], 6)
//        productCompatibleIcon.isHidden = true
    }
    
    // MARK: - Public Methods
    public func configure(with viewModel: ProductViewModel, isExcluded: Bool) {
        productModel = viewModel
        
        productTitleLabel.text = viewModel.name
        productPriceLabel.text = viewModel.price ?? "? ₽"
        productQuantityLabel.text = viewModel.volume ?? viewModel.weight ?? ""
        productDescriptionLabel.text = viewModel.description ?? "Описание отсутствует."
        productContentsLabel.text = viewModel.contents ?? "Состав отсутствует."
        shopURL = viewModel.productURL
        
        productCompatibleIcon.isHidden = !isExcluded
        
        if let image = ProductCollectionViewController.imageCache.object(forKey: (viewModel.imageURL?.absoluteString ?? "") as NSString) as? UIImage {
            productImageView.image = image
        } else if let url = viewModel.imageURL {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data else {
                    return
                }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    let imageToCache = UIImage(data: data)
                    ProductCollectionViewController.imageCache.setObject(imageToCache!, forKey: url.absoluteString as NSString)
                    self?.productImageView.image = imageToCache
                }
            }.resume()
        }
    }
    
    // MARK: - Objc functions
    @objc
    private func goToShopTapped() {
        guard let url = shopURL else { return }
        UIApplication.shared.open(url)
    }
    
    @objc
    private func closeButtonTapped() {
//        dismiss(animated: true)
        self.navigationController?.popViewController(animated: true)
    }
}

extension ProductPageViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
}

extension ProductPageViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
}

extension ProductPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TwoColumnTableCell
        
        switch indexPath.row {
        case 0:
            cell.column1Label.text = "Белки"
            cell.column2Label.text = productModel.protein ?? ""
        case 1:
            cell.column1Label.text = "Жиры"
            cell.column2Label.text = productModel.fats ?? ""
        case 2:
            cell.column1Label.text = "Углеводы"
            cell.column2Label.text = productModel.carbohydrates ?? ""
        case 3:
            cell.column1Label.text = "Калорийность"
            cell.column2Label.text = productModel.kcal ?? ""
            if ((cell.column2Label.text?.count ?? 0) > 0 && !(cell.column2Label.text?.contains("ккал") ?? true)) {
                cell.column2Label.text? += " ккал"
            }
        default:
            break
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        // Disable selection for all rows
        return nil
    }
}
