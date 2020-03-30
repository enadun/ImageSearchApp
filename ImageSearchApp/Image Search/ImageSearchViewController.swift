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
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var emptyListLabel: UILabel!
    
    private var vm: ImageSearchViewModalType?
    private var isInitialLoad = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Dissmissing keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
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
                self?.loadingView.isHidden = true
                self?.emptyListLabel.isHidden = images.count > 0
                    || self?.isInitialLoad == true
                self?.tableView.reloadData()
            }
            print(images)
        })
        
        vm?.error.bind(listener: { error in
            DispatchQueue.main.async { [weak self] in
                self?.loadingView.isHidden = true
                self?.displayErrorAlert()
            }
        })
        
        vm?.mainImage.bind(listener: { image in
            DispatchQueue.main.async { [weak self] in
                self?.loadingView.isHidden = true
                guard let image = image else {
                    self?.displayErrorAlert()
                    return 
                }
                let imagePreviewVC = ImagePreviewViewController(with: image)
                imagePreviewVC.modalPresentationStyle = .fullScreen
                self?.present(imagePreviewVC, animated: true, completion: nil)
            }
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
        if let keyword = searchTextField.text?.trimmingCharacters(in: .whitespaces) {
            if !keyword.isEmpty {
                loadingView.isHidden = false
                vm?.getImagesFor(keyword: keyword)
            }
        }
        isInitialLoad = false
    }
    
    private func displayErrorAlert() {
        if isInitialLoad == false {
            let alert = UIAlertController(title: "Error",
                                          message: "Something went wrong",
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default) { _ in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK:- Button tap methods
    @IBAction func searchButtonTapped(_ sender: Any) {
        search()
    }
    
}

extension ImageSearchViewController: UITableViewDataSource, UITableViewDelegate {
    //Data source methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vm?.getImageCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView
            .dequeueReusableCell(withIdentifier: ImageTableViewCell.cellID,
                                 for: indexPath) as? ImageTableViewCell
        cell?.vm = vm?.getImageVMAt(index: indexPath.row)
        cell?.delegate = self
        return cell ?? ImageTableViewCell()
    }
    
    //Delegate methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        loadingView.isHidden = false
        vm?.loadImageAt(index: indexPath.row)
    }
}

extension ImageSearchViewController: ImageCellDelegate {
    func searchOnWebWith(url: URL) {
        UIApplication.shared.open(url)
    }
}

extension ImageSearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        search()
        return true
    }
}

