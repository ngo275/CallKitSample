//
//  ViewController.swift
//  CallKitSample
//
//  Created by ShuichiNagao on 2018/06/24.
//  Copyright © 2018 Shuichi Nagao. All rights reserved.
//

import UIKit
import CallKit

// ref: https://websitebeaver.com/callkit-swift-tutorial-super-easy

class ViewController: UIViewController, CXProviderDelegate {

    private lazy var config: CXProviderConfiguration = {
        let conf = CXProviderConfiguration(localizedName: "CallKitTesting")
        conf.includesCallsInRecents = false
        conf.supportsVideo = true
        return conf
    }()
    
    private lazy var cxProvider = {
        return CXProvider(configuration: config)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cxProvider.setDelegate(self, queue: nil)
        
        receiveCall()
        //sendCall()
    }
    
    func receiveCall() {
        let update = CXCallUpdate()
        
        // each user is represented by a cxhandle. this should be unique
        update.remoteHandle = CXHandle(type: .generic, value: "Shuichi")
        
        // Each call is represeted by a uuid
        cxProvider.reportNewIncomingCall(with: UUID(), update: update) { error in
            print(error?.localizedDescription)
        }
    }
    
    func sendCall() {
        let constroller = CXCallController()
        let transaction = CXTransaction(action: CXStartCallAction(call: UUID(), handle: CXHandle(type: .generic, value: "Shuichi")))
        constroller.request(transaction) { error in
            print(error?.localizedDescription)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.cxProvider.reportOutgoingCall(with: constroller.callObserver.calls[0].uuid, connectedAt: nil)
        }
    }
    
    func providerDidReset(_ provider: CXProvider) {
        
    }
    
    // This is called when call receivers reject or hangup a call
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        action.fulfill()
    }
    
    // This is called when call receivers accept a call
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        action.fulfill()
    }
}

