//
//  ContentView.swift
//  BucketList
//

import SwiftUI


struct Message: Codable, Identifiable {
    var id = UUID()
    let text: String
}

struct ContentView: View {
    @State private var loadedMessage: Message? = nil
    
    var body: some View {
        
        Button("Read and Write") {
            let newMessage = Message(text: "Test Message")
            FileManager().saveText(newMessage, fileName: "message.json")
        }
        Button("Load") {
            if let loaded: Message =  FileManager().loadText(fileName: "message.json") {
                loadedMessage = loaded
            }
        }
    }
    
    
    
}

extension FileManager {
    func saveText<T:Codable>(_ object: T, fileName: String) {
        
        do {
            let dirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            let fileURL = dirURL!.appendingPathComponent(fileName)
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonValue = try encoder.encode(object)
            try jsonValue.write(to: fileURL, options: [.atomic, .completeFileProtection])
        } catch {
            print(error)
        }
        
        
    }
    
    func loadText<T:Codable>(fileName: String) -> T? {
        do {
            let dirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            let fileURL = dirURL!.appendingPathComponent("message.json")
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let decodedData =  try decoder.decode(T.self, from: data)
            return decodedData
        } catch {
            print(error)
            return nil
        }
        
    }
    
}
#Preview {
    ContentView()
    }
