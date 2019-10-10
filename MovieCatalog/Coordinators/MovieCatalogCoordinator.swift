//    The MIT License (MIT)
//
//    Copyright (c) 2019 Inácio Ferrarini
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//    SOFTWARE.
//

import Common
import Flow
import Ness

public class MovieCatalogCoordinator: Coordinator, AppContextAware, LanguageAware {

    // MARK: - Private Properties

    private var tabBar: UITabBarController
    public var appContext: AppContext?

    // MARK: - Initialization

    public init(tabBar: UITabBarController, appContext: AppContext) {
        self.tabBar = tabBar
        self.appContext = appContext
    }

    // MARK: - Lazy Properties

    // MARK: - TabBar Management

    lazy var tabBarItem: UITabBarItem? = {
        return UITabBarItem(title: tabBarItemTitle,
                            image: Assets.Icons.Modules.catalog,
                            selectedImage: nil)
    }()

    // MARK: - Coordinated ViewControllers

    public lazy var viewController: UIViewController = {
        guard let vc = catalogViewController else { return UIViewController() }
        if let tabBarItem = self.tabBarItem {
            vc.tabBarItem = tabBarItem
        }
        return UINavigationController(rootViewController: vc)
    }()

    private lazy var catalogViewController: MovieCatalogViewController? = {
        let vc = MovieCatalogViewController.instantiate(from: "MovieCatalog")
        vc?.delegate = self
        vc?.appContext = self.appContext
        return vc
    }()

    private lazy var detailsViewController: MovieDetailsViewController? = {
        let vc = MovieDetailsViewController.instantiate(from: "MovieCatalog")
        vc?.delegate = self
        vc?.appContext = self.appContext
        return vc
    }()

    // MARK: - Public Methods

    public func start() {
        var viewControllers = tabBar.viewControllers ?? []
        viewControllers += [self.viewController]
        tabBar.viewControllers = viewControllers
    }

    public func finish() {
    }

    // MARK: - Coordinator

    func showMovieDetails(_ movie: Movie) {
        if let nav = self.viewController as? UINavigationController,
            let vc = detailsViewController {
            vc.movie = movie
            nav.pushViewController(vc, animated: true)
        }
    }

}

extension MovieCatalogCoordinator: Internationalizable {

    var tabBarItemTitle: String {
        return s("tabBarItemTitle")
    }

}

extension MovieCatalogCoordinator: MovieCatalogViewControllerDelegate {

    func movieCatalogViewController(_ movieCatalogViewController: MovieCatalogViewController, didSelected movie: Movie) {
        var movie = movie
        movie.genreNames = updateMovieGenreNames(movie: movie)
        self.showMovieDetails(movie)
    }

    private func updateMovieGenreNames(movie: Movie, `default`: String = "") -> String {
        guard let genreIds = movie.genreIds else { return `default` }
        guard let genres = appContext?.genreList else { return `default` }
        return genres.names(for: genreIds).joined(separator: ", ")
    }

}

extension MovieCatalogCoordinator: MovieDetailsViewControllerDelegate {

}
