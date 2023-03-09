//
//  Bundle.swift
//  Dense
//
//  Created by Joseph Pecoraro on 3/2/23.
//  Copyright © 2023 Joseph Pecoraro. All rights reserved.
//

import Foundation

extension Bundle {
    public var appName: String           { getInfo("CFBundleName") ?? "CFBundleName"}
    public var displayName: String       { getInfo("CFBundleDisplayName") ?? "CFBundleName"}
    public var language: String          { getInfo("CFBundleDevelopmentRegion") ?? "CFBundleDevelopmentRegion"}
    public var identifier: String        { getInfo("CFBundleIdentifier") ?? "CFBundleIdentifier"}
    public var copyright: String         { getInfo("NSHumanReadableCopyright")?.replacingOccurrences(of: "\\\\n", with: "\n") ?? "NSHumanReadableCopyright" }
    
    public var appBuild: String          { getInfo("CFBundleVersion") ?? "CFBundleVersion"}
    public var appVersionLong: String    { getInfo("CFBundleShortVersionString") ?? "CFBundleShortVersionString"}
    
    fileprivate func getInfo(_ str: String) -> String? { infoDictionary?[str] as? String }
}
