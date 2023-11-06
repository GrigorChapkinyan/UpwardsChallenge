//
//  Utils.swift
//  upwards-ios-challenge
//
//  Created by Grigor Chapkinyan on 11/3/23.
//

import Foundation
import UIKit.UIImage

// MARK: - Helper Interfaces

/// Protocol to retrieve localized strings for enums with a raw type of "String".
protocol ILocalizableRawRepresentable: RawRepresentable where RawValue == String {
    func localizedString(tableName: String?,
                         bundle: Bundle,
                         value: String,
                         comment: String) -> String
}

/// Default implementation for 'ILocalizableRawRepresentable' protocol.
extension ILocalizableRawRepresentable {
    func localizedString(tableName: String? = nil,
                             bundle: Bundle = Bundle.main,
                             value: String = "",
                             comment: String = "") -> String {
        return NSLocalizedString(self.rawValue, tableName: tableName, bundle: bundle, value: value, comment: comment)
    }
}

struct Utils {
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> ()) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            // always update the UI from the main thread
            DispatchQueue.main.async() {
                completion(UIImage(data: data))
            }
        }
    }

}
