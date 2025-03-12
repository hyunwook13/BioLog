//
//  AsyncFetchImageView.swift
//  BioLog
//
//  Created by 이현욱 on 3/12/25.
//

import UIKit

class AsyncFetchImageView: UIImageView {
    
    private var currentTask: URLSessionDataTask?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.image = UIImage(systemName: "book.closed")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.image = UIImage(systemName: "book.closed")
    }
    
    func fetchImage(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        // Cancel existing task if any
        currentTask?.cancel()
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  let data = data,
                  let image = UIImage(data: data),
                  error == nil else {
                return
            }
            
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
}
