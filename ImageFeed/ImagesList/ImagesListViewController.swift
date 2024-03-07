//
//  ViewController.swift
//  setupProject
//
//  Created by Анна on 04.12.2023.
//

import UIKit
import Kingfisher

public protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
    func updateTableViewAnimated()
}

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    private var photoServiceObserver: NSObjectProtocol?
    
    var presenter: ImagesListPresenterProtocol? = ImagesListPresenter()
    
    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        presenter?.view = self
        presenter?.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier,
           let viewController = segue.destination as? SingleImageViewController,
           let indexPath = sender as? IndexPath {
            
            if let imageURL = presenter?.photos[indexPath.row].largeImageURL {
                viewController.image = URL(string: imageURL)
            }
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.photos.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter?.getNewPhotos(photoNumber: indexPath.row)
    }
}


extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        cell.delegate = self
        
        guard let photo = presenter?.photos[indexPath.row] else { return }
        
        let imageURL = photo.thumbImageURL
        let url = URL(string: imageURL)
        let placeholder = UIImage(named: "image_placeholder")
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(with: url, placeholder: placeholder) { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            cell.cellImage.kf.indicatorType = .none
        }
        
        cell.dateLabel.text = convertDataFromPhoto(photo: photo)
        
        let likeImage = photo.isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        cell.likeButton.setImage(likeImage, for: .normal)
        cell.selectionStyle = .none
    }
    
    func convertDataFromPhoto(photo: Photo) -> String {
        return presenter?.convertData(photo: photo) ?? ""
    }
    
    func updateTableViewAnimated() {
        tableView.performBatchUpdates {
            guard let newIndex = presenter?.updateListModel() else { return }
            tableView.insertRows(at: newIndex, with: .automatic)
        } completion: { _ in }
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let cellHeight = (presenter?.calculateImageHeight(index: indexPath.row, imageViewWidth: imageViewWidth))! + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        presenter?.changeLike(index: indexPath.row, cell: cell)
    }
}


