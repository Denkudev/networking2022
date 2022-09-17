import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var downloadPostsLabel: UILabel!
    @IBOutlet weak var myTableView: UITableView! {
        didSet{
            myTableView.delegate = self
            myTableView.dataSource = self
            
            let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
            myTableView.register(nib, forCellReuseIdentifier: "PostCellID")
        }
    }
    
    var networkManager = NetworkManager()
    var myPosts: [Post] = [] {
        didSet {
            myTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func downloadPostsDidTap(_ sender: UIButton) {
        networkManager.getAllPosts { [weak self] (posts) in
            
            DispatchQueue.main.async {
                self?.myPosts = posts
                self?.downloadPostsLabel.text = "Posts has been downloaded!"
            }
        }
    }
    
    @IBAction func createPostDidTap(_ sender: UIButton) {
        
        let post = Post(userId: 1, title: "myTtitle", body: "myBuddy")
        networkManager.postCreatePost(post) { serverPost in
            post.id = serverPost.id
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Great!", message: "Your post has been created.", preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    alert.dismiss(animated: true)
                }
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "PostCellID", for: indexPath) as! PostTableViewCell
        cell.configure(myPosts[indexPath.row])
        
        return cell
    }
    
    
}
