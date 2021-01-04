//
//  Audio.swift
//  Smoker
//
//  Created by Nicole on 1/4/21.
//

import Foundation
import SmartDeviceLink

class Audio {
    class var audioFileName: String {
        return "fox_dog"
    }

    class var soundFileURL: URL {
        let soundFileName = audioFileName
        let soundFileFormat = "mp3"
        let filePath = Bundle.main.path(forResource: soundFileName, ofType: soundFileFormat)
        return URL(fileURLWithPath: filePath ??  "")
    }
}
