import UIKit
import Common

protocol MovieDetailsViewDelegate: AnyObject {
    
    func movieDetailsView(_ moviewDetailsView: MovieDetailsView, didFavorite movie: Movie)
    
}

class MovieDetailsView: UIView {

    // MARK: - Outlets
    
    @IBOutlet private(set) weak var contentView: UIView!
    
    // MARK: - Private Properties
    
    // MARK: - Properties
    
    weak var delegate: MovieDetailsViewDelegate?
    
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
    }
    
    
    
}
