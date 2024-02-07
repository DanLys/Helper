//
//  SoundEffect.swift
//  Helper
//
//  Created by Danil Lyskin on 04.12.2023.
//

import AudioToolbox

func getSystemSoundFileEnumerator() -> FileManager.DirectoryEnumerator? {
    guard let libraryDirectory = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .systemDomainMask, true).first,
          let soundsDirectory = NSURL(string: libraryDirectory)?.appendingPathComponent("Sounds"),
          let soundFileEnumerator = FileManager.default.enumerator(at: soundsDirectory, includingPropertiesForKeys: nil) else { return nil }
    return soundFileEnumerator
}


struct SoundEffect: Hashable {
    let id: SystemSoundID
    let name: String

    func play() {
        AudioServicesPlaySystemSoundWithCompletion(id, nil)
    }
}

extension SoundEffect {
    static let systemSoundEffect: SoundEffect? = {
        guard let systemSoundFiles = getSystemSoundFileEnumerator() else { return nil }
        
        let sounds: [SoundEffect] = systemSoundFiles.compactMap { item in
            guard let url = item as? URL,
                    let name = url.deletingPathExtension().pathComponents.last else { return nil }
            var soundId: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(url as CFURL, &soundId)
            return soundId > 0 ? SoundEffect(id: soundId, name: name) : nil
        }.sorted(by: { $0.name.compare($1.name) == .orderedAscending })
        
        return SoundEffect(id: sounds[10].id, name: sounds[10].name)
    }()
}

