//
//  ViewController.swift
//  Oeration_Queue
//
//  Created by Keval Patel on 4/28/19.
//  Copyright © 2019 Keval Patel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let additionOperationQueue = OperationQueue()
    let input = [(1,2),(5,6),(7,8),(8,9),(9,10)]
    override func viewDidLoad() {
        super.viewDidLoad()
        for (lhs, rhs) in input {
            // DONE: Create SumOperation object
            let operation = SumOperation(lhs: lhs, rhs: rhs)
            operation.completionBlock = {
                guard let result = operation.result else { return }
                print("\(lhs) + \(rhs) = \(result)")
            }
            // DONE: Add SumOperation to additionQueue
            additionOperationQueue.addOperation(operation)
        }
        // Do any additional setup after loading the view.
    }


}


//Set Up State Property with Key Value
class AsyncOperation: Operation{
    enum State:String{
        case Ready, Executing, Finished
        fileprivate var keyPath: String{
            return "is" + rawValue
        }
    }
    var state = State.Ready{
        willSet{
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        didSet{
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
    
}

//Overrride Operation Property
extension AsyncOperation{
    override var isReady: Bool{
        return super.isReady == true && state == .Ready
    }
    override var isExecuting: Bool{
        return state == .Executing
    }
    override var isFinished: Bool{
        return state == .Finished
    }
    override var isAsynchronous: Bool{
        return true
    }
    override func start() {
        if isCancelled{
            state = .Finished
        }
        main()
        state = .Executing
    }
    override func cancel() {
        state = .Finished
    }
}

class SumOperation: AsyncOperation {
    var lhs: Int
    var rhs: Int
    var result : Int?
    init(lhs: Int, rhs: Int) {
        self.lhs = lhs
        self.rhs = rhs
        super.init()
    }
    public func add(_ lhs: Int, _ rhs: Int,_ completion:  @escaping (Int) -> ()){
        completion(lhs + rhs)
    }
    override func main() {
        add(lhs, rhs) { (result) in
            self.result = result
            self.state = .Finished
        }
    }
}
