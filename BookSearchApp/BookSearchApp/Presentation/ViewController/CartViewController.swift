//
//  CartViewController.swift
//  BookSearchApp
//
//  Created by 윤주형 on 5/11/25.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class CartViewController: UIViewController {

    private let viewModel = CartViewModel()
    private let disposeBag = DisposeBag()

    private let tableView = UITableView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        setupLayout()
        setupTableView()
        bindViewModel()

    }

    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchBooks()
    }

    
    private func setupNav() {
        navigationItem.title = "담은 책 목록"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "전체 삭제", style: .plain, target: self, action: #selector(deleteAllBooks)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(moveToSearchTab)
        )
    }

    private func setupLayout() {

        view.addSubview(tableView)

        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func setupTableView() {
        tableView.register(CartBookCell.self, forCellReuseIdentifier: CartBookCell.id)
        tableView.dataSource = self
        tableView.delegate = self
    }

//    private func fetchBooks() {
//        //여기서 detailVC에서 담기 버튼을 눌러서 저장된 책들을 불러옴
//        books = CoreDataManager.shared.fetchSavedBooks()
//        tableView.reloadData()
//    }

    @objc private func deleteAllBooks() {
        viewModel.deleteAllTapped.accept(())
    }

    @objc private func moveToSearchTab() {
        tabBarController?.selectedIndex = 0
        //이거 받으면 first responder 활성화
    }

    private func bindViewModel() {
        viewModel.BooksRelay
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            }).disposed(by: disposeBag)
    }
}

extension CartViewController: UITableViewDataSource, UITableViewDelegate {


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.BooksRelay.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bookRelayValue = viewModel.BooksRelay.value
        let selectedRow = bookRelayValue[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartBookCell.id, for: indexPath) as? CartBookCell else {
            return UITableViewCell()
        }
        cell.configure(with: selectedRow)
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let bookRelayValue = viewModel.BooksRelay.value
        if editingStyle == .delete {
            let selectedRow = bookRelayValue[indexPath.row]
            viewModel.deleteSwipeItem.accept(selectedRow)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }


    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let topBottomSpacing: CGFloat = 8
        cell.contentView.frame = cell.contentView.frame.inset(by: UIEdgeInsets(top: topBottomSpacing, left: 0, bottom: topBottomSpacing, right: 0))
    }

}
