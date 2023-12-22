import UIKit

final class ProductCell: UICollectionViewCell {
    static let reuseIdentifier = "Product Cell"
    private let productImageView = UIImageView()
    private let productTitleLabel = UILabel()
    private let productQuantityLabel = UILabel() // Volume or the weight of the product
    private let productPriceLabel = UILabel()
    private let productCompatibleIcon = UIImageView(image: UIImage(systemName: "exclamationmark.triangle.fill"))
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setupView() {
        self.backgroundColor = .secondarySystemBackground
        self.layer.cornerRadius = 6
        self.layer.applyShadow(3)
        setupPriceLabel()
        setupQuantityLabel()
        setupTitleLabel()
        setupImageView()
        setupProductCompatibleIcon()
        bringSubviewToFront(productCompatibleIcon)
    }
    
    private func setupImageView() {
        productImageView.layer.cornerRadius = 8
        productImageView.layer.cornerCurve = .continuous
        productImageView.clipsToBounds = true
        productImageView.contentMode = .scaleAspectFit
        productImageView.backgroundColor = .systemBackground
        contentView.addSubview(productImageView)
        
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        productImageView.pinWidth(to: productImageView.heightAnchor)
        productImageView.pinBottom(to: productTitleLabel.topAnchor, 6)
        productImageView.pin(to: contentView, [.left, .right, .top], 6)
    }
    
    private func setupTitleLabel() {
        productTitleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        productTitleLabel.textColor = .label
        productTitleLabel.numberOfLines = 2
        productTitleLabel.lineBreakMode = .byTruncatingTail
        contentView.addSubview(productTitleLabel)
        productTitleLabel.translatesAutoresizingMaskIntoConstraints = false

        productTitleLabel.setHeight(Int(productTitleLabel.font.lineHeight))
        
        productTitleLabel.pinBottom(to: productQuantityLabel.topAnchor, 6)
        productTitleLabel.pin(to: contentView, [.left, .right], 6)
    }
    
    private func setupQuantityLabel() {
        productQuantityLabel.font = .systemFont(ofSize: 12, weight: .light)
        productQuantityLabel.textColor = .systemGray2
        productQuantityLabel.numberOfLines = 1
        contentView.addSubview(productQuantityLabel)
        productQuantityLabel.setHeight(Int(productQuantityLabel.font.lineHeight))
        productQuantityLabel.pinBottom(to: productPriceLabel.topAnchor, 6)
        productQuantityLabel.pin(to: contentView, [.left, .right], 6)
    }
    
    private func setupPriceLabel() {
        productPriceLabel.font = .systemFont(ofSize: 12, weight: .medium)
        productPriceLabel.textColor = .label
        productPriceLabel.numberOfLines = 1
        contentView.addSubview(productPriceLabel)
        productPriceLabel.setHeight(Int(productPriceLabel.font.lineHeight))
        productPriceLabel.pinBottom(to: contentView, 6)
        productPriceLabel.pin(to: contentView, [.left, .right], 6)
    }
    
    private func setupProductCompatibleIcon() {
        productCompatibleIcon.tintColor = .systemRed
        productCompatibleIcon.layer.applyShadow()
        contentView.addSubview(productCompatibleIcon)
        productCompatibleIcon.setHeight(30)
        productCompatibleIcon.setWidth(30)
        productCompatibleIcon.pin(to: contentView, [.right, .top], 6)
//        productCompatibleIcon.isHidden = true
    }
    
    
    // MARK:- Public functions
    public func configure(_ viewModel: ProductViewModel, isExcluded: Bool) {
        productTitleLabel.text = viewModel.name
        productPriceLabel.text = viewModel.price ?? "? ₽"
        productQuantityLabel.text = viewModel.volume ?? viewModel.weight ?? ""
        
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
}
