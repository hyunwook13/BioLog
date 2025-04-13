//
//  AsyncFetchImageView.swift
//  BioLog
//
//  Created by 이현욱 on 3/12/25.
//

import UIKit

class AsyncFetchImageView: UIImageView {
    
    private var currentTask: URLSessionDataTask?
    private static let imageCache = NSCache<NSString, UIImage>()
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setting()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setting()
    }
    
    private func setting() {
        self.image = UIImage(systemName: "book.closed")?.withTintColor(.label)
    }
    
    func fetchImage(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        // 캐시에서 이미지 확인
        let cacheKey = NSString(string: urlString)
        if let cachedImage = AsyncFetchImageView.imageCache.object(forKey: cacheKey) {
            self.image = cachedImage
            return
        }
        
        // Cancel existing task if any
        currentTask?.cancel()
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  let data = data,
                  let image = UIImage(data: data),
                  error == nil else {
                return
            }
            
//            image.getDominantColors { [weak self] colors in
//                guard let self = self else { return }
//                self.setupGradientLayer(with: colors)
//            }
            
            // 이미지를 캐시에 저장
            AsyncFetchImageView.imageCache.setObject(image, forKey: cacheKey)
            
            DispatchQueue.main.async {
                self.image = image
            }
        }
        
        currentTask = task
        task.resume()
    }
    
    func cancelFetch() {
        currentTask?.cancel()
        currentTask = nil
    }
    
    func setupGradientLayer(with colors: [UIColor]) {
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
