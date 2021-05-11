//
//  PhotosViewController.swift
//  FlickrWalk
//
//  Created by Karagiorgos, Michalis, Vodafone Greece on 06/05/2021.
//

import UIKit
import CommonUtils

protocol PhotosViewProtocol: AnyObject {
    func setupTitle(text: String)
    func setupStopButton(title: String)
    func updateListView(cellItem: CellItem)
}

final class PhotosViewController: UIViewController {
    private let presenter: PhotosPresenterProtocol
    private let listView: ListView = ListView()

    private lazy var stopButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(handleStopButtonTapped))
        return button
    }()

    @objc func handleStopButtonTapped() {
        presenter.stopUpdates()
        navigationController?.popViewController(animated: true)
    }

    init(
        presenter: PhotosPresenterProtocol = PhotosPresenter()
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

// MARK: - PhotosViewProtocol
extension PhotosViewController: PhotosViewProtocol {
    func setupTitle(text: String) {
        title = text
    }

    func setupStopButton(title: String) {
        stopButton.title = title
    }

    func updateListView(cellItem: CellItem) {
        listView.insert(item: cellItem, at: 0)
    }
}

fileprivate extension PhotosViewController {
    func setupUI() {
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = stopButton
        view.addSubview(listView.tableView)
        listView.tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5).isActive = true
        listView.tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        listView.tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        listView.tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5).isActive = true
    }
}
