import SwiftUI
import SwiftData

struct SearchView: View {
    let endDate: Date
    let todo: String
    let importance: Int
    

    @Query private var foundItems: [Item]
    @Environment(\.modelContext) private var modelContext
    
    init(todo: String, endDate: Date, importance: Int) {
        
        self.todo = todo
        self.endDate = endDate
        self.importance = importance
        
        _foundItems = Query(filter: #Predicate<Item> { item in
            if todo == "" {
                return item.endDate <= endDate && item.importance == importance
            } else {
                return item.todo.localizedStandardContains(todo) && item.endDate <= endDate && item.importance == importance
            }
        })
    }
    
    var body: some View {
        VStack {
            if foundItems.isEmpty {
                Text("조건에 해당하는 할 일을 찾을 수 없습니다")
                    .foregroundColor(.gray)
                    .padding()
            } else {
             
                List{
                    ForEach(foundItems) { item in
                        
                        NavigationLink {
                            DetailView(item: item)
                        } label: {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("할 일: \(item.todo)")
                                    .font(.headline)
                                Text("할 일 상세: \(item.todoDetails)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("마감일: \(formatDate(item.endDate))")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                                Text("todoId: \(item.todoId)")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                                Text("중요도: \(item.importance)")
                            }
                        }
                    }
                }
                    .padding(.vertical, 4)
                }
            }
        }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일 HH:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
}
