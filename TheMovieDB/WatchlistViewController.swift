
import UIKit

class WatchlistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var getWatchlistTitle : [String] = ["watchlistmovie1","watchlistmovie2","watchlistmovie3","watchlistmovie4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        
        tableView.delegate = self
        tableView.dataSource = self
       
    }
    
    //TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (getWatchlistTitle != nil) {
            return getWatchlistTitle.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "watchlistcell" , for: indexPath as IndexPath) as! WatchListTableTableViewCell
        cell.imageViewCell.image = UIImage(named: "filmicon")
        cell.titleCell.text = getWatchlistTitle[indexPath.row]
        
        return cell
    }
    
    //Navigation and Status Bar Color
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        
    }
    
    //Back Button Action
    @IBAction func backFromWatchlist(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
