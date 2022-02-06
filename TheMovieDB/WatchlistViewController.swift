
import UIKit
import SQLite3

class WatchlistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var getWatchListId : [String] = []
    var getWatchListBackdropPath : [String] = []
    var getWatchListTitle : [String] = []
    var getWatchListOverview : [String] = []
    var getWatchListImg : [String] = []
    var getWatchListReleaseDate : [String] = []
    var getWatchListVoteAverage : [Double] = []
    
    var db: OpaquePointer? = nil
    
    var id : String = ""
    var backdrop_path : String = ""
    var original_title : String = ""
    var overview : String = ""
    var poster_path : String = ""
    var release_date : String = ""
    var vote_average : Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("Movies.sqlite")
                
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        
        tableView.delegate = self
        tableView.dataSource = self
       
    }
    
    //TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (getWatchListTitle.count != 0) {
            return getWatchListTitle.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Detail Screen Action
        if getWatchListTitle.count != 0 {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "detailscreen") as? DetailViewController
            vc?.id = Int(getWatchListId[indexPath.row])!
            vc?.originalTitle = getWatchListTitle[indexPath.row]
            vc?.overview = getWatchListOverview[indexPath.row]
            if getWatchListBackdropPath.count == nil {
                vc?.backdropPath = "imagenotfound"
            } else {
                vc?.backdropPath = getWatchListBackdropPath[indexPath.row]
            }
            vc?.poster_path = getWatchListImg[indexPath.row]
            vc?.release_date = getWatchListReleaseDate[indexPath.row]
            vc?.vote_average = getWatchListVoteAverage[indexPath.row]
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "watchlistcell" , for: indexPath as IndexPath) as! WatchListTableTableViewCell
        let url = URL(string: "https://image.tmdb.org/t/p/w200\(getWatchListImg[indexPath.row])")!
        if let data = try? Data(contentsOf: url) {
            cell.imageViewCell.image = UIImage(data: data)
        }
        cell.titleCell.text = getWatchListTitle[indexPath.row]
        
        return cell
    }
    
    //Navigation and Status Bar Color
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getWatchListImg = []
        getWatchListTitle = []
        getWatchListId = []
        getWatchListBackdropPath = []
        getWatchListOverview = []
        getWatchListReleaseDate = []
        getWatchListVoteAverage = []
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.standardAppearance = appearance;
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        
        let statusBar = UIView()
        statusBar.frame = UIApplication.shared.statusBarFrame
        statusBar.backgroundColor = UIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        UIApplication.shared.keyWindow?.addSubview(statusBar)
        
        self.tabBarController?.tabBar.isHidden = false
        
        let queryString = "SELECT * FROM Watchlist"
                
        var stmt:OpaquePointer?
                
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt) == SQLITE_ROW){
            id = String(cString: sqlite3_column_text(stmt, 0))
            print(id)
            backdrop_path = String(cString: sqlite3_column_text(stmt, 1))
            original_title = String(cString: sqlite3_column_text(stmt, 2))
            overview = String(cString: sqlite3_column_text(stmt, 3))
            poster_path = String(cString: sqlite3_column_text(stmt, 4))
            release_date = String(cString: sqlite3_column_text(stmt, 5))
            vote_average = sqlite3_column_double(stmt, 6)
            
            getWatchListId.append(id)
            getWatchListBackdropPath.append(backdrop_path)
            getWatchListTitle.append(original_title)
            getWatchListOverview.append(overview)
            getWatchListImg.append(poster_path)
            getWatchListReleaseDate.append(release_date)
            getWatchListVoteAverage.append(vote_average)
        }
        
        self.tableView.reloadData()
        
    }
    
    //Back Button Action
    @IBAction func backFromWatchlist(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
