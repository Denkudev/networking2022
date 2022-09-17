import Foundation

class NetworkManager {
    
    enum HTTPMethod: String {
        case POST
        case PUT
        case GET
        case DELETE
    }
    
    enum APIs: String {
        case posts
        case users
        case comments
    }
    
    private let baseURL = "https://jsonplaceholder.typicode.com/"
    
    func getAllPosts(_ complitionHandler: @escaping ([Post]) -> Void) {
        if let url = URL(string: baseURL + APIs.posts.rawValue) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                if error != nil {
                    print("Error in request")
                } else {
                    if let resp = response as? HTTPURLResponse, resp.statusCode == 200, let responseData = data {
                        let posts = try? JSONDecoder().decode([Post].self, from: responseData)
                        complitionHandler(posts ?? [])
                    }
                }
            }.resume()
        }
    }
    
    func postCreatePost(_ post: Post, complitionHandler: @escaping (Post) -> Void) {
        guard let url = URL(string: baseURL + APIs.posts.rawValue), let data = try? JSONEncoder().encode(post) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.POST.rawValue
        request.httpBody = data
        request.setValue("\(data.count)", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                print("error")
            } else if let resp = response as? HTTPURLResponse, resp.statusCode == 201, let responseData = data {
                
                if let responsePost = try? JSONDecoder().decode(Post.self, from: responseData) {
                    complitionHandler(responsePost)
                }
            }
        }.resume()
    }
}
