
import UIKit
import SQLite3

class ViewController: UIViewController {
    
    var db: OpaquePointer? = nil
    
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
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setGradientBackground()
        super.viewWillAppear(animated)
    }

    //Login Button Action
    @IBAction func loginBtnAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
        mainTabBarController.modalPresentationStyle = .fullScreen
        self.present(mainTabBarController, animated: true, completion: nil)
    }
}

