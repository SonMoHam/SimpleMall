//
//  UIViewController+Rx.swift
//  SimpleMall
//
//  Created by 손대홍 on 2022/11/26.
//

import UIKit

import RxCocoa
import RxSwift

public extension Reactive where Base: UIViewController {
    var viewDidLoad: Observable<Void> {
        return sentMessage(#selector(UIViewController.viewDidLoad)).map { _ in }
    }
    
    var viewWillAppear: Observable<Void> {
        return sentMessage(#selector(UIViewController.viewWillAppear(_:))).map { _ in }
    }
//
//    var viewDidAppear: Observable<Void> {
//        return sentMessage(#selector(UIViewController.viewDidAppear(_:))).map { _ in }
//    }
//
//    var viewWillDisappear: Observable<Void> {
//        return sentMessage(#selector(UIViewController.viewWillDisappear(_:))).map { _ in }
//    }
//
//    var viewDidDisappear: Observable<Void> {
//        return sentMessage(#selector(UIViewController.viewDidDisappear(_:))).map { _ in }
//    }
}
