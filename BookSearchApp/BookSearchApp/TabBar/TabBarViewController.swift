//
//  TabBarViewController.swift
//  BookSearchApp
//
//  Created by 윤주형 on 5/11/25.
//

import Foundation
import UIKit
import SnapKit

class TabBarViewController: UITabBarController {

    let customTabBarView = UIView()

    let searchTabButton: UIButton = {
        let button = UIButton()
        return button
    }()

    let cartTabButton: UIButton = {
        let button = UIButton()
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTabBar()

    }
    //https://dokit.tistory.com/22 나중에 참고하기
    private func setUpTabBar() {
        let searchViewController = SearchViewController()
        let cartViewController = CartViewController()

        searchViewController.tabBarItem = UITabBarItem(title: "검색 탭", image: nil, tag: 0)
        cartViewController.tabBarItem = UITabBarItem(title: "담은 책 리스트 탭", image:nil, tag: 1)


        self.viewControllers = [searchViewController, cartViewController]
    }
}
