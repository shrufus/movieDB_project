import UIKit
import Alamofire

class MovieFramesVC: UIViewController, MovieFramesVCProtocol {
    private var tableView: UITableView!         // Таблиця
    internal var movieFrames: [Backdrops] = []
    private let rowHeigth: CGFloat = 240        // Висота блоків в таблиці
    
    /// При ініціалізації передається id фільму для завантаження данних
    init(movieID: Int) {
        super.init(nibName: nil, bundle: nil)
        
        self.fetchMovieFrames(movieId: movieID)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func fetchMovieFrames(movieId: Int) {
        let apiKey = "871ddc96a542d766d2b0fe03fc0ac3d1"
        
        let urlString = "https://api.themoviedb.org/3/movie/\(movieId)/images?api_key=\(apiKey)"
        
        AF.request(urlString).responseDecodable(of: MovieFrames.self) { response in
            switch response.result {
            case .success(let imageResponse):
                self.movieFrames = imageResponse.backdrops!
                self.tableView.reloadData()
            case .failure(let error):
                print("Error fetching movie frames: \(error)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitleNavBar(text: "Photos")
        
        setupTableView()
        setupConstraints()
    }
    
    internal func setupTableView() {
        tableView = UITableView()
        tableView.rowHeight = rowHeigth
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .darkBlue
        tableView.separatorStyle = .none
        tableView.register(FrameCell.self, forCellReuseIdentifier: "FrameCellTest")
        self.view.addSubview(tableView)
    }
    
    internal func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
extension MovieFramesVC: UITableViewDelegate, UITableViewDataSource {
    /// Віставляє кількість блоків в таблиці ( TableView )
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieFrames.count
    }
    
    /// Повертає налаштований блок ( cell )
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FrameCellTest", for: indexPath) as! FrameCell
        let backgroundView = UIView()
        backgroundView.backgroundColor = .darkBlue
        cell.selectedBackgroundView = backgroundView
        let frame = movieFrames[indexPath.row]
        cell.configure(with: frame)
        
        return cell
    }
}
