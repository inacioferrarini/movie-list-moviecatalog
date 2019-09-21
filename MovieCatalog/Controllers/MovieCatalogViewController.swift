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
        delegate?.movieCatalogViewController(self, didSelected: movie)
    }

}
