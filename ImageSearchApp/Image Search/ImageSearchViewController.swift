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
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        configVM()
        bindUI()
        searchTextField.delegate = self
    }
    
    //MARK:- Private methods
    private func bindUI() {
        vm?.images.bind(listener: { images in
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
            print(images)
        })
        
        vm?.error.bind(listener: { error in
            print(error) //Need to handle error, Display dialog
        })
    }
    
    private func configVM() {
        let api = APIManager()
        let dataManager = DataManager(with: api)
        vm = ImageSearchViewModal(with: dataManager)
    }
    
    @objc
    private func hideKeyboard() {
        view.endEditing(true)
    }
    
    private func search() {
        hideKeyboard()
        if let keyword = searchTextField.text {
            vm?.getImagesFor(keyword: keyword)
        }
    }
    
    //MARK:- Button tap methods
    @IBAction func searchButtonTapped(_ sender: Any) {
        search()
    }
    
}

extension ImageSearchViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    //MARK:- Data source methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        vm?.getImageCount() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.cellID,
                                 for: indexPath) as? ImageCollectionViewCell
        cell?.vm = vm?.getImageVMAt(index: indexPath.row)
        return cell ?? ImageCollectionViewCell()
    }
    
    //MARK:- Delegate methods
    
    
    //MARK:- DelegateFlowLayout methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width - 30,
               height: 100)
    }
}

extension ImageSearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        search()
        return true
    }
}

