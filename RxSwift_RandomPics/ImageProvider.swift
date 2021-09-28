//
//  ImageProvider.swift
//  RxSwift_RandomPics
//
//  Created by 黃瀞萱 on 2021/9/28.
//

import UIKit

class ImageProvider {
    
    private let url = URL(string: "https://dog.ceo/api/breeds/image/random")
    private let session = URLSession.shared
    
    // fetch image
    func getRandomImage(completion: @escaping (Result<URL, Error>) -> Void) {
        
        guard let urlString = url else { return }
        session.dataTask(with: urlString) { (data, response, error) in
            guard let data = data else { return }
            do {
                let randomImage = try JSONDecoder().decode(Image.self, from: data)
                print("data \(randomImage)")
                completion(.success(URL(string: randomImage.message)!))
            } catch {
                print(error)
                completion(.failure(error))
            }
        }.resume()
    }
    
    // download image
    func downloadImage(url: URL, completion: @escaping ((Result<UIImage?, Error>) -> Void)) {
        
        session.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            completion(.success(UIImage(data: data)))
        }.resume()
    }
}
