import SwiftUI


struct ContentView: View {
    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    } ()
    
    @ObservedObject
    var repository: NotesRepository = NotesRepository
    
    @State
    var isNewNotePresented = false
    
    var body: some View {
        NavigationView{
            List {
                ForEach(repository.notes) { note in
                    NavigationLink(destination: ShowNote(
                        id: note.id,
                        title: note.title,
                        bodyText: note.body,
                        repository: repository)){
                            VStack (alignment: .leading){
                                Text(note.title).font(.headline)
                                Text("\(note.date, formatter: Self.taskDateFormat)")
                            }
                        }
                }
                .onDelete{ indexSet in
                    if let index = indexSet.first {
                        repository.removeNote(at: index)
                    }
                }
            }
            .navigationBarTitle("myNotes", displayMode: .inline)
            .navigationBarItems(trailing:
                                    Button {
                isNewNotePresented.toggle()
            } label: {
                Image(systemName: "plus").font(.headline)
            })
            .sheet(isPresented: $isNewNotePresented) {
                NewNote(isNewNotePresented:
                            $isNewNotePresented, repository:repository)
            }
        }
    }
}

