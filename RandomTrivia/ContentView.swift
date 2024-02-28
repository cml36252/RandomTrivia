//
//  ContentView.swift
//  RAndom Trivia
//
//  Created by NMI Class on 2/26/24.
//

import SwiftUI
import Foundation
import Combine

struct ContentView: View {
    @ObservedObject var studentInfo = GetData()
    var body: some View {
        List(studentInfo.students) {
            student in
            
            VStack(alignment: .leading) {
                Text(student.question.text)
                    .font(.largeTitle)
                
            }
        }
    }
}
public class GetData: ObservableObject {
    
    @Published var students = [trivial]()
    init(){
        load()
    }
    func load() {
        let dataUrl = URL(string: "https://the-trivia-api.com/v2/questions/")!
        let decoder = JSONDecoder()
        URLSession.shared.dataTask(with: dataUrl) {(data,response,error) in
            do {
                if let d = data {
                    let decodedLists = try decoder.decode([trivial].self, from: d)
                    DispatchQueue.main.async {
                        self.students = decodedLists
                    }
                } else {
                    print ("No Data")
                }
            } catch {
                print("error")
            }
            
        }.resume()
    }
}

struct trivial: Codable, Identifiable {
    public var id: String
    let category, correctAnswer: String
    let incorrectAnswers: [String]
    let question: Question
    let tags: [String]
    let type, difficulty: String

}
struct Question: Codable {
   let text: String
}

#Preview {
    ContentView()
}
