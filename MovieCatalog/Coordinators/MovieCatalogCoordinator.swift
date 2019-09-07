import Common

public class MovieCatalogCoordinator: Coordinator {
    
    private var tabBar: UITabBarController
    
    public init(tabBar: UITabBarController) {
        self.tabBar = tabBar
    }
    
    lazy var tabBarItem: UITabBarItem? = {
        return UITabBarItem(title: "Movies",
                            image: Assets.Icons.Modules.Catalog,
                            selectedImage: nil)
    }()

    public lazy var viewController: UIViewController = {
        guard let vc = MovieCatalogViewController.instantiate(from: "MovieCatalog") else { return UIViewController() }
        vc.view.backgroundColor = UIColor.blue
        if let tabBarItem = self.tabBarItem {
            vc.tabBarItem = tabBarItem
        }
        return vc
    }()
    
    public func start() {
        var viewControllers = tabBar.viewControllers ?? []
        viewControllers += [self.viewController]
        tabBar.viewControllers = viewControllers
        print("starting MovieCatalogCoordinator ... ")
    }
    
}
