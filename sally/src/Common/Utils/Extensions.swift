import Foundation
import UIKit

//MARK: UI
extension UIImageView {
    func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to download image data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            guard let image = UIImage(data: data) else {
                print("Failed to create image from data")
                return
            }
            
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
