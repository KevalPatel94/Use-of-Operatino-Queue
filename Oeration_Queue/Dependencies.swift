//
//  Dependencies.swift
//  Oeration_Queue
//
//  Created by Keval Patel on 4/30/19.
//  Copyright © 2019 Keval Patel. All rights reserved.
//

import UIKit

class Dependencies: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let addOperation = Addition(3, 4)
        let squareOperation = Squre()
        squareOperation.addDependency(addOperation)
        let op_Queue = OperationQueue()
        op_Queue.addOperation(addOperation)
        op_Queue.addOperation(squareOperation)

    }
}

// Performs Add Operation
class Addition: AsyncOperation {
    var num1 : Int?
    var num2 : Int?
    var resultNum : Int?
    init(_ num1: Int,_ num2: Int) {
        self.num1 = num1
        self.num2 = num2
    }
    override func main() {
        add(num1 ?? 0, num2 ?? 0) { (result) in
            self.resultNum = result
            print(result)
            self.state = .Finished
        }
    }
    func add(_ num1: Int, _ num2: Int,_ completion: @escaping(Int)->()){
        let num = num1 + num2
        completion(num)
    }
}


protocol NumberProvider {
    var addedNumber : Int? {get}
}
extension Addition : NumberProvider{
    var addedNumber: Int? {return resultNum}
}


// Performs the Square Operation
class Squre: Operation {
    var inputNum : Int?
    var outputNum : Int?
//    init(_ inputNum: Int) {
//        self.inputNum = inputNum
//    }
    func squareNumber(_ inputNum: Int){
        outputNum = inputNum * inputNum
        print(outputNum ?? 0)
    }
    override func main() {
        if let dependencyNumProvider = dependencies
            .filter({ $0 is NumberProvider})
            .first as? NumberProvider,
            inputNum == .none {
            inputNum = dependencyNumProvider.addedNumber
        }
        squareNumber(inputNum ?? 0)
    }
}
