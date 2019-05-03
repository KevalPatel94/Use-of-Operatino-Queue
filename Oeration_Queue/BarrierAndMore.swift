//
//  BarrierAndMore.swift
//  Oeration_Queue
//
//  Created by Keval Patel on 4/30/19.
//  Copyright © 2019 Keval Patel. All rights reserved.
//

import UIKit

class BarrierAndMore: UIViewController {
let workerQueue = DispatchQueue(label: "Operations", attributes: .concurrent)
let dispatcher = DispatchGroup()
let nameList = [("Vaibhav", "Shankar"),("Keval", "Patel"),("Arhat", "Baid"),("Nehit", "Neema"),("Irfan", "Ajmeri")]
    override func viewDidLoad() {
        super.viewDidLoad()
//        nonThreadSafe()
        threadSafe()
    }
    func nonThreadSafe(){
        let nameChangingperson = Person("NM", "Modi")
        for (idx,name) in nameList.enumerated() {
            workerQueue.async(group: dispatcher, execute: DispatchWorkItem.init(block: {
                nameChangingperson.changeName(firstName: name.0, lastName: name.1)
                print("Current Name: \(nameChangingperson.name)")
            }))
        }
        dispatcher.notify(queue: workerQueue, work: DispatchWorkItem(block: {
            print("Final Name: \(nameChangingperson.name)")
        }))
    }
    func threadSafe(){
        let nameChangingperson = ThreadSafePerson("NM", "Modi")
        for (idx,name) in nameList.enumerated() {
            workerQueue.async(group: dispatcher, execute: DispatchWorkItem.init(block: {
                nameChangingperson.changeName(firstName: name.0, lastName: name.1)
                print("Current Name: \(nameChangingperson.name)")
            }))
        }
        dispatcher.notify(queue: .main, work: DispatchWorkItem(block: {
            print("Final Name: \(nameChangingperson.name)")
        }))
    }
    
}

class Person{
    var firstName: String
    var lastName: String
    public init(_ firstName: String, _ lastName: String){
        self.firstName = firstName
        self.lastName = lastName
    }
    open func changeName(firstName: String, lastName:String){
//        sleep(2)
        self.firstName = firstName
//        sleep(3)
        self.lastName = lastName
    }
    open var name :String{
        return "\(firstName) \(lastName)"
    }

}

class ThreadSafePerson: Person {
    let insiderConcurrentQueue = DispatchQueue(label: "insiderConcurrentQueue",attributes: .concurrent)
    override func changeName(firstName: String, lastName: String) {
        insiderConcurrentQueue.async(flags: .barrier) {
            super.changeName(firstName: firstName, lastName: lastName)
        }
    }
    override var name: String{
        return insiderConcurrentQueue.sync {
            return super.name
        }
    }
}
