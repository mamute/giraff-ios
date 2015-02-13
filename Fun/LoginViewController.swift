import UIKit

class LoginViewController: UIViewController, FBLoginViewDelegate {
    @IBOutlet weak var loginView: FBLoginView!
    @IBOutlet weak var bgImage: UIImageView!
    
    var signedIn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginView.readPermissions = ["public_profile", "email"]
        loginView.delegate = self
        
        if let image = launchImage() {
            bgImage.image = image
            self.view.bringSubviewToFront(loginView)
        }
    }
    
    func loginViewFetchedUserInfo(loginView : FBLoginView!, user: FBGraphUser) {
        NSLog("Facebook login successful")
        var email = user.objectForKey("email") as String
        FunSession.sharedSession.signIn(email) {
            NSLog("API signin successful")
            if !self.signedIn {
                self.performSegueWithIdentifier("loggedIn", sender: user)
            }
            self.signedIn = true
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSLog("signed in: \(self.signedIn)")
    }
    
    func launchImage() -> UIImage? {
        let fileName = launchImageFileName()
        if let file = NSBundle.mainBundle().pathForResource(fileName, ofType: "png") {
            return UIImage(contentsOfFile: file)!
        }
        return nil
    }
    
    func launchImageFileName() -> String {
        switch(UIScreen.mainScreen().bounds.size.height) {
        case 568:
            return "LaunchImage-700-568h@2x"
        case 667:
            return "LaunchImage-800-667h@2x"
        case 736:
            return "LaunchImage-800-Portrait-736h@3x"
        default:
            return "LaunchImage-700@2x"
        }
    }
}
