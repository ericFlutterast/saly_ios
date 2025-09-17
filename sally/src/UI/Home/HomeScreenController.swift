import UIKit

typealias DataSource = UICollectionViewDiffableDataSource<Section, Discount>
typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Discount>


enum Section{
    case main
}

final class HomeScreenController: UIViewController {
    private var collectionView: UICollectionView!
    private var dataSource: DataSource!
    private var discounts: [Discount] = (0..<10).map { _ in
        return Discount(id: UUID().uuidString, description: "jjahsfjdkgljkahshdkgkasdkg", companyName: "Denta lab", discoutPercent: 50)
    }
    
    private var headerHeightConstraint: NSLayoutConstraint!
    private let maxHeaderHeight: CGFloat = 80
    private let minHeaderHeight: CGFloat = 0
    private var prevScrollOffset: CGFloat = 0
    
    lazy private var personalHeader = {
        let header = PersonalHeaderView()
        header.translatesAutoresizingMaskIntoConstraints = false
        header.greeting.text = "Hello people"
        header.holiday.text = "Happy holidays!"
        return header
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .neutralPrimaryS2
        configurateDiscountsCollectionView()
        configurateDataSourece()
        if let navigationController = navigationController{
            navigationController.navigationBar.isHidden = true
        }
    }
    
    private func configurateDiscountsCollectionView() {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.itemSize = CGSize(width: view.bounds.width - 24, height: view.bounds.width * 1.2)
        collectionViewLayout.headerReferenceSize = CGSize(width: view.bounds.width, height: 34)
        collectionViewLayout.minimumLineSpacing = 12
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.contentInset = UIEdgeInsets(top: 33, left: 0, bottom: view.bounds.height * 0.12, right: 0)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .neutralPrimaryS2
        collectionView.delegate = self
        collectionView.register(DiscountCell.self, forCellWithReuseIdentifier: "DiscountCell")
        collectionView.register(DiscountsCountsHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DiscountsCountsHeaderView.id)
    
        view.addSubview(personalHeader)
        view.addSubview(collectionView)
        
        headerHeightConstraint = personalHeader.heightAnchor.constraint(equalToConstant: minHeaderHeight)
        NSLayoutConstraint.activate([
            personalHeader.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            personalHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            personalHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            headerHeightConstraint,
            
            collectionView.topAnchor.constraint(equalTo: personalHeader.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func configurateDataSourece() {
        dataSource = DataSource(collectionView: collectionView) {[weak self] (collectionView, indexPath, discount) -> UICollectionViewCell? in
            guard let self = self else {return nil}
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiscountCell", for: indexPath) as! DiscountCell
            let discount = self.discounts[indexPath.row]
            cell.descriptionText = discount.description
            cell.imageURL = URL(string: imagePath)
            cell.companyImageURL = URL(string: imagePath)
            cell.companyName = discount.companyName
            cell.isLiked = discount.isLiked
            cell.onLikedTap = { value in self.likeTapHandler(forIndex: indexPath.row, isLiked: value)}
            return cell
        }
        
        dataSource.supplementaryViewProvider = {(collectionView, kind, indexPath) -> UICollectionReusableView? in
            guard kind == UICollectionView.elementKindSectionHeader else {
                return UICollectionReusableView()
            }
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DiscountsCountsHeaderView.id, for: indexPath) as! DiscountsCountsHeaderView
            headerView.title = "Found \(self.discounts.count) discounts"
            return headerView
        }
        
         var snapshot = Snapshot()
         snapshot.appendSections([.main])
         snapshot.appendItems(discounts, toSection: .main)
         dataSource.applySnapshotUsingReloadData(snapshot)
    }
    
    private func likeTapHandler(forIndex index: Int, isLiked: Bool) {
        discounts[index].isLiked = isLiked
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(discounts)
        dataSource.apply(snapshot)
    }
}

//MARK: UICollectionDelegate
extension HomeScreenController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let newHeight = headerHeightConstraint.constant - offsetY

        if newHeight > maxHeaderHeight {
            headerHeightConstraint.constant = maxHeaderHeight
        } else if newHeight < minHeaderHeight {
            headerHeightConstraint.constant = minHeaderHeight
        } else {
            headerHeightConstraint.constant = newHeight
            scrollView.contentOffset.y = 0
        }
        
        let alpha = max(0, newHeight / maxHeaderHeight)
        personalHeader.alpha = alpha
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = DetailDiscountScreenControllerViewController()
        present(controller, animated: true)
    }
}

//MARK: Discount cell
final class DiscountCell: UICollectionViewCell {
    var onLikedTap: ((Bool) -> Void)?
    
    private lazy var conpanyBannerView = { banner in
        banner.onFavoriteTap = { [weak self] value in self?.onLikedTap?(value)}
        return banner
    } (DiscountCompanyBannerView())
    
    private lazy var textSubstrateView = { view in
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .neutralPrimaryS2
        view.layer.cornerRadius = 16
        return view
    }(UIView())
    
    private lazy var imageView = {
        $0.isUserInteractionEnabled = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    
    private lazy var descriptionTitleView = { label in
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .neutralSecondaryS1
        label.numberOfLines = 2
        return label
    } (UILabel())
    
    var isLiked: Bool = false {
        willSet {
            conpanyBannerView.isLiked = newValue
        }
    }
    
    var descriptionText: String? {
        willSet {
            descriptionTitleView.text = newValue
        }
    }
    
    var imageURL: URL? {
        willSet{
            guard let imageURL = newValue else {return}
            imageView.loadImage(from: imageURL)
        }
    }
    
    var companyImageURL: URL? {
        willSet {
            conpanyBannerView.companyImageURL = imageURL
        }
    }
    
    var companyName: String? {
        willSet {
            conpanyBannerView.companyName = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configurateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configurateUI() {
        contentView.backgroundColor = .neutralPrimaryS1
        contentView.layer.cornerRadius = 24
        
        contentView.addSubview(textSubstrateView)
        imageView.addSubview(conpanyBannerView)
        contentView.addSubview(imageView)
        contentView.addSubview(descriptionTitleView)
        
        NSLayoutConstraint.activate([
            textSubstrateView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            textSubstrateView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            textSubstrateView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            textSubstrateView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            imageView.leadingAnchor.constraint(equalTo: textSubstrateView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: textSubstrateView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: textSubstrateView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: descriptionTitleView.topAnchor, constant: -24),
            
            descriptionTitleView.leadingAnchor.constraint(equalTo: textSubstrateView.leadingAnchor, constant: 16),
            descriptionTitleView.trailingAnchor.constraint(equalTo: textSubstrateView.trailingAnchor, constant: -16),
            descriptionTitleView.bottomAnchor.constraint(equalTo: textSubstrateView.bottomAnchor, constant: -24),
            
            conpanyBannerView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 16),
            conpanyBannerView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -16),
            conpanyBannerView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -16),
        ])
    }
}
