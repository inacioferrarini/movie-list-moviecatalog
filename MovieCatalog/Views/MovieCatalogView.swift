import UIKit
import Common

protocol MovieCatalogViewDelegate: AnyObject {
    
    func moviewCatalogView(_ moviewCatalogView: MovieCatalogView, didSelected movie: Movie)
    
}

class MovieCatalogView: UIView {

    // MARK: - Outlets

    @IBOutlet private(set) weak var contentView: UIView!
    @IBOutlet private(set) weak var searchBar: UISearchBar!
    @IBOutlet private(set) weak var collectionView: UICollectionView!

    // MARK: - Private Properties
    
    private var dataProvider = ArrayDataProvider<Movie>(section: [])
    private var dataSource: CollectionViewArrayDataSource<MovieCollectionViewCell, Movie>?
    
    // MARK: - Properties

    var searchResult: SearchResult? {
        didSet {
            if let searchResult = searchResult {
                dataProvider.elements = [searchResult.results]
                dataSource?.refresh()
            }
        }
    }

    weak var delegate: MovieCatalogViewDelegate?
    
    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        let bundle = Bundle(for: type(of: self))
        let className = String(describing: type(of: self))
        bundle.loadNibNamed(className, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        setupSearchField()
        setupCollectionView()
    }
    
    private func setupSearchField() {
        searchBar.barTintColor = Assets.Colors.NavigationBar.backgroundColor
        searchBar.setTextBackground(Assets.Colors.NavigationBar.textBackgroundColor)
        searchBar.showsCancelButton = false
        searchBar.showsSearchResultsButton = false
        searchBar.delegate = self
        searchBar.placeholder = "Search"
    }
    
    private func setupCollectionView() {
        let nib = UINib(nibName: MovieCollectionViewCell.simpleClassName(), bundle: Bundle(for: type(of: self)))
        collectionView.register(nib, forCellWithReuseIdentifier: MovieCollectionViewCell.simpleClassName())
        let dataSource = CollectionViewArrayDataSource<MovieCollectionViewCell, Movie>(for: collectionView, with: dataProvider)
        collectionView.dataSource = dataSource
        self.dataSource = dataSource
        collectionView.delegate = self
    }

}

extension MovieCatalogView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movie = dataProvider[indexPath] else { return }
        delegate?.moviewCatalogView(self, didSelected: movie)
    }

}

extension MovieCatalogView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let margin = CGFloat(30)
        let width = (self.collectionView.bounds.width - margin) / 2
        let height = width * 1.25
        return CGSize(width: width, height: height)
    }
    
}

extension MovieCatalogView: UISearchBarDelegate {
    
}
