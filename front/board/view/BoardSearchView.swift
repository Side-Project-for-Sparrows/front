import SwiftUI

struct BoardSearchView: View {
    @StateObject private var viewModel = BoardSearchViewModel()
    @State private var keyword: String = ""
    @State private var enterCodes: [Int: String] = [:] // boardId: enterCode

    var body: some View {
        NavigationView {
            VStack {
                TextField("게시판 이름 검색", text: $keyword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onSubmit {
                        viewModel.search(keyword: keyword)
                    }

                if viewModel.isLoading {
                    ProgressView("검색 중...")
                } else if let error = viewModel.error {
                    Text("에러: \(error)")
                        .foregroundColor(.red)
                } else {
                    List(viewModel.results, id: \.boardId) { board in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(board.name)
                                .font(.headline)
                            Text(board.description)
                                .font(.subheadline)
                                .foregroundColor(.gray)

                            if board.isPublic {
                                Button("가입 요청") {
                                    viewModel.requestJoin(board: board, enterCode: nil)
                                }
                                .buttonStyle(.bordered)
                            } else {
                                HStack {
                                    TextField("엔터코드 입력", text: Binding(
                                        get: { enterCodes[board.boardId] ?? "" },
                                        set: { enterCodes[board.boardId] = $0 }
                                    ))
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(width: 150)

                                    Button("가입 요청") {
                                        let code = enterCodes[board.boardId] ?? ""
                                        viewModel.requestJoin(board: board, enterCode: code)
                                    }
                                    .buttonStyle(.bordered)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("게시판 탐색")
        }
    }
}
