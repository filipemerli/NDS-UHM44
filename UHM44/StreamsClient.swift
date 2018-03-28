//
//  StreamsClient.swift
//  UHM44
//
//  Created by Filipe Merli on 26/03/18.
//  Copyright © 2018 Filipe Merli. All rights reserved.
//

import UIKit

protocol StreamsClientDelegate: class {
    func receivedMessage(message: String)
}


class StreamsClient: NSObject {
    
    var delegate: StreamsClientDelegate?
    
    var inputStream: InputStream!
    var outputStream: OutputStream!
    
    var feedback:[String] = [""]
    
    let maxReadLength = 1024
    
    func CloseConnection() {
        inputStream.close()
        outputStream.close()
    }
    
    func setupNetworkCommunication() {
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, "\(Constants.shared.ipAdress)" as CFString, 23, &readStream, &writeStream)
        
        inputStream = readStream!.takeRetainedValue()
        outputStream = writeStream!.takeRetainedValue()
        
        inputStream.delegate = self
        
        inputStream.schedule(in: .current, forMode: .commonModes)
        outputStream.schedule(in: .current, forMode: .commonModes)
        
        inputStream.open()
        outputStream.open()
    }
    
    func sendMessage(message: String) {
        let data = "\(message)".data(using: .ascii)!
        
        _ = data.withUnsafeBytes { outputStream.write($0, maxLength: data.count) }
    }
    
}

extension StreamsClient: StreamDelegate {
    
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case Stream.Event.openCompleted:
            delegate?.receivedMessage(message: "Conectou")
        case Stream.Event.hasBytesAvailable:
            readAvailableBytes(stream: aStream as! InputStream)
        case Stream.Event.endEncountered:
            debugPrint("new message received ON EVENT")
        case Stream.Event.errorOccurred:
            debugPrint("error occurred")
        case Stream.Event.hasSpaceAvailable:
            debugPrint("has space available")
        default:
            debugPrint("some other event...")
            break
        }
    }
    
    private func readAvailableBytes(stream: InputStream) {
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: maxReadLength)
        
        while stream.hasBytesAvailable {
            let numberOfBytesRead = inputStream.read(buffer, maxLength: maxReadLength)

            if numberOfBytesRead < 0 {
                if let _ = stream.streamError {
                    break
                }
            }
            if let message = processedMessageString(buffer: buffer, length: numberOfBytesRead) {
                delegate?.receivedMessage(message: message)
            }
            
        }
        
    }
    
    private func processedMessageString(buffer: UnsafeMutablePointer<UInt8>, length: Int) -> String? {
        guard let stringReceived = String(bytesNoCopy: buffer, length: length, encoding: .ascii, freeWhenDone: true) else {
            return nil
        }
        if stringReceived == "\r" {
            var newFeedback = ""
            for newString in feedback {
                newFeedback += newString
            }
            feedback.removeAll()
            return newFeedback
        }else {
            feedback.append(stringReceived)
            return nil
        }
    }
    
    
}


