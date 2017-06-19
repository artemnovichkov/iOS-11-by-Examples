//
//  CoreNFCViewController.swift
//  iOS-11-by-Examples
//
//  Created by Artem Novichkov on 18/06/2017.
//  Copyright © 2017 Artem Novichkov. All rights reserved.
//

import UIKit
import CoreNFC

class CoreNFCViewController: UITableViewController {
    
    var payloads = [NFCNDEFPayload]()
    var session: NFCNDEFReaderSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Actions
    
    @IBAction func scanAction(_ sender: Any) {
        session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        session?.begin()
    }
}

extension CoreNFCViewController: NFCNDEFReaderSessionDelegate {
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        guard let readerError = error as? NFCReaderError else {
            return
        }
        switch readerError.code {
        case .readerSessionInvalidationErrorFirstNDEFTagRead, .readerSessionInvalidationErrorUserCanceled:
            break
        default:
            DispatchQueue.main.async {
                self.presentAlertController(withTitle: "Session Invalidated",
                                            message: error.localizedDescription)
            }
        }
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        if let message = messages.first {
            payloads = message.records
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        //https://github.com/hansemannn/iOS11-NFC-Example#getting-started
        
        for message in messages {
            print(" - \(message.records.count) Records:")
            for record in message.records {
                print("\t- TNF (TypeNameFormat): \(record.dataDescription))")
                print("\t- Payload: \(String(data: record.payload, encoding: .utf8)!)")
                print("\t- Type: \(record.type)")
                print("\t- Identifier: \(record.identifier)\n")
            }
        }
    }
}

extension CoreNFCViewController {
    
    // MARK: UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payloads.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let record = payloads[indexPath.row]
        cell.textLabel?.text = record.dataDescription
        
        return cell
    }
}

extension NFCNDEFPayload {
    
    var dataDescription: String {
        switch typeNameFormat {
        case .nfcWellKnown:
            if let type = String(data: type, encoding: .utf8) {
                return "NFC Well Known type: " + type
            }
            return "Invalid data"
        case .absoluteURI:
            if let text = String(data: payload, encoding: .utf8) {
                return text
            }
            return "Invalid data"
        case .media:
            if let type = String(data: type, encoding: .utf8) {
                return "Media type: " + type
            }
            return "Invalid data"
        case .nfcExternal:
            return "NFC External type"
        case .unknown:
            return "Unknown type"
        case .unchanged:
            return "Unchanged type"
        default:
            return "Invalid data"
        }
    }
}
