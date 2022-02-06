
import UIKit
import SQLite3

class ViewController: UIViewController {
    
    var db: OpaquePointer? = nil
    @IBOutlet weak var getEmail: UITextField!
    @IBOutlet weak var getPassword: UITextField!
    
    //Background and statusbar color
    func setGradientBackground() {
        let colorTop =  UIColor(red: 99.0/255.0, green: 212.0/255.0, blue: 246.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 48.0/255.0, green: 105.0/255.0, blue: 178.0/255.0, alpha: 1.0).cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at:0)

        let statusBar = UIView()
        statusBar.frame = UIApplication.shared.statusBarFrame
        statusBar.backgroundColor = UIColor(red: 125.0/255.0, green: 203.0/255.0, blue: 238.0/255.0, alpha: 1.0)
        UIApplication.shared.keyWindow?.addSubview(statusBar)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("Movies.sqlite")
        print(fileURL.path)
               
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        
        
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Watchlist (id INTEGER PRIMARY KEY,backdrop_path TEXT, original_title TEXT, overview TEXT, poster_path TEXT, release_date TEXT, vote_average DOUBLE DEFAULT 0.0)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Favorities (id INTEGER PRIMARY KEY,backdrop_path TEXT, original_title TEXT, overview TEXT, poster_path TEXT, release_date TEXT, vote_average DOUBLE DEFAULT 0.0)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setGradientBackground()
        super.viewWillAppear(animated)
    }
    
    func isValidMailInput(input: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: input)
    }
    
    func isValidPassword(password:String?) -> Bool {
        guard password != nil else { return false }

        // at least one uppercase,
        // at least one digit
        // at least one lowercase
        // 8 characters total
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
        return passwordTest.evaluate(with: password)
    }

    //Login Button Action
    @IBAction func loginBtnAction(_ sender: Any) {
        self.hideKeyboardWhenTappedAround()
        if (isValidMailInput(input: getEmail.text!) && isValidPassword(password: getPassword.text!)) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
            mainTabBarController.modalPresentationStyle = .fullScreen
            self.present(mainTabBarController, animated: true, completion: nil)
        } else if (isValidMailInput(input: getEmail.text!) == false) {
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.07
            animation.repeatCount = 4
            animation.autoreverses = true
            animation.fromValue = NSValue(cgPoint: CGPoint(x: getEmail.center.x - 2, y: getEmail.center.y))
            animation.toValue = NSValue(cgPoint: CGPoint(x: getEmail.center.x + 2, y: getEmail.center.y))
            getEmail.layer.borderColor = UIColor.red.cgColor
            getEmail.layer.borderWidth = 1.0
            getEmail.layer.cornerRadius = 5.0
            getEmail.layer.add(animation, forKey: "position")
            getEmail.placeholder = "Check your email address"
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.getEmail.placeholder = "Email"
                self.getEmail.layer.borderWidth = 0
            }
        } else {
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.07
            animation.repeatCount = 4
            animation.autoreverses = true
            animation.fromValue = NSValue(cgPoint: CGPoint(x: getPassword.center.x - 2, y: getPassword.center.y))
            animation.toValue = NSValue(cgPoint: CGPoint(x: getPassword.center.x + 2, y: getPassword.center.y))
            getPassword.layer.borderColor = UIColor.red.cgColor
            getPassword.layer.borderWidth = 1.0
            getPassword.layer.cornerRadius = 5.0
            getPassword.layer.add(animation, forKey: "position")
            getPassword.placeholder = "Min 8 characters at least 1 Uppercase Alphabet,Number,Special Character"
            self.getPassword.text = ""
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.getPassword.placeholder = "Password"
                self.getPassword.layer.borderWidth = 0
            }
        }
    }
}
