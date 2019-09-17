import Common

class MovieCatalogViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private(set) weak var movieCatalogView: MovieCatalogView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        
        let api = TheMovieDatabaseApi.Movies()
        api.fetchPopularMovies(delegate: self)
        
    }
    
    private func setup() {
        self.movieCatalogView.delegate = self
    }
    
}

extension MovieCatalogViewController: Storyboarded {}

extension MovieCatalogViewController: FetchMoviesDelegate {
    
    func handleSuccess(searchResult: SearchResult?, for request: TheMovieDatabaseApi.Request) {
        movieCatalogView.searchResult = searchResult
    }
    
    func handleError(error: Error, for request: TheMovieDatabaseApi.Request) {
        print("Request \(request), Error -> \(error)")
    }
    
}

extension MovieCatalogViewController: MovieCatalogViewDelegate {

    func moviewCatalogView(_ moviewCatalogView: MovieCatalogView, didSelected movie: Movie) {
        print("--> selected movie: \(movie)")
    }

}
