import Common

protocol MovieDetailsViewControllerDelegate: AnyObject {
    
}

class MovieDetailsViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak private(set) var movieDetailsView: MovieDetailsView!
    
    // MARK: - Properties
    
    weak var delegate: MovieDetailsViewControllerDelegate?

    var movie: Movie?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        movieDetailsView.movie = self.movie
    }
        
    private func setup() {
        self.movieDetailsView.delegate = self
    }
    
}

extension MovieDetailsViewController: Storyboarded {}

extension MovieDetailsViewController: MovieDetailsViewDelegate {

    func movieDetailsView(_ moviewDetailsView: MovieDetailsView, favorite: Bool, for movie: Movie) {
        print("Favorite \(favorite) changed for: \(movie)")
    }

}
