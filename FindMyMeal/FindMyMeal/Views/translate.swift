//
//  translate.swift
//  FindMyMeal
//
//  Created by Tanner Macpherson on 6/18/24.
//

import SwiftUI

struct translate: View {
    @State private var userNotes: String = ""
    @State private var notesList: [String] = []

    var body: some View {
        VStack {
            HStack {
                TextEditor(text: $userNotes)
                Button {
                    notesList.append(userNotes)
                    userNotes = ""
                }label: {
                    Text("Add note")
                }
            }
            List {
                HStack {
                    ForEach($userNotes) note in {
                        Text(note)
                    }
                    Button {
                        userNotes.remove(note)
                    } label: {
                        Text("Remove")
                    }
                }
            }
        }
    }
}

//#Preview {
//    translate()
//}
