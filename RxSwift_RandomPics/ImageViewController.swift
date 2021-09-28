//
//  ImageViewController.swift
//  RxSwift_RandomPics
//
//  Created by 黃瀞萱 on 2021/9/28.
//

import UIKit
import RxCocoa
import RxSwift
import RxOptional

class ImageViewController: UIViewController {
    
    private let dogImage = UIImageView()
    private let loadingView = UIActivityIndicatorView(style: .large)
    private let randomButton = UIButton()
    private let provider = ImageProvider()
    private let bag = DisposeBag()
}

extension ImageViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubViews()
        buttonTapped()
        
        loadingView.hidesWhenStopped = true
    }
    
    private func configureSubViews() {
        [dogImage, loadingView, randomButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        [dogImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
         dogImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
         dogImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
         dogImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 2/3),
         
         loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
         loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         
         randomButton.topAnchor.constraint(equalTo: dogImage.bottomAnchor, constant: 30),
         randomButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ].forEach{ $0.isActive = true }
        
        dogImage.contentMode = .scaleAspectFit
        dogImage.backgroundColor = .black
        
        randomButton.setTitle("Random!", for: .normal)
        randomButton.setTitleColor(.black, for: .normal)
        randomButton.contentHorizontalAlignment = .center
    }
}
// MARK: -Call Api
extension ImageViewController {
    
    func fetchImage() {
        provider.getRandomImage { [weak self] result in
            switch result {
            case .success(let url):
                self?.downloadImage(url: url)
            case .failure(let error):
                print("fetch error \(error)")
            }
        }
    }
    
    func downloadImage(url: URL) {
        
        provider.downloadImage(url: url) { [weak self] result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self?.loadingView.stopAnimating()
                    self?.dogImage.image = image
                }
            case .failure(let error):
                print("download error \(error)")
            }
        }
    }
}

extension ImageViewController {
    
    func buttonTapped() {
        randomButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.loadingView.startAnimating()
                self?.fetchImage()
            })
            .disposed(by: bag)
    }
}
