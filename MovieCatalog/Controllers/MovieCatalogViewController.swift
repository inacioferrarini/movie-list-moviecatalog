import Common

class MovieCatalogViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let api = TheMovieDatabaseApi.Movies()
        api.fetchPopularMovies(delegate: self)
    }
    
}

extension MovieCatalogViewController: Storyboarded {}

extension MovieCatalogViewController: FetchMoviesDelegate {
    
    func handleSuccess(searchResult: SearchResult?, for request: TheMovieDatabaseApi.Request) {
        print("Request \(request), Success -> \(searchResult)")
    }
    
    func handleError(error: Error, for request: TheMovieDatabaseApi.Request) {
        print("Request \(request), Error -> \(error)")
    }
    
}
