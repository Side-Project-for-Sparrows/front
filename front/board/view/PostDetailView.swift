import SwiftUI

struct PostDetailView: View {
    let post: PostDetailDto

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(post.title).font(.title).bold()
                Text(post.content)

                ForEach(post.postImageDetailDtos, id: \.key) { image in
                    RemoteImageView(imageKey: image.key)
                }

                Text("댓글").font(.headline)
                ForEach(post.commentDetailDtos, id: \.id) { comment in
                    Text(comment.content)
                }
            }
            .padding()
        }
    }
}

