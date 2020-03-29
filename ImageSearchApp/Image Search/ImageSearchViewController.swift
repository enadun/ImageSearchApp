//
//  FirstViewController.swift
//  ImageSearchApp
//
//  Created by nadun.eranga.baduge on 29/3/20.
//  Copyright © 2020 nadun.eranga.baduge. All rights reserved.
//

import UIKit

class ImageSearchViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Dissmissing keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        view.addGestureRecognizer(tapGesture)
        
    }
    
    //MARK:- Private methods
    @objc
    private func hideKeyboard() {
        view.endEditing(true)
    }
    
    //MARK:- Button tap methods
    @IBAction func searchButtonTapped(_ sender: Any) {
    }
    
}

