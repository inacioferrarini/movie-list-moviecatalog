import Common

public class MovieCatalogCoordinator: Coordinator {
    
    private var tabBar: UITabBarController
    
    public init(tabBar: UITabBarController) {
        self.tabBar = tabBar
    }
    
    lazy var tabBarItem: UITabBarItem? = {
        return UITabBarItem(title: tabBarItemTitle,
                            image: Assets.Icons.Modules.catalog,
                            selectedImage: nil)
    }()

    public lazy var viewController: UIViewController = {
        guard let vc = MovieCatalogViewController.instantiate(from: "MovieCatalog") else { return UIViewController() }
        if let tabBarItem = self.tabBarItem {
            vc.tabBarItem = tabBarItem
        }
        vc.title = tabBarItemTitle   // HERE   -- Movie To ViewController
        return UINavigationController(rootViewController: vc)
    }()
    
    public func start() {
        var viewControllers = tabBar.viewControllers ?? []
        viewControllers += [self.viewController]
        tabBar.viewControllers = viewControllers
    }

}

extension MovieCatalogCoordinator: Internationalizable {

    var tabBarItemTitle: String {
        return string("tabBarItemTitle", languageCode: "en-US")
    }

}
