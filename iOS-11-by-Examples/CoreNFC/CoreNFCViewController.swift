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
        cell.textLabel?.text = record.fullDescription
        print(record.fullDescription)
        
        return cell
    }
}

extension NFCNDEFPayload {
    
    var fullDescription: String {
        var description = "TNF (TypeNameFormat): \(dataDescription)\n"
        
        let payload = String(data: self.payload, encoding: .utf8) ?? "No payload"
        let type = String(data: self.type, encoding: .utf8) ?? "No type"
        let identifier = String(data: self.identifier, encoding: .utf8) ?? "No identifier"
        
        description += "Payload: \(payload)\n"
        description += "Type: \(type)\n"
        description += "Identifier: \(identifier)\n"
        
        return description.replacingOccurrences(of: "\0", with: "")
    }
    
    var dataDescription: String {
        switch typeNameFormat {
        case .nfcWellKnown:
            if let type = String(data: type, encoding: .utf8) {
                return "NFC Well Known type: " + type
            }
            return "Invalid data"
        case .absoluteURI:
            return String(data: payload, encoding: .utf8) ?? "Invalid data"
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
        case .empty:
            return "Invalid data"
        }
    }
}
