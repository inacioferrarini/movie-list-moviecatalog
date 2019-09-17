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
        guard let vc = catalogViewController else { return UIViewController() }
        if let tabBarItem = self.tabBarItem {
            vc.tabBarItem = tabBarItem
        }
        return UINavigationController(rootViewController: vc)
    }()
    
    private lazy var catalogViewController: MovieCatalogViewController? = {
        let vc = MovieCatalogViewController.instantiate(from: "MovieCatalog")
        vc?.title = tabBarItemTitle   // HERE   -- Movie To ViewController
        vc?.delegate = self
        return vc
    }()
    
    private lazy var detailsViewController: MovieDetailsViewController? = {
        let vc = MovieDetailsViewController.instantiate(from: "MovieCatalog")
        vc?.title = "DETAILS"   // HERE   -- Movie To ViewController
        vc?.delegate = self
        return vc
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
        if let nav = self.viewController as? UINavigationController,
            let vc = detailsViewController {
            vc.movie = movie
            nav.pushViewController(vc, animated: true)
        }
    }
    
}

extension MovieCatalogCoordinator: Internationalizable {

    var tabBarItemTitle: String {
        return string("tabBarItemTitle", languageCode: "en-US")
    }

}

extension MovieCatalogCoordinator: MovieCatalogViewControllerDelegate {

    func movieCatalogViewController(_ movieCatalogViewController: MovieCatalogViewController, didSelected movie: Movie) {
        self.showMovieDetails(movie)
    }

}

extension MovieCatalogCoordinator: MovieDetailsViewControllerDelegate {
    
}
