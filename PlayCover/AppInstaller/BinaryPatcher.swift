//
//  BinaryPatcher.swift
//  PlayCover
//

import Foundation

class BinaryPatcher {
    
    static let possibleHeaders : [Array<UInt8>] = [
        [202, 254, 186, 190],
        [207, 250, 237, 254]
    ]
    
    static func patchApp(app : URL) throws {
        ulog("Converting app\n")
        if let enumerator = fm.enumerator(at: app, includingPropertiesForKeys: [.isRegularFileKey], options: [.skipsHiddenFiles, .skipsPackageDescendants]) {
            for case let fileURL as URL in enumerator {
                do {
                    let fileAttributes = try fileURL.resourceValues(forKeys:[.isRegularFileKey])
                    if fileAttributes.isRegularFile! {
                        if isMacho(fileUrl: fileURL){
                            try patchBinary(fileUrl: fileURL)
                        }
                    }
                }
            }
        }
    }
    
    private static func isMacho(fileUrl : URL) -> Bool {
        if !fileUrl.pathExtension.isEmpty && fileUrl.pathExtension != "dylib" {
            return false
        }
        if let bts = fileUrl.bytesFromFile(){
            if bts.count > 4{
                let header = bts[...3]
                if header.count == 4{
                    if(possibleHeaders.contains(Array(header))){
                        return true
                    }
                }
            }
        }
        return false
    }
    
    private static func patchBinary(fileUrl : URL) throws {
        ulog("Converting \(fileUrl.lastPathComponent)\n")
        
        if vm.useAlternativeWay {
            try internalWay()
        } else{
            vtoolWay()
        }
        
        sh.codesign(fileUrl)
        
        func vtoolWay(){
            sh.vtoolPatch(fileUrl)
        }
        
        func internalWay() throws {
            convert(fileUrl.path.esc)
            let newUrl = fileUrl.path.appending("_sim")
            try fm.delete(at: fileUrl)
            try fm.moveItem(atPath: newUrl, toPath: fileUrl.path)
        }
        
    }
    
}