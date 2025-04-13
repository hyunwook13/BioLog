//
//  UIImage.swift
//  BioLog
//
//  Created by 이현욱 on 3/24/25.
//

import UIKit

extension UIImage {
    func getDominantColors(completion: @escaping ([UIColor]) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let inputImage = CIImage(image: self) else { return }
            
            let filter = CIFilter(name: "CIAreaHistogram")
            filter?.setValue(inputImage, forKey: kCIInputImageKey)
            filter?.setValue(CIVector(cgRect: inputImage.extent), forKey: "inputExtent")
            filter?.setValue(10, forKey: "inputCount") // 분석할 색상 수
            
            guard let outputImage = filter?.outputImage else { return }
            
            let context = CIContext()
            var colors: [UIColor] = []
            
            if let outputData = context.createCGImage(outputImage, from: outputImage.extent) {
                let dataProvider = outputData.dataProvider
                let data = dataProvider?.data
                let bytes = CFDataGetBytePtr(data)
                
                if let bytes = bytes {
                    for i in 0..<10 {
                        let offset = i * 4
                        let color = UIColor(
                            red: CGFloat(bytes[offset]) / 255.0,
                            green: CGFloat(bytes[offset + 1]) / 255.0,
                            blue: CGFloat(bytes[offset + 2]) / 255.0,
                            alpha: 1.0
                        )
                        colors.append(color)
                    }
                }
            }
            
            DispatchQueue.main.async {
                completion(colors)
            }
        }
    }
}
