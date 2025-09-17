import UIKit

final class DetailDiscountScreenControllerViewController: UIViewController {
    private let adresses = ["ул. Красная, 256", "ул. Самолетова, 9/11", "ул. Перламутровая, 69",]
    
    private lazy var scrollView = { scroll in
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }(UIScrollView())
    
    private lazy var scrollContentView = { view in
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }(UIView())
   
    private lazy var qrSubstrate = { view in
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.backgroundColor = .neutralPrimaryS1
        return view
    }(UIView())
    
    private lazy var descriptionText = { label in
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .neutralSecondaryS1
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.widthAnchor.constraint(equalToConstant: view.bounds.width - 56).isActive = true
        label.numberOfLines = 0
        return label
    }(UILabel())

    override func viewDidLoad() {
        super.viewDidLoad()
        configurateUI()
    }
    
    private func configurateUI() {
        view.backgroundColor = .neutralPrimaryS2
        view.layer.cornerRadius = 20
        
        guard let grabble = self.sheetPresentationController?.createCustomGrabble() else { return }
        guard let qrCode = generateQrCode(from: "Hello world") else { return }
        
        let uiImageView = UIImageView(image: qrCode)
        uiImageView.translatesAutoresizingMaskIntoConstraints = false
        uiImageView.layer.cornerRadius = 16
        
        qrSubstrate.addSubview(uiImageView)
        NSLayoutConstraint.activate([
            uiImageView.leadingAnchor.constraint(equalTo: qrSubstrate.leadingAnchor, constant: 16),
            uiImageView.trailingAnchor.constraint(equalTo: qrSubstrate.trailingAnchor, constant: -16),
            uiImageView.topAnchor.constraint(equalTo: qrSubstrate.topAnchor, constant: 16),
            uiImageView.bottomAnchor.constraint(equalTo: qrSubstrate.bottomAnchor, constant: -16),
        ])
        
        let descTitle = createTitle()
        descTitle.text = "Description"
        descriptionText.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam auctor quam id massa faucibus dignissim. Nullam eget metus id nisl malesuada condimentum. Nam viverra fringilla erat, ut fermentum nunc feugiat eu."
        
        let addressesTitle = createTitle()
        addressesTitle.text = "Addresses"
        
        view.addSubview(grabble)
        NSLayoutConstraint.activate([
            grabble.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            grabble.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: grabble.bottomAnchor, constant: 10),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            scrollContentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            scrollContentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            scrollContentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            scrollContentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            scrollContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        scrollContentView.addSubview(qrSubstrate)
        scrollContentView.addSubview(descTitle)
        scrollContentView.addSubview(descriptionText)
        scrollContentView.addSubview(addressesTitle)
        
        let addressesColumn = UIStackView()
        addressesColumn.translatesAutoresizingMaskIntoConstraints = false
        addressesColumn.axis = .vertical
        addressesColumn.spacing = 16
        for address in adresses {
            let addressView = UIAddressView(title: address)
            addressView.onTap = {
                print("\(address)")
            }
            addressesColumn.addArrangedSubview(addressView)
        }
        
        scrollContentView.addSubview(addressesColumn)
        
        NSLayoutConstraint.activate([
            qrSubstrate.topAnchor.constraint(equalTo: scrollContentView.topAnchor, constant: 25),
            qrSubstrate.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 16),
            qrSubstrate.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -16),
            
            descTitle.topAnchor.constraint(equalTo: qrSubstrate.bottomAnchor, constant: 40),
            descTitle.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 28),
            descTitle.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -28),
            
            descriptionText.topAnchor.constraint(equalTo: descTitle.bottomAnchor, constant: 28),
            descriptionText.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 28),
            
            addressesTitle.topAnchor.constraint(equalTo: descriptionText.bottomAnchor, constant: 40),
            addressesTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            
            addressesColumn.topAnchor.constraint(equalTo: addressesTitle.bottomAnchor, constant: 28),
            addressesColumn.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 20),
            addressesColumn.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -20),
            addressesColumn.bottomAnchor.constraint(equalTo: scrollContentView.safeAreaLayoutGuide.bottomAnchor, constant: -36),
        ])
    }
    
    private func generateQrCode(from string: String) -> UIImage? {
        guard let qrCodeGenerator = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        guard let data = string.data(using: .utf8) else { return nil }
        
        qrCodeGenerator.setValue(data, forKey: "inputMessage")
        qrCodeGenerator.setValue("M", forKey: "inputCorrectionLevel")
        
        guard let ciImage = qrCodeGenerator.outputImage else { return nil }
        let transform = CGAffineTransform(scaleX: 14, y: 14)
        let scaledImage = ciImage.transformed(by: transform)
            
        return UIImage(ciImage: scaledImage)
    }
    
    private func createTitle() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .neutralSecondaryS1
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }
    
    
}

//MARK: UIAddressView
private final class UIAddressView  : UIView {
    var onTap: (() -> Void)?
    
    private lazy var titleView = { label in
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .neutralSecondaryS1
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 1
        return label
    }(UILabel())
    
    private lazy var icon = { imageView in
        let image = UIImage(systemName: "arrow.right")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = image
        imageView.tintColor = .neutralSecondaryS2
        return imageView
    }(UIImageView())
    
    convenience init(title: String) {
        self.init(frame: .zero)
        self.titleView.text = title
        configurateUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configurateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError( "init(coder:) has not been implemented" )
    }
    
    private func configurateUI() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gestureHandler))
        addGestureRecognizer(gestureRecognizer)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .neutralPrimaryS1
        layer.cornerRadius = 16
        layer.borderWidth = 1
        layer.borderColor = UIColor.neutralSecondaryS3.cgColor
        
        let row = UIStackView(arrangedSubviews: [titleView, icon])
        row.translatesAutoresizingMaskIntoConstraints = false
        row.axis = .horizontal
        row.distribution = .equalSpacing
        
        addSubview(row)
        
        NSLayoutConstraint.activate([
            row.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            row.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            row.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            row.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14),
        ])
    }
    
    @objc private func gestureHandler() {
        onTap?()
    }
}
