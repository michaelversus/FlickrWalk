//
//  InitialViewController.swift
//  FlickrWalk
//
//  Created by Karagiorgos, Michalis, Vodafone Greece on 06/05/2021.
//

import UIKit
import Networking
import CommonUtils

protocol InitialViewProtocol: AnyObject {
    func goToPhotos()
    func setupTitle(text: String)
    func setupButtonTitle(text: String)
    func presentAlert(with title: String, message: String)
}

final class InitialViewController: UIViewController {

    lazy var startButton: UIButton = UIButton(
        title: "",
        titleColor: .black,
        font: .boldSystemFont(ofSize: 20),
        backgroundColor: .lightGray,
        target: self,
        action: #selector(handleStartButton)
    )

    @objc func handleStartButton() {
        presenter.load()
    }

    private let presenter: InitialPresenterProtocol

    init(
        presenter: InitialPresenterProtocol = InitialPresenter()
    ) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.attach(self)
        presenter.initialLoad()
    }
}

// MARK: - InitialViewController
extension InitialViewController: InitialViewProtocol {
    func goToPhotos() {
        let photosVC = PhotosViewController()
        navigationController?.pushViewController(photosVC, animated: true)
    }

    func setupTitle(text: String) {
        title = text
    }

    func setupButtonTitle(text: String) {
        startButton.setTitle(text, for: .normal)
    }

    func presentAlert(with title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
    }
}

// MARK: - Setup UI
fileprivate extension InitialViewController {
    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(startButton)
        startButton.layer.cornerRadius = 6.0
        startButton.layer.masksToBounds = true
        startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        startButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        startButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
    }
}

