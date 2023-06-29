import Foundation
import Firebase

class NotesRepository: ObservableObject {
    private let db = Firestore.firestore()
    
    @Published
    var notes: [Note] = []
    
    init(){
        loadAllNotes()
    }
    
    
    func newNote(title: String, date: Date, body: String) {
        db.collection("notes").addDocument(data: [
            "title": title,
            "date": date,
            "body": body
        ])
        loadAllNotes()
    }
    
    
    func updateNote(id: String, title: String, date: Date, body: String) {
        db.collection("notes").document(id).updateData([
            "title": title,
            "date": date,
            "body": body
        ]) {( error ) in
            if error != nil {
                print("Error.")
            } else {
                print("Updated.")
            }
        }
        loadAllNotes()
    }
    
    
    func removeNote(at index: Int) {
        let noteToDelete = notes[index]
        db.collection("notes").document(noteToDelete.id).delete()
        loadAllNotes()
    }
    
    
    private func loadAllNotes() {
        db.collection("notes").getDocuments{(snapshot, error) in
            if let error = error {
                print(error)
                return
            }
            guard let documents = snapshot?.documents else {
                return
            }
            self.notes = documents.compactMap{
                document in let data = document.data()
                guard let title = data["title"] as? String,
                      let timestamp = data["date"] as? Timestamp,
                      let body = data["body"] as? String
                else {
                    return nil
                }
                return Note(id: document.documentID,
                            title: title,
                            date: timestamp.dateValue(),
                            body: body)
            }
        }
    }
    
}
