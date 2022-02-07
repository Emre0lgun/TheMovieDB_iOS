

import UIKit

class SearchTableViewController: UITableViewController, UISearchBarDelegate {
    
    var movieResult : [MoviesDetails] = []
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
        if (movieResult.count != 0) {
            return movieResult.count
        } else {
            movieResult = []
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
        cell.textLabel?.text = movieResult[indexPath.row].originalTitle
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Detail Screen Action
        if movieResult.count != 0 {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "detailscreen") as? DetailViewController
            vc?.id = movieResult[indexPath.row].id
            vc?.originalTitle = movieResult[indexPath.row].originalTitle
            vc?.overview = movieResult[indexPath.row].overview.replacingOccurrences(of: "'", with: "''")
            if movieResult[indexPath.row].backdropPath?.count == nil {
                vc?.backdropPath = "imagenotfound"
            } else {
                vc?.backdropPath = movieResult[indexPath.row].backdropPath!
            }
            if movieResult[indexPath.row].posterPath?.count == nil {
                vc?.poster_path = "Not Found!"
            } else {
                vc?.poster_path = movieResult[indexPath.row].posterPath!
            }
            if movieResult[indexPath.row].releaseDate?.count == nil {
                vc?.release_date = "Not Found!"
            } else {
                vc?.release_date = movieResult[indexPath.row].releaseDate!
            }
            vc?.vote_average = movieResult[indexPath.row].voteAverage
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    
    }
    
    func fetch(url:URL) {
        URLSession.shared.request(
            url: url,
            expecting: Movies.self
        ) { [weak self] result in
            switch(result) {
            case .success(let users):
                DispatchQueue.main.async {
                    self!.movieResult = []
                    self!.movieResult = users.results
                    if self!.movieResult.count != 0 {
                        self?.tableView.reloadData()
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //SearchBar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count < 3 {
            movieResult = []
            self.tableView.reloadData()
        } else if(searchText.count > 3) {
            self.movieResult = []
            self.tableView.reloadData()
            if (searchText.count != 0) {
                guard let theURL = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=a3956525871efa056dd08a0599938f8b&language=en-US&page=1&include_adult=true&query=\(searchText.replacingOccurrences(of: " ", with: "%20"))") else { print ("Error"); return }
                fetch(url: theURL)
            }
        }
        
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

extension URLSession {
    enum CustomError: Error {
        case invalidUrl
        case invalidData
    }
    
    func request<T: Codable>(
        url: URL?,
        expecting: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let url = url else {
            completion(.failure(CustomError.invalidUrl))
            return
        }
        
        let task = dataTask(with: url) { data, _, error in
            guard let data = data else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(CustomError.invalidData))
                }
                return
            }
            
            do {
                let moviesResponse = try JSONDecoder().decode(expecting, from: data)
                completion(.success(moviesResponse))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
        
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
