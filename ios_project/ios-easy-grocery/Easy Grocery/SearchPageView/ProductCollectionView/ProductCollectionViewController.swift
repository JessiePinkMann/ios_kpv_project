import UIKit

class ProductCollectionViewController: UIViewController, SkeletonDisplayable {
    var collectionView: UICollectionView!
    private var productViewModels = [ProductViewModel]()
    private var isLoading = false
    private var excludedViewModels = [ProductViewModel]()
    
    private var currentPage = 1
    private var totalPages = 1
    
    var excludeSet = Set<String>()
    let productsAll = ParsingHelper.getProductsCSV()
    
    private let searchBar = UISearchBar()
    
    var hideExcludedEnabled = false
    
    public static let imageCache = NSCache<NSString, AnyObject>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        self.hideKeyboardWhenTappedAround()
        
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isLoading {
            showSkeleton()
        } else {
            hideSkeleton()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchProducts(searchString: searchBar.text)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.titleView = searchBar
        configureSearchBar()
        
        configureCollectionView()
        fetchProducts(searchString: searchBar.text)
    }
    
    private func configureSearchBar() {
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        searchBar.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 6)
        searchBar.pin(to: view, [.left, .right])
        searchBar.setHeight(32)
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let itemWidth = (view.frame.width - 30) / 2
        let itemHeight = itemWidth * 1.5
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.reuseIdentifier)
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.pinTop(to: searchBar.bottomAnchor, 6)
        collectionView.pin(to: view, [.bottom, .left, .right])
    }
    
    func fetchProducts(searchString: String?) {
        productViewModels = []
        collectionView.isScrollEnabled = false
        self.isLoading = true
        self.showSkeleton()
        self.productViewModels = []
        self.excludeSet = Set(ParsingHelper.getExcludePreferences())
        
        let pageSize = 16
//        let startIndex = max(0, currentPage * pageSize - pageSize)
        let startIndex = 0
        var endIndex = currentPage * pageSize
        
        totalPages = productsAll.count / pageSize
        
        var products = productsAll
        
        
        if let searchString = searchString, !searchString.isEmpty {
            products = products.filter { product in
                let name = product.name.lowercased()
                let desc = product.description?.lowercased() ?? ""
                return name.contains(searchString.lowercased()) || desc.contains(searchString.lowercased())
            }
        }
        endIndex = min(products.count, endIndex)
        
        for product in products[startIndex..<endIndex] {
            var shouldAppend = true
            for excludedItem in excludeSet {
                if ParsingHelper.shouldExcludeProductByItem(excludedItem: excludedItem, product: product) {
                    excludedViewModels.append(product)
                    shouldAppend = false
                    break
                }
            }
            
            if !hideExcludedEnabled || shouldAppend {
                productViewModels.append(product)
            }
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.collectionView.reloadData()
            self.hideSkeleton()
            self.collectionView.isScrollEnabled = true
            self.isLoading = false
            
        }
    }
}

extension ProductCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isLoading {
            return 6
        }
        return productViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var viewModel = ProductViewModel("        ", weight: "     ", price: "     ")
        
        if !isLoading {
            viewModel = productViewModels[indexPath.item]
        }
        
        if let productCell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.reuseIdentifier, for: indexPath) as? ProductCell {
            productCell.configure(viewModel, isExcluded: excludedViewModels.contains(viewModel))
            return productCell
        }
        
        return UICollectionViewCell()
    }
}

extension ProductCollectionViewController: UICollectionViewDelegate, UIPopoverPresentationControllerDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productPageVC = ProductPageViewController()
        
        productPageVC.configure(with: productViewModels[indexPath.item], isExcluded: excludedViewModels.contains(productViewModels[indexPath.item]))
        
        self.navigationController?.pushViewController(productPageVC, animated: true)
    }
}

extension ProductCollectionViewController: UICollectionViewDelegateFlowLayout {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = collectionView.contentSize.height
        let offsetY = scrollView.contentOffset.y
        let visibleHeight = scrollView.frame.height
        if (isLoading) { return }
        
        if 1.3 * offsetY > contentHeight - visibleHeight && currentPage < totalPages - 1 {
            // Load next page
            currentPage += 1
            fetchProducts(searchString: searchBar.text)
        }
    }
}

extension ProductCollectionViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        guard let searchString = searchBar.text else { return }
        currentPage = 1
        
//        fetchProducts(searchString: searchString)
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("Cancel button clicked")
        searchBar.text = ""
        currentPage = 1
        searchBar.resignFirstResponder()
        fetchProducts(searchString: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            searchBarCancelButtonClicked(searchBar)
            return
        }
        currentPage = 1

        fetchProducts(searchString: searchText)
    }
}
