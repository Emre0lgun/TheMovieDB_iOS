
import UIKit
import SQLite3

class DetailViewController: UIViewController {
    
    var id : Int = 0
    var originalTitle : String = ""
    var overview : String = ""
    var backdropPath : String = ""
    var poster_path : String = ""
    var release_date : String = ""
    var vote_average : Double = 0.0

    var idFavoritiesArray : [Int] = []
    var idWatchListArray : [Int] = []
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var watchlistBtn: UIButton!
    @IBOutlet weak var favoritiesBtn: UIButton!
    let defaultsWatchlist = UserDefaults.standard
    let defaultsFavorities = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        
        if backdropPath == "imagenotfound" {
            imageView.image = UIImage(named: "imagenotfound")
        } else {
            let url = URL(string: "https://image.tmdb.org/t/p/w400\(backdropPath)")!
            if let data = try? Data(contentsOf: url) {
                imageView.image = UIImage(data: data)
            }
        }
        idFavoritiesArray = []
        idWatchListArray = []
        //Save movie id data for Favorities
        if (defaultsFavorities.array(forKey: "favoritiesId") != nil) {
            idFavoritiesArray = defaultsFavorities.array(forKey: "favoritiesId")  as? [Int] ?? [Int]()
        }
        //Save movie id data for Watchlist
        if (defaultsWatchlist.array(forKey: "idWatchListArray") != nil) {
            idWatchListArray = defaultsWatchlist.array(forKey: "idWatchListArray")  as? [Int] ?? [Int]()
        }
        
        //if data have, Fill movie id data to Favorities
        if (idFavoritiesArray.contains(id)) {
            if let image = UIImage(named: "activeheart.png") {
                favoritiesBtn.setImage(image, for: .normal)
            }
        }
        
        //if data have, Fill movie id data to Watchlist
        if idWatchListArray.contains(id) {
            if let image = UIImage(named: "activewatchlist.png") {
                watchlistBtn.setImage(image, for: .normal)
            }
        }
        
        self.title = originalTitle
        textView.text = "\t\(overview)"

    }
    
    //Watchlist Button Action (Save or Remove movie id data)
    @IBAction func detailWatchList(_ sender: Any) {
        if idWatchListArray.contains(id) {
            idWatchListArray.remove(at: idWatchListArray.firstIndex(where: {$0 == id})!)
            defaultsWatchlist.removeObject(forKey: "idWatchListArray")
            defaultsWatchlist.set(idWatchListArray, forKey: "idWatchListArray")
            if let image = UIImage(named: "watchlist.png") {
                watchlistBtn.setImage(image, for: .normal)
            }
        } else {
            if let image = UIImage(named: "activewatchlist.png") {
                watchlistBtn.setImage(image, for: .normal)
            }
            idWatchListArray.append(id)
            defaultsWatchlist.removeObject(forKey: "idWatchListArray")
            defaultsWatchlist.set(idWatchListArray, forKey: "idWatchListArray")
        }
    }
    
    //Favorities Button Action (Save or Remove movie id data)
    @IBAction func detailFavorities(_ sender: Any) {
        if idFavoritiesArray.contains(where: {$0 == id}) {
            idFavoritiesArray.remove(at: idFavoritiesArray.firstIndex(where: {$0 == id})!)
            defaultsFavorities.removeObject(forKey: "favoritiesId")
            defaultsFavorities.set(idFavoritiesArray, forKey: "favoritiesId")
            if let image = UIImage(named: "heart.png") {
                favoritiesBtn.setImage(image, for: .normal)
            }
        } else {
            if let image = UIImage(named: "activeheart.png") {
                favoritiesBtn.setImage(image, for: .normal)
            }
            idFavoritiesArray.append(id)
            defaultsFavorities.removeObject(forKey: "favoritiesId")
            defaultsFavorities.set(idFavoritiesArray, forKey: "favoritiesId")
        }
    }
    
    //Tabbar is hide
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }

}
