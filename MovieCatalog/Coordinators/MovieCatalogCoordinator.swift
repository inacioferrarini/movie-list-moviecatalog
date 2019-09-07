import Common

public class MovieCatalogCoordinator: Coordinator {
    
    private var tabBar: UITabBarController
    
    public init(tabBar: UITabBarController) {
        self.tabBar = tabBar
    }
    
    public func start() {
        print("starting MovieCatalogCoordinator ... ")
    }
    
}
