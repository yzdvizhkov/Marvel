//
//  RefreshControlService.swift
//  Marvel
//
//  Created by Юрій Здвіжков on 12.06.2023.
//

import Firebase
import Foundation

class RemoteConfigService {
    private let remoteConfig = RemoteConfig.remoteConfig()
    var testFeatureFlag: Bool = false

    func fetchRCValues() {
        let defaults: [String: NSObject] = ["test_feature_flag": false as NSObject]
        remoteConfig.setDefaults(defaults)
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        remoteConfig.fetch(withExpirationDuration: 0, completionHandler: { status, error in
            if status == .success, error == nil {
                self.remoteConfig.activate(completion: { _, error in
                    guard error == nil else {
                        return
                    }
                    let value = self.remoteConfig.configValue(forKey: "test_feature_flag").boolValue
                    self.testFeatureFlag = value
                    print("Fetched value \(value)")
                })
            } else {
                print("Something went wrong")
            }
        })
    }
}
