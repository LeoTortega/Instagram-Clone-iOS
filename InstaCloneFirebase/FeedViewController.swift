import UIKit
import Firebase
import FirebaseFirestore
import SDWebImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var userEmailArray = [String]()
    var userCommentArray = [String]()
    var likeArray = [Int]()
    var userImageArray = [String]()
    var documentIDArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromFirestore()
    }
    
    func getDataFromFirestore() {
        
        let firestoreDatabase = Firestore.firestore()
        
        firestoreDatabase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { snapshot, error in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    
                    self.userImageArray.removeAll()
                    self.userEmailArray.removeAll()
                    self.likeArray.removeAll()
                    self.userCommentArray.removeAll()
                    self.documentIDArray.removeAll()
                    
                    for document in snapshot!.documents {
                        let documentID = document.documentID
                        
                        self.documentIDArray.append(documentID)
                        
                        if let postedBy = document.get("postedBy") as? String {
                            self.userEmailArray.append(postedBy)
                        }
                        
                        if let postComment = document.get("postComment") as? String {
                            self.userCommentArray.append(postComment)
                        }
                        
                        if let likes = document.get("likes") as? Int {
                            self.likeArray.append(likes)
                        }
                        
                        if let imageURL = document.get("imageURL") as? String {
                            self.userImageArray.append(imageURL)
                        }
                            
                    }
                    
                    self.tableView.reloadData()
                    
                }
                
                
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        
        cell.userEmailLabel.text = userEmailArray[indexPath.row]
        cell.likeLabel.text = "\(likeArray[indexPath.row])"
        cell.commentLabel.text = userCommentArray[indexPath.row]
        cell.userImageView.sd_setImage(with: URL(string: userImageArray[indexPath.row]))
        cell.documentIDLabel.text = documentIDArray[indexPath.row]
        
        return cell
    }
    

}
