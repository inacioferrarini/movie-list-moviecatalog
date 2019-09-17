import Common

protocol MovieDetailsViewControllerDelegate: AnyObject {
    
}

class MovieDetailsViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak private(set) var movieDetailsView: MovieDetailsView!
    
    // MARK: - Properties
    
    var delegate: MovieDetailsViewControllerDelegate?
    var movie: Movie? {
        didSet {
            
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    private func setup() {
        self.movieDetailsView.delegate = self
    }
    
}

extension MovieDetailsViewController: Storyboarded {}

extension MovieDetailsViewController: MovieDetailsViewDelegate {
    
    func movieDetailsView(_ moviewDetailsView: MovieDetailsView, didFavorite movie: Movie) {
        
    }

}
