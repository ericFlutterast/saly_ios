import UIKit

//TODO: ошибка констрейнтов хз поемуц надо разобраться
final class AppCustomTabController: UITabBarController, UITabBarControllerDelegate {
    private let customTabBar = CustomTabVarView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.isHidden = true
        setupControllers()
        
        view.backgroundColor = .neutralPrimaryS2
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customTabBar)
        
        NSLayoutConstraint.activate([
            customTabBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            customTabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
        
        customTabBar.onValueChanged = { [weak self] index in
            self?.selectedIndex = index
        }
    }
    
    private func setupControllers() {
        let homeVC = HomeScreenController()
        let favoritesVC = FavoritesScreenController()
        
        let homeTab = UINavigationController(rootViewController: homeVC)
        let favoritesTab = UINavigationController(rootViewController: favoritesVC)
    
        viewControllers = [homeTab, favoritesTab]
    }
}

private class CustomTabVarView: UIView{
    var onValueChanged: ((Int) -> Void)?
    
    private let stackView = UIStackView()
    private var indicatorView = UIView()
    
    private var tabBarButtons: [UIButton] = []
    private var currentIndex: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(frame:) has not been implemented" )
    }
    
    private func setupUI() {
        backgroundColor = .neutralPrimaryS1
        layer.cornerRadius = 36
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.neutralSecondaryS3.cgColor
        
        indicatorView.backgroundColor = .statusOkS1
        indicatorView.layer.cornerRadius = 28
        addSubview(indicatorView)
        
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
        
        let titles = ["house.fill", "heart.fill"]
        for (i, title) in titles.enumerated() {
            let button = UIButton(type: .custom)
            button.setImage(UIImage(systemName: title), for: .normal)
            button.setImage(UIImage(systemName: title), for: .highlighted)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.tintColor = .neutralSecondaryS4
            button.heightAnchor.constraint(equalToConstant: 56).isActive = true
            button.widthAnchor.constraint(equalToConstant: 56).isActive = true
            button.tag = i
            button.addTarget(self, action: #selector(handleTabButtonTap), for: .touchUpInside)
            tabBarButtons.append(button)
            stackView.addArrangedSubview(button)
        }
        
        layoutIfNeeded()
        mooveIndicator(to: 0, animated: false)
    }
    
    @objc func handleTabButtonTap(_ sender: UIButton) {
        if sender.tag == currentIndex { return }
        currentIndex = sender.tag
        for button in tabBarButtons {
            button.tintColor = .neutralSecondaryS4
        }
        mooveIndicator(to: sender.tag, animated: true)
        onValueChanged?(sender.tag)
    }
    
    private func mooveIndicator(to index: Int, animated: Bool) {
        guard index < tabBarButtons.count else {return}
        
        let button = tabBarButtons[index]
        button.tintColor = .neutralPrimaryS1
        let size = button.bounds.size.width
        if animated {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, animations: {
                self.indicatorView.frame = CGRect(x: button.frame.origin.x + 8, y: button.frame.origin.y + 8, width: size, height: size)
            })
        } else {
            indicatorView.frame = CGRect(x: button.frame.origin.x + 8, y: button.frame.origin.y + 8, width: size, height: size)
        }
    }
}
