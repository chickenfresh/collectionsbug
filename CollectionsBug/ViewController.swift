//
//  ViewController.swift
//  CollectionsBug
//
//  Created by vladislav on 19.08.2020.
//  Copyright © 2020 test. All rights reserved.
//

import UIKit
import EasyPeasy


class ViewController: UIViewController {
    let tableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        
        tableView.register(TableCell.self, forCellReuseIdentifier: TableCell.id)
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        tableView.easy.layout([Bottom(0).to(view.safeAreaLayoutGuide, .bottom),Top().to(view.safeAreaLayoutGuide, .top),Left(0),Right(0)])
        tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }


}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.id, for: indexPath as IndexPath) as! TableCell
        let basicFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/2.5)
        if indexPath.row == 1 {
            cell.setupView(view: BottomCell(frame: basicFrame))
        } else {
            let lbl = UILabel(frame: basicFrame)
            cell.addSubview(lbl)
            lbl.easy.layout([Edges()])
            lbl.text = "Focus on lower cell with black rectangles\n\nRepeat these steps:\n\n1) Check approx num of rectangles on cell with blue background\n2) Swipe left on lower cell. You'll see cyan background and 2 items. \n3) Swipe back and scroll down. You'll see that the num of visible items is to equal from previous step, that's a bug"
            lbl.textAlignment = .center
            lbl.numberOfLines = 0
            lbl.lineBreakMode = .byWordWrapping
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height/2.5
    }
}

class TableCell: UITableViewCell {
    public static let id = "tableCell"
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .systemYellow
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(view: UIView){
        addSubview(view)
        view.easy.layout([Edges()])
    }
}

class BottomCell: UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: frame, collectionViewLayout: UICollectionViewFlowLayout())
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    func setupCollectionView(){
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        collectionView.backgroundColor = .white
        
        collectionView.register(HorizontalViewCell.self, forCellWithReuseIdentifier: HorizontalViewCell.id)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        addSubview(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HorizontalViewCell.id, for: indexPath) as! HorizontalViewCell
        cell.backgroundColor = indexPath.row == 0 ? .systemBlue : .cyan
        cell.numberOfItems = indexPath.row == 0 ? 10 : 2
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: frame.height)
    }
}


class HorizontalViewCell: UICollectionViewCell, UICollectionViewDataSource {
    static let id = "horizontalViewCellId"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.register(BoxCell.self, forCellWithReuseIdentifier: BoxCell.id)
        collectionView.easy.layout([Edges()])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static let space: CGFloat = 12
    static let horizontalItemsCount: CGFloat = 3
    static let itemSize: CGSize = {
        let ratio: CGFloat = 0.5625
        let spaceCount = horizontalItemsCount + CGFloat(1)
        let itemWidth = ((UIScreen.main.bounds.width - spaceCount*space)/horizontalItemsCount).rounded(.down)
        let itemHeight = itemWidth/ratio
        return CGSize(width: itemWidth, height: itemHeight)
    }()
    static let layout = UICollectionViewFlowLayout()
    var numberOfItems: Int!
    let collectionView: UICollectionView = {
        layout.itemSize = itemSize
        layout.minimumLineSpacing = space
        layout.minimumInteritemSpacing = space
        layout.sectionInset = UIEdgeInsets(top: 9, left: space, bottom: 0, right: space)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // MARK: On right swipe to second HorizontalViewCell, also sets the same numberOfItemsInSection for first cell
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BoxCell.id, for: indexPath) as! BoxCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return HorizontalViewCell.space
    }
}

class BoxCell: UICollectionViewCell {
    static let id = "boxCellId"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private final func setupViews(){
        backgroundColor = .black
        layer.cornerRadius = 12
        self.clipsToBounds = true
    }
}
