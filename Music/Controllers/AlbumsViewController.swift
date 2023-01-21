//
//  AlbumsViewController.swift
//  searchMusic
//
//  Created by Леонид Шелудько on 18.01.2023.
//

import UIKit

class AlbumsViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.register(AlbumsTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    var albums = [Album]()
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupDelegate()
        setNavigationBar()
        setupSearchController()
        setConstraints()

    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(tableView)
    }
    
    private func setupDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
        
        searchController.searchBar.delegate = self
    }
    
    private func setNavigationBar() {
        navigationItem.title = "Albums"
        
        navigationItem.searchController = searchController
        
        let userInfoButton = createCustomButton(selector: #selector(userInfoButtonTapped))
        navigationItem.rightBarButtonItem = userInfoButton
    }
    
    private func setupSearchController() {
        searchController.searchBar.placeholder = "Search"
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    @objc private func userInfoButtonTapped() {
        let userInfoViewController = UserInfoViewController()
        navigationController?.pushViewController(userInfoViewController, animated: true)
    }
    
    //MARK: - Network
    private func fetchAlbums(albumName: String) {
        //Куда обрщаемся + ищем по названию альбома
        let urlString = "https://itunes.apple.com/search?term=\(albumName)&entity=album&attribute=albumTerm"
        //Делаем запрос
        NetworkDataFetch.share.fetchAlbum(urlString: urlString) { [weak self] albumModel, error in
            //Если ошибок нет
            if error == nil {
                guard let albumModel = albumModel else { return }
                //Случай когда мы ввели какие то символы но ничего не нашли
                
                //albumModel.results - массив в котором лежат найденные альбомы
                //Если все ок - ищем песни, иначе выведем предупреждение
                if albumModel.results != [] {
                    
                    //Нужно расположить альбомы по алфавиту
                    let sortedAlbums = albumModel.results.sorted { firstItem, secondItem in
                        //      каждый первый item     сравниваем    со вторым                                по возрстанию
                        return firstItem.collectionName.compare(secondItem.collectionName) == ComparisonResult.orderedSame
                    }
                    //присвоим отсортированный альбом
                    self?.albums = sortedAlbums
                    self?.tableView.reloadData() //Каждый раз когда получаем данные обновляем таблицу
                    
                } else {
                    //Если что то ввели но без результата выведем предупреждение
                    //Вызовем предупреждние что ничего не нашлось
                    
                    self?.alertOk(title: "Error", message: "Альбои не найден")
                }
                
               
            } else {
                print(error!.localizedDescription)
            }
        }
    }

}

//MARK: - UITableViewDataSource

extension AlbumsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AlbumsTableViewCell
        let albom = albums[indexPath.row] //Проходимся по всем данным
        cell.configureAlbumCell(album: albom) //Подствляем данные в ячейки
        return cell
    }
}

//MARK: - UITableViewDelegate

extension AlbumsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailAlbumViewController = DetailAlbumViewController()
        let album = albums[indexPath.row]
        detailAlbumViewController.album = album
        detailAlbumViewController.title = album.artistName
        navigationController?.pushViewController(detailAlbumViewController, animated: true)
    }
}

//MARK: - UISearchBarDelegate

extension AlbumsViewController: UISearchBarDelegate {
    //отслеживает какой текст вводим
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        //Исправим проблему: не ищется на русском
        let text = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        if text != "" {
            timer?.invalidate()
            //Делаем запрос через каждые пол секунды после того как пользовтель ввел букву
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] _ in
                self?.fetchAlbums(albumName: text!)
            })
            
            
        }
    }
}

//MARK: - SetConstraints

extension AlbumsViewController {
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
}
