//
//  ViewController.swift
//  thread-practice
//
//  Created by Jinsei Shima on 2018/10/30.
//  Copyright © 2018 Jinsei Shima. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let lock = NSRecursiveLock()
    
    var value: [String] = []
    
    var value1: [String] = []
    var value2: [String] = []
    
    class State {
        
        var value: [String] {
            return _value
        }
        var name: String {
            return _name
        }
        
        private var _value: [String] = []
        private var _name: String = ""
        
        private let lock = NSRecursiveLock()
        
        func commit(value: [String]) {
            lock.lock()
            defer { lock.unlock() }
            _value += value
        }
        
        func commit(name: String) {
            lock.lock()
            defer { lock.unlock() }
            _name = name
        }
            
    }
    
    let state = ViewController.State()
    
    class View: UIView {
        let state: State
        init(state: State) {
            self.state = state
            super.init(frame: .zero)
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            state.commit(value: ["hoge"])
            print(state.value)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // case 0
        // EXC_BAD_INSTRUCTION
        
//        let queue = DispatchQueue(label: "hoge")
//
//        queue.sync {
//            print("fuga")
//            queue.sync {
//                print("hoge")
//            }
//        }
        
//        DispatchQueue.global().sync {
//            print("fuga")
//            DispatchQueue.global().sync {
//                print("hoge")
//            }
//        }

        
        // case 1
        
//        let _view = View(state: state)
//        self.view.addSubview(_view)
//        _view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
//        _view.backgroundColor = .gray
//        _view.setNeedsLayout()
//
//        let group = DispatchGroup()
//
//        group.enter()
//        DispatchQueue.global().async {
//            self.state.commit(value: ["hoge", "fuga"])
//            group.leave()
//        }
//        group.enter()
//        DispatchQueue.global().async {
//            self.state.commit(value: ["b", "c"])
//            group.leave()
//        }
//
//        group.notify(queue: DispatchQueue.global(qos: .default), execute: {
//            print(self.state.value)
//        })
        

        // case 2
        
        (0...100).forEach { _ in
            DispatchQueue.global().async {
                self.update(value: "hoge")
                print(self.read())
            }

            DispatchQueue.global().async {
                self.update(value: "fuga")
                print(self.read())
            }
        }
        
        // memo: 排他ロック、共有ロック
        
        // case 3
        
//        let queue1 = DispatchQueue(label: "thread1")
//        let queue2 = DispatchQueue(label: "thread2")
//
//        queue1.async {
//            print(Thread.current)
//            self.update1(value: "hoge")
//            self.update2(value: "hoge")
//        }
//        queue2.async {
//            print(Thread.current)
//            self.update2(value: "fuga")
//            self.update1(value: "fuga")
//        }
//
//        print(value)
        
        
        // case 4
        
        
//        var a = [1,2,3]
//        {
//            didSet {
//                print(a.count)
//            }
//        }
//
//        let _lock = NSLock()
//
//        // 同一スレッドでアクセス２重ロックするとデッドロック
//
//        (0...1000).forEach { value in
//            DispatchQueue.global().async {
//                _lock.lock()
//                defer { _lock.unlock() }
//                a.append(5)
//            }
//            DispatchQueue.global().async {
//                _lock.lock()
//                defer { _lock.unlock() }
//                a.append(6)
//            }
//        }
        
        
        
//        let serialQueue = DispatchQueue(label: "com.example.serial-queue", attributes: .concurrent)
//        (0...1000).forEach { _ in
//            serialQueue.async {
//                a.append(6)
//            }
//            DispatchQueue(label: "hoge", attributes: .concurrent).async {
//                a.append(7)
//            }
//            DispatchQueue.global().async {
//                a.append(8)
//            }
//        }
        
    }
    
    
    func read() -> [String] {
        lock.lock()
        defer { lock.unlock() }
        
        return value
    }

    func update(value: String) {
        lock.lock()
        defer { lock.unlock() }

        self.value.append(value)
        print(value)
    }
    
    func update1(value: String) {
        lock.lock()
        defer { lock.unlock() }
        
        self.value.append(value)
        print("update1:", value)
    }
    
    func update2(value: String) {
        lock.lock()
        defer { lock.unlock() }
        
        self.value.append(value)
        print("update2:", value)
    }


}

