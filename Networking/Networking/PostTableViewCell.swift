import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(_ post: Post) {
        idLabel.text = String(post.id)
        titleLabel.text = post.title
    }
}
