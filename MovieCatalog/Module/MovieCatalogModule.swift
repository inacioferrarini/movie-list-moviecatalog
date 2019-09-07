import Foundation
import Common

public class MovieCatalogModule: Module {

    private var tabBar: UITabBarController
    
    public lazy var coordinator: Coordinator = {
        return MovieCatalogCoordinator(tabBar: self.tabBar)
    }()
    
    public init(tabBar: UITabBarController) {
        self.tabBar = tabBar
    }
    
}
