

import UIKit

class SearchTableViewController: UITableViewController, UISearchBarDelegate {
    
    var movies : [String] = ["movie1", "movie2", "movie3", "movie4"]
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        tableView.keyboardDismissMode = .onDrag
        searchBar.delegate = self
    }

    //TableView
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
        cell.textLabel?.text = movies[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Detail Screen Action
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "detailscreen") as? DetailViewController
        vc?.id = indexPath.row
        vc?.originalTitle = movies[indexPath.row]
        vc?.overview = movies[indexPath.row]
        vc?.backdropPath = movies[indexPath.row]
        vc?.poster_path = movies[indexPath.row]
        vc?.release_date = movies[indexPath.row]
        vc?.vote_average = 0.0
        self.navigationController?.pushViewController(vc!, animated: true)
    
    }
    
    
    //SearchBar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    //Navigation and Status Bar Color
    override func viewWillAppear(_ animated: Bool) {
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
        super.viewWillAppear(animated)
    }
    
    //Back Button Action
    @IBAction func backFromSearch(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }


}

//Keyboard Dismiss
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
