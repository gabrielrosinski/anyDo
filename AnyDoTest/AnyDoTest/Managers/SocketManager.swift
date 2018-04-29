//
//  SocketManager.swift
//  AnyDoTest
//
//  Created by anydo on 29/04/2018.
//  Copyright © 2018 anydo. All rights reserved.
//

import UIKit
import Starscream
import SwiftyJSON


class SocketManager: NSObject {
    
    static let sharedInstance = SocketManager()
    
    public var socket: WebSocket!
    
    override init() {
        super.init()
        var request = URLRequest(url: URL(string: "ws://superdo-groceries.herokuapp.com/receive")!)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
        
    }
    
    deinit {
        socket.disconnect()
    }
    
    func broadcastSocketData(groceryItem:GroceryItem){

        NotificationCenter.default.post(name: .socketDataRecived, object: nil, userInfo: ["item":groceryItem])
    }

}

extension SocketManager: WebSocketDelegate {

    func websocketDidConnect(socket: WebSocketClient) {
        print("websocket is connected")
    }

    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        if let e = error as? WSError {
            print("websocket is disconnected: \(e.message)")
        } else if let e = error {
            print("websocket is disconnected: \(e.localizedDescription)")
        } else {
            print("websocket disconnected")
        }
    }

    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {

        var json = JSON.init(parseJSON: text)
        if let item = GroceryItem(itemJson: json) {
            broadcastSocketData(groceryItem: item)
        }
        
    }

    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("Received data: \(data.count)")
    }

}

extension Notification.Name {
    static let socketDataRecived = Notification.Name("socketDataRecived")
}



