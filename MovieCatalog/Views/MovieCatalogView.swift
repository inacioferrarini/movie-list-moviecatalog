import UIKit
import Common

class MovieCatalogView: UIView {

    // MARK: - Outlets

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!

    var dataProvider = ArrayDataProvider<Movie>(section: [])
    var dataSource: CollectionViewArrayDataSource<MovieCollectionViewCell, Movie>?
    
    // MARK: - Properties

    var searchResult: SearchResult? {
        didSet {
            if let searchResult = searchResult {
                dataProvider.elements = [searchResult.results]
                dataSource?.refresh()
            }
            print("setting ... \(searchResult)")
        }
    }

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
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let nib = UINib(nibName: MovieCollectionViewCell.simpleClassName(), bundle: Bundle(for: type(of: self)))
        collectionView.register(nib, forCellWithReuseIdentifier: MovieCollectionViewCell.simpleClassName())
        let dataSource = CollectionViewArrayDataSource<MovieCollectionViewCell, Movie>(for: collectionView, with: dataProvider)
        collectionView.dataSource = dataSource
        self.dataSource = dataSource
    }

}
