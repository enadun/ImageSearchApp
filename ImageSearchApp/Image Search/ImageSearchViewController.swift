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
    @IBOutlet weak var tableView: UITableView!
    
    private var vm: ImageSearchViewModalType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Dissmissing keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        view.addGestureRecognizer(tapGesture)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        configVM()
        bindUI()
        searchTextField.delegate = self
    }
    
    //MARK:- Private methods
    private func bindUI() {
        vm?.images.bind(listener: { images in
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
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

extension ImageSearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vm?.getImageCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView
            .dequeueReusableCell(withIdentifier: ImageTableViewCell.cellID,
                                 for: indexPath) as? ImageTableViewCell
        cell?.vm = vm?.getImageVMAt(index: indexPath.row)
        return cell ?? ImageTableViewCell()
    }
}

extension ImageSearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        search()
        return true
    }
}

