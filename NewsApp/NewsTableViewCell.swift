//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by Andres Liu on 8/6/21.
//

import UIKit

class NewsTableViewCellViewModel {
    let title: String
    let subtitle: String
    let imageURL: URL?
    var imageData: Data? = nil
    
    init(title: String, subtitle: String, imageURL: URL?){
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
    }
}

class NewsTableViewCell: UITableViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .light)
        label.numberOfLines = 0
        return label
    }()
    
    private let newsImageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .systemRed
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 5
        return image
    }()
    
    static let identifier = "NewsTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(newsImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame = CGRect(x: 10,
                                  y: 0,
                                  width: contentView.frame.size.width - 170,
                                  height: 70)
        
        subtitleLabel.frame = CGRect(x: 10,
                                  y: 70,
                                  width: contentView.frame.size.width - 170,
                                  height: contentView.frame.size.height / 2)
        
        newsImageView.frame = CGRect(x: contentView.frame.size.width - 160,
                                     y: 5,
                                     width: 140,
                                     height: contentView.frame.size.height - 10)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        subtitleLabel.text = nil
        newsImageView.image = nil
    }
    
    public func configure(with model: NewsTableViewCellViewModel) {
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
        
        if let data = model.imageData {
            newsImageView.image = UIImage(data: data)
        }
        else {
            guard let url = model.imageURL else { return }
            
            URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                
                guard let data = data, error == nil else { return }
                
                model.imageData = data
                
                DispatchQueue.main.async {
                    self?.newsImageView.image = UIImage(data: data)
                }
                
            }.resume()
        }
        
    }

}
