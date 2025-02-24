//
//  ViewController.swift
//  BioLog
//
//  Created by 이현욱 on 2/24/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    ~
    "Podfile" 19L, 369B
      1 # Uncomment the next line to define a global platform for your project
      2 # platform :ios, '9.0'
      3
      4 target 'BioLog' do
      5   # Comment the next line if you don't want to use dynamic frameworks
      6   use_frameworks!
      7
      8   # Pods for BioLog
      9
     10   target 'BioLogTests' do
     11     inherit! :search_paths
     12     # Pods for testing
     13   end
     14
     15   target 'BioLogUITests' do
     16     # Pods for testing
     17   end
     18
     19 end
    ~
    ~
    ~
    ~
    ~
    "Podfile" 19L, 369B

}

