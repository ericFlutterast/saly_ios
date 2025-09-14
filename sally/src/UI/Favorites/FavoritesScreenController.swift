import Foundation
import UIKit

//TEMP:
let imagePath = "https://hips.hearstapps.com/hmg-prod/images/long-boat-docked-on-beach-in-krabi-thailand-summers-royalty-free-image-1622044679.jpg?crop=0.668xw:1.00xh;0.0657xw,0&resize=1120:*"

private enum CellIndetifier: String {
    case favoriteCell
}

final class FavoritesScreenController : UIViewController {
    private var dataSource: UICollectionViewDataSource = FavoritesUIDataSourse()
    
    init () {
        print("Initalizing controller")
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavVar()
        view.backgroundColor = .neutralPrimaryS2
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.itemSize = CGSize(width: view.bounds.width - 24, height: view.bounds.width * 1.2)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .neutralPrimaryS2
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = dataSource
        collectionView.register(FavoriteCell.self, forCellWithReuseIdentifier: CellIndetifier.favoriteCell.rawValue)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func setupNavVar() {
        guard let navigationController = navigationController else {return}
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.isTranslucent = true
        navigationController.navigationBar.sizeToFit()
        navigationController.navigationBar.barTintColor = .neutralPrimaryS2
        navigationController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.neutralSecondaryS1]
        navigationController.navigationBar.largeTitleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 25, weight: .semibold),
            .foregroundColor: UIColor.neutralSecondaryS1,
        ]
        self.title = "Избранное"
    }
}

extension FavoritesScreenController: UICollectionViewDelegate {}

final class FavoritesUIDataSourse: NSObject, UICollectionViewDataSource {
    private let favoritesData: [Favorite] = Array(repeating: Favorite(
        id: UUID().uuidString,
        description: "asdf asdf asdf asdfffds asdfasdf, lorem ipsul od dsfsdf cdsfsdf",
        companyName: "Denta lab",
        discoutPercent: 20), count: 15)
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        favoritesData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIndetifier.favoriteCell.rawValue, for: indexPath) as! FavoriteCell
        let cellData = favoritesData[indexPath.item]
        cell.setContent(text: cellData.description, companyName: cellData.companyName, imageURL: URL(string: imagePath)!)
        return cell
    }
    
}

private final class FavoriteCell: UICollectionViewCell {
    lazy private var companyBanner = {
        let companyBanner = CompanyBannerView()
        return companyBanner
    }()
    
    lazy private var title = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy private var image = {
        let image = UIImageView()
        image.loadImage(from: URL(string: imagePath)!)
        image.layer.cornerRadius = 16
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .neutralPrimaryS1
        contentView.layer.cornerRadius = 24
        addCellContent()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addCellContent() {
        let title = self.title
        let image = self.image
        
        image.addSubview(companyBanner)
        contentView.addSubview(image)
        contentView.addSubview(title)
        
        NSLayoutConstraint.activate([
            companyBanner.leadingAnchor.constraint(equalTo: image.leadingAnchor, constant: 16),
            companyBanner.trailingAnchor.constraint(equalTo: image.trailingAnchor, constant: -16),
            companyBanner.bottomAnchor.constraint(equalTo: image.bottomAnchor, constant: -16),
            
            image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            image.bottomAnchor.constraint(equalTo: title.topAnchor, constant: -24),
            
            title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }
    
    func setContent(text: String, companyName: String, imageURL: URL) {
        title.text = text
        companyBanner.companyName = companyName
        companyBanner.imageURL = imageURL
    }
}

private final class CompanyBannerView: UIView {
    lazy private var imageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 30
        image.clipsToBounds = true
        image.heightAnchor.constraint(equalToConstant: 59).isActive = true
        image.widthAnchor.constraint(equalToConstant: 59).isActive = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy private var labelView = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var companyName: String? {
        willSet {
            updateLabel(text: newValue)
        }
    }
    
    var imageURL: URL? {
        willSet {
            updateImage(url: newValue)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
        self.layer.cornerRadius = 12
    }
    
    private func setupContent() {
        let contentRow = UIStackView()
        contentRow.axis = .horizontal
        contentRow.spacing = 12
        contentRow.translatesAutoresizingMaskIntoConstraints = false
        contentRow.addArrangedSubview(imageView)
        contentRow.addArrangedSubview(labelView)
        
        self.addSubview(contentRow)
        
        NSLayoutConstraint.activate([
            contentRow.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            contentRow.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            contentRow.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            contentRow.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12)
        ])
    }
    
    private func updateLabel(text: String?) {
        labelView.text = text
    }
    
    private func updateImage(url: URL?) {
        guard let url = url else { fatalError("Image url can not be nil") }
        imageView.loadImage(from: url)
    }
}
