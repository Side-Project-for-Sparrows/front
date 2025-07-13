import SwiftUI

/*
struct RemoteImageView: View {
    let imageKey: String

    var body: some View {
        AsyncImage(url: imageURL(for: imageKey)) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
            case .failure(_):
                Image(systemName: "xmark.octagon")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.red)
            @unknown default:
                EmptyView()
            }
        }
        .frame(maxWidth: .infinity)
    }
    private func imageURL(for key: String) -> URL? {
        print("image")
        print(key)
        let urlString = "\(AppConfig.shared.baseURL)/post/image/\(key)"
        print("생성된 URL: \(urlString)")
        return URL(string: "\(AppConfig.shared.baseURL)/post/image/\(key)")
    }
}
*/
import SwiftUI

struct RemoteImageView: View {
    let imageKey: String
    @State private var uiImage: UIImage? = nil
    @State private var error: Error? = nil

    var body: some View {
        Group {
            if let uiImage = uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
            } else if error != nil {
                Image(systemName: "xmark.octagon")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.red)
            } else {
                ProgressView()
            }
        }
        .frame(maxWidth: .infinity)
        .onAppear {
            loadImage()
        }
    }

    private func loadImage() {
        let path = "/post/image/\(imageKey)"
        guard let request = NetworkManager.shared.makeRequest(path: path) else {
            print("❌ 요청 생성 실패")
            return
        }

        NetworkManager.shared.request(request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.error = error
                    print("❌ 이미지 요청 에러: \(error)")
                    return
                }
                guard let data = data, let image = UIImage(data: data) else {
                    self.error = NSError(domain: "InvalidImage", code: -1, userInfo: nil)
                    return
                }
                self.uiImage = image
            }
        }
    }
}

