//
//  AlbumsTableViewCell.swift
//  Music
//
//  Created by Леонид Шелудько on 18.01.2023.
//

import UIKit

class AlbumsTableViewCell: UITableViewCell {
    
    private let albumLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name album name"
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name artist name"
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let trackCountLabel: UILabel = {
        let label = UILabel()
        label.text = "16 tracks"
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var stackView = UIStackView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        albumLogo.layer.cornerRadius = albumLogo.frame.width / 2
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.backgroundColor = .clear //прозрачный бекграуед у ячейки, можно и белый поставить
        self.selectionStyle = .none   //нет выделения
        
        stackView = UIStackView(arrangedSubviews: [artistNameLabel, trackCountLabel],
                                axis: .horizontal,
                                spacing: 10,
                                distribution: .equalCentering)
        
        self.addSubview(albumLogo)
        self.addSubview(albumNameLabel)
        self.addSubview(stackView)
    }
    
    func configureAlbumCell(album: Album) {
        
        //Картинку получаем из интернета
        if let urlString = album.artworkUrl100 {                                                  //1. Проверим есть ли ссылка
            NetworkRequest.shared.reguestData(urlString: urlString) { [weak self] result in       //2. Если да, отпралвяем запрос
                switch result {                                                                   //3. У result есть 2 состояния
                case .success(let data):                                                          //4. Еслии все ОК
                    let image = UIImage(data: data)                                               //5. Присваем картинку
                    self?.albumLogo.image = image                                                 //6. Присваем картинку
                case .failure(let error):                                                         //7. Еслм пришла ошибка
                    self?.albumLogo.image = nil                                                   //8. Говорим что картинки не будет ( = nil )
                    print("No albom logo" + error.localizedDescription)                           // Тут можно вывести что картинка не нашлась
                }
            }
        } else {                                                                                  //9. (п.1) Если ссылки вообще не было
            albumLogo.image = nil                                                                 //10. Говорим что картинки не будет ( = nil )
        }
        
        albumNameLabel.text = album.collectionName
        artistNameLabel.text = album.artistName
        trackCountLabel.text = "\(album.trackCount) tracks"
    }
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            albumLogo.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            albumLogo.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            albumLogo.heightAnchor.constraint(equalToConstant: 60),
            albumLogo.widthAnchor.constraint(equalToConstant: 60)
        ])
        
        NSLayoutConstraint.activate([
            albumNameLabel.leadingAnchor.constraint(equalTo: albumLogo.trailingAnchor, constant: 10),
            albumNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            albumNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: albumLogo.trailingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            stackView.topAnchor.constraint(equalTo: albumNameLabel.bottomAnchor, constant: 10)
        ])
    }

}
