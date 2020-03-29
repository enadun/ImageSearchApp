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
    
    private var vm: ImageSearchViewModalType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Dissmissing keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        view.addGestureRecognizer(tapGesture)
        configVM()
    }
    
    //MARK:- Private methods
    private func configVM() {
        let api = APIManager()
        let dataManager = DataManager(with: api)
        vm = ImageSearchViewModal(with: dataManager)
    }
    
    @objc
    private func hideKeyboard() {
        view.endEditing(true)
    }
    
    //MARK:- Button tap methods
    @IBAction func searchButtonTapped(_ sender: Any) {
        if let keyword = searchTextField.text {
            vm?.getImagesFor(keyword: keyword, completion: { result in
                switch result {
                case .success(let images):
                    print(images)
                case .failure(let error):
                    print(error)
                }
            })
        }
    }
    
}

