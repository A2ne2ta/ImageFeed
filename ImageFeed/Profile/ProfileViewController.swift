//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Анна on 18.12.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private var avatarImageView: UIImageView?
    private var nameLabel: UILabel?
    private var loginNameLabel: UILabel?
    private var descriptionLabel: UILabel?
    private var logoutButton: UIButton?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profileImage = UIImage(named: "Avatar")
        let imageView = UIImageView(image: profileImage)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        self.avatarImageView = imageView
        
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        let nameLabel = UILabel()
        let loginNameLabel = UILabel()
        let descriptionLabel = UILabel()
        
        nameLabel.text = "Екатерина Новикова"
        nameLabel.font = UIFont.boldSystemFont(ofSize: 23.0)
        nameLabel.textColor = UIColor(named: "YP White")
        
        loginNameLabel.text = "@ekaterina_nov"
        loginNameLabel.font = UIFont.systemFont(ofSize: 13.0)
        loginNameLabel.textColor = UIColor(named: "YP Gray")
        
        descriptionLabel.text = "Hello, World!"
        descriptionLabel.font = UIFont.systemFont(ofSize: 13.0)
        descriptionLabel.textColor = UIColor(named: "YP White")
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginNameLabel)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate ([
            nameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            loginNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
        ])
        self.nameLabel = nameLabel
        self.loginNameLabel = loginNameLabel
        self.descriptionLabel = descriptionLabel
        
        let logoutButton = UIButton.systemButton(
            with: UIImage(systemName: "ipad.and.arrow.forward")!,
            target: self,
            action: #selector (Self.didTapButton)
        )
        
        logoutButton.tintColor = UIColor(named: "YP Red")
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        
        logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        logoutButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
    }
    
    @objc
    private func didTapButton() {
        
        nameLabel?.removeFromSuperview()
        nameLabel = nil
        loginNameLabel?.removeFromSuperview()
        loginNameLabel = nil
        descriptionLabel?.removeFromSuperview()
        descriptionLabel = nil
        avatarImageView?.image = UIImage(named: "default_avatar")
    }
}
