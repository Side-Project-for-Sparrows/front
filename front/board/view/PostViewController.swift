//
//  LoginViewController.swift
//  front
//
//  Created by 정예은 on 6/14/25.
//

import UIKit

class PostViewController: UIViewController {

    @IBOutlet var nickname: UILabel!
    @IBOutlet var profile: UIImageView!
    @IBOutlet var createdAt: UILabel!
    @IBOutlet var postTitle: UILabel!
    @IBOutlet var content: UITextView!
    @IBOutlet var viewCount: UILabel!
    @IBOutlet var likeCount: UILabel!

    private let viewModel = PostViewModel()
    
    override func viewDidLoad() {        
        super.viewDidLoad()
        bindViewModel()

        viewModel.searchPost(postId: 4)
    }

    private func bindViewModel() {
        viewModel.onSearchPostSuccess = { [weak self] post in
            // TODO: 토큰 저장 및 화면 전환
        
            self?.nickname.text = post.nickname
            
            self?.createdAt.text = post.createdAt
            
            self?.postTitle.text = post.title
            self?.content.text = post.content
            
            self?.viewCount.text = String(post.views)
            self?.likeCount.text = String(post.likes)
            
            print(" 성공: 게시글 제목 - \(post.title)")
        }

        viewModel.onSearchPostImageSuccess = { [weak self] postImage in
            self?.profile.image = postImage
        }
        
        viewModel.onSearchPostFailure = { error in
            print(error)
        }
    }
}

