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
