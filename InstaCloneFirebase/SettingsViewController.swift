import UIKit
import Firebase

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        do{
            try Auth.auth().signOut()
        } catch {
            print("error")
        }
        performSegue(withIdentifier: "toViewController", sender: nil)
    }
    
}
