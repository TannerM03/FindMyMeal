//
//  ImageViewModel.swift
//  MunchMadness
//
//  Created by Tanner Macpherson on 4/9/24.
//

import Foundation
import UIKit

class ImageViewModel: ObservableObject {
    @Published var image: UIImage?

    private static var imageCache: NSCache<NSString, UIImage> = {
            let cache = NSCache<NSString, UIImage>()
            return cache
        }()
    
    init(urlString: String?) {
        loadImage(urlString: urlString)
    }

    private func loadImage(urlString: String?) {
        guard let urlString = urlString else { return }

        if let imageFromCache = getImageFromCache(from: urlString) {
            self.image = imageFromCache
            return
        }

        loadImageFromURL(urlString: urlString)
    }

    private func loadImageFromURL(urlString: String) {
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
//                print(error ?? "unknown error")
                return
            }

            guard let data = data else {
//                print("No data found")
                return
            }

            DispatchQueue.main.async { [weak self] in
                guard let loadedImage = UIImage(data: data) else { return }
                self?.image = loadedImage
                self?.setImageCache(image: loadedImage, key: urlString)
            }
        }.resume()
    }

    private func setImageCache(image: UIImage, key: String) {
        ImageViewModel.imageCache.setObject(image, forKey: key as NSString)
    }

    private func getImageFromCache(from key: String) -> UIImage? {
        return ImageViewModel.imageCache.object(forKey: key as NSString)
    }
}
