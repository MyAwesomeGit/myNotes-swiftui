import SwiftUI

struct NewNote: View {
    @State private var title: String = ""
    @State private var bodyText: String = ""
    
    @Binding var isNewNotePresented: Bool
    var repository = NotesRepository
    
    var body: some View {
        NavigationView{
            VStack(){
                TextField("Title", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .navigationBarTitle("New Note", displayMode: .inline)
            .navigationBarItems(trailing: Button {
                repository.newNote(title: title, date: Date(), body: bodyText)
                
                isNewNotePresented = false
            } label: {
                Image(systemName: "checkmark")
                    .font(.headline)
            }.disabled(title.isEmpty))
            
        }
    }
}
