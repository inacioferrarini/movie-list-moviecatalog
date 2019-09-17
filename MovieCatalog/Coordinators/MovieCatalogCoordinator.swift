import Common

public class MovieCatalogCoordinator: Coordinator {
    
    // MARK: - Properties
    
    private var tabBar: UITabBarController
    
    // MARK: - Initialization
    
    public init(tabBar: UITabBarController) {
        self.tabBar = tabBar
    }
    
    // MARK: - Lazy Properties
    
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
        vc.delegate = self
        return UINavigationController(rootViewController: vc)
    }()
    
    // MARK: - Public Methods
    
    public func start() {
        var viewControllers = tabBar.viewControllers ?? []
        viewControllers += [self.viewController]
        tabBar.viewControllers = viewControllers
    }

    // MARK: - Coordinator
    
    func showMovieDetails(_ movie: Movie) {
        print("Movie was selected: \(movie)")
    }
    
}

extension MovieCatalogCoordinator: Internationalizable {

    var tabBarItemTitle: String {
        return string("tabBarItemTitle", languageCode: "en-US")
    }

}

extension  MovieCatalogCoordinator: MovieCatalogViewControllerDelegate {

    func movieCatalogViewController(_ movieCatalogViewController: MovieCatalogViewController, didSelected movie: Movie) {
        self.showMovieDetails(movie)
    }

}
