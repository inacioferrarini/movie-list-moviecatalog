import Common

protocol MovieCatalogViewControllerDelegate: AnyObject {
    
    func movieCatalogViewController(_ movieCatalogViewController: MovieCatalogViewController, didSelected movie: Movie)
    
}

class MovieCatalogViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak private(set) var movieCatalogView: MovieCatalogView!
    
    // MARK: - Properties
    
    weak var delegate: MovieCatalogViewControllerDelegate?
    
    // MARK: - Lifecycle
    
    let dispatchGroup = DispatchGroup()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    private func setup() {
        self.movieCatalogView.delegate = self
    }
    
    private func fetchData() {
        movieCatalogView.showLoadingView()
        let api = TheMovieDatabaseApi.Movies()
        DispatchQueue.global().async { [unowned self] in
            self.dispatchGroup.enter()
            api.fetchPopularMovies(delegate: self)
        }
        DispatchQueue.global().async { [unowned self] in
            self.dispatchGroup.enter()
            api.fetchGenres(delegate: self)
        }
        dispatchGroup.notify(queue: DispatchQueue.main) { [unowned self] in
            self.movieCatalogView.hideLoadingView()
        }
    }
    
}

extension MovieCatalogViewController: Storyboarded {}

extension MovieCatalogViewController: FetchMoviesDelegate {

    func handleFetchMovieSuccess(searchResult: SearchResult?, for request: TheMovieDatabaseApi.Request) {
        print("... handleFetchMovieSuccess")
        movieCatalogView.searchResult = searchResult
        dispatchGroup.leave()
    }

    func handleFetchMovieError(error: Error, for request: TheMovieDatabaseApi.Request) {
        print("... handleFetchMovieError")
        print("Request \(request), Error -> \(error)")
        dispatchGroup.leave()
    }

}

extension MovieCatalogViewController: FetchGenresDelegate {

    func handleFetchGenresSuccess(genres: GenreListResult?, for request: TheMovieDatabaseApi.Request) {
        print("... handleFetchGenresSuccess")
        print("---> Genres \(genres)")
        dispatchGroup.leave()
    }

    func handleFetchGenresError(error: Error, for request: TheMovieDatabaseApi.Request) {
        print("... handleFetchGenresError")
        print("Request \(request), Error -> \(error)")
        dispatchGroup.leave()
    }

}

extension MovieCatalogViewController: MovieCatalogViewDelegate {

    func moviewCatalogView(_ moviewCatalogView: MovieCatalogView, didSelected movie: Movie) {
        delegate?.movieCatalogViewController(self, didSelected: movie)
    }

}
