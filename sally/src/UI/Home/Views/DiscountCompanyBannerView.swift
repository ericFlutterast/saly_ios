import UIKit

final class DiscountCompanyBannerView: UIView {
    var onFavoriteTap: ((Bool) -> Void)?
    
    private lazy var rowView = { stack in
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 12
        stack.alignment = .center
        return stack
    } (UIStackView())
    
    private lazy var imageView = { image in
        image.translatesAutoresizingMaskIntoConstraints = false
        image.heightAnchor.constraint(equalToConstant: 60).isActive = true
        image.widthAnchor.constraint(equalToConstant: 60).isActive = true
        image.layer.cornerRadius = 30
        image.clipsToBounds = true
        return image
    }(UIImageView())
    
    private lazy var companyNameView = { label in
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 1
        label.textColor = .neutralSecondaryS1
        return label
    } (UILabel())
    
    private lazy var favoriteButtonView = { button in
        button.onTap = { [weak self]  value in self?.onFavoriteTap?(value)}
        return button
    }(FavoriteButtonView())
    
    var companyImageURL: URL? {
        willSet {
            guard let imageURL = newValue else {return}
            imageView.loadImage(from: imageURL)
        }
    }
    
    var companyName: String? {
        willSet {
            companyNameView.text = newValue
        }
    }
    
    var isLiked: Bool = false {
        willSet {
            favoriteButtonView.isSelected = newValue
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configurateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError( "init(coder:) has not been implemented" )
    }
    
    private func configurateUI() {
        backgroundColor = .neutralPrimaryS1
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 12
        let rowChildren = [imageView, companyNameView, favoriteButtonView]
        addSubview(rowView)
        
        for child in rowChildren {
            rowView.addArrangedSubview(child)
        }
        
        NSLayoutConstraint.activate([
            rowView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            rowView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            rowView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            rowView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}

final class FavoriteButtonView: UIView {
    var onTap: ((Bool) -> Void)?
    var isSelected: Bool = false {
        didSet{
            setImage()
        }
    }
    
    private lazy var imageView = { image in
        image.tintColor = .systemRed
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }(UIImageView())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configurateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError( "init(coder:) has not been implemented" )
    }
    
    private func configurateUI() {
        isUserInteractionEnabled = true
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 60).isActive = true
        widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        tapRecognizer.cancelsTouchesInView = false
        addGestureRecognizer(tapRecognizer)
        configurateContent()
      
    }
    
    private func configurateContent() {
        setImage()
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
        ])
    }
    
    private func setImage() {
        imageView.image = isSelected ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        imageView.addSymbolEffect(.bounce.down)
    }
    
    @objc private func tapHandler(_ sender: UITapGestureRecognizer) {
        setImage()
        onTap?(!isSelected)
    }
}
