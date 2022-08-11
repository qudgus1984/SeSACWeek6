//
//  MainViewController.swift
//  SeSACWeek6
//
//  Created by 이병현 on 2022/08/09.
//

import UIKit

import Kingfisher

/*
 tableView - CollectionView > 프로토콜
 tag
 */
/*
 awakeFromNib -> 셀 UI 초기화, 재사용 메커니즘에 의해 일정 횟수 이상 호출되지 않음
 cellForItemAt
 - 재사용 될 때마다 사용자에게 보일 때마다 항상 실행됨.
 - 화면과 데이터는 별개, 모든 indexPath.item에 대한 조건이 없다면 재사용 시 오류가 발생할 수 있음.
 prepareForReuse
 - 셀이 재사용될 때 초기화 하고자 하는 값을 넣으면 오류 해결 가능. 즉 cellForRowAt에서 모든 indexPath.item에 대한 조건을 작성하지 않아도 됨!
 ColletionView in TableView
 - 하나의 컬렉션뷰나 테이블뷰라면 문제X
 - 복합적인 구조라면, 테이블셀도 재사용되어야 하고, 컬렉션셀도 재사용이 되어야 함
 - Index > reloadData
 
 - print, Debug
 */

class MainViewController: UIViewController {
    
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    
    let color: [UIColor] = [.red, .systemPink, .lightGray, .yellow, .black]
    let numberList: [[Int]] = [
        [Int](100...110),
        [Int](55...75),
        [Int](1...9),
        [Int](5001...5009),
        [Int](10...19),
        [Int](21...29),
        [Int](31...39)
    ]
    
    var episodeList: [[String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainTableView.delegate = self
        mainTableView.dataSource = self

        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        bannerCollectionView.register(UINib(nibName: CardCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: CardCollectionViewCell.reuseIdentifier)
        bannerCollectionView.collectionViewLayout = collectionViewLayout()
        bannerCollectionView.isPagingEnabled = true // device width 기준
        
        TMDBAPIManager.shared.requestImage { value in
            dump(value)
            //1. 네트워크 통신 2. 배열 생성 3. 배열 담기 4. 뷰 등에 표현 ex) 테이블 뷰 섹션, 컬렉션 뷰 셀
            // 5. 뷰 갱신!
            self.episodeList = value
            self.mainTableView.reloadData()
        }
        //넷플릭스 인기 컨텐츠 레이블 > 드라마 타이틀로 변경하기
        
        
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return episodeList.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    // 내부 매개변수 tableView를 통해 테이블뷰를 특정
    // 테이블 뷰 객체가 하나일 경우에는 내부 매개변수를 활용하지 않아도 문제가 생기지 않음.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.reuseIdentifier, for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        
        print("MainViewController", #function, indexPath)
        
        cell.backgroundColor = .yellow
        cell.titleLabel.text = TMDBAPIManager.shared.tvList[indexPath.section].0
        cell.contentCollectionView.backgroundColor = .lightGray
        cell.contentCollectionView.delegate = self
        cell.contentCollectionView.dataSource = self
        cell.contentCollectionView.tag = indexPath.section
        cell.contentCollectionView.register(UINib(nibName: CardCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: CardCollectionViewCell.reuseIdentifier)
        cell.contentCollectionView.reloadData() //Index Out of Range 해결
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
}

//하나의 프로토콜, 메서드에서 여러 컬렉션뷰의 delegate, datasource 구현해야 함
// UICollectionViewDelegateFlowLayout - sizeForItemAt - 역동적인 셀
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        <#code#>
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == bannerCollectionView ? color.count : episodeList[collectionView.tag].count
    }

    
    // bannerCollectionView OR 테이블뷰 안에 들어있는 컬렉션뷰
    // 내부 매개변수가 아닌 명확한 아웃렛을 사용할 경우, 셀이 재사용되면 특정 collectionView 세을 재사용하게 될 수 있음
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        print("MainViewController", #function, indexPath)
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionViewCell", for: indexPath) as? CardCollectionViewCell else { return UICollectionViewCell() }
        if collectionView == bannerCollectionView {
            cell.cardView.posterImageView.backgroundColor = color[indexPath.item]
        } else {
            cell.cardView.posterImageView.backgroundColor = .black
            cell.cardView.contentLabel.textColor = .white
            
            let url = URL(string: "\(TMDBAPIManager.shared.imageURL)\(episodeList[collectionView.tag][indexPath.item])")
            cell.cardView.posterImageView.kf.setImage(with: url)
            cell.cardView.contentLabel.text = ""
            
            
            
            //화면과 데이터는 별개, 모든 indexPath.item에 대한 조건이 없다면 재사용 시 오류가 발생할 수 있음.
//            if indexPath.item < 2 {
//                cell.cardView.contentLabel.text = "\(numberList[collectionView.tag][indexPath.item])"
//            }
//            else {
//                cell.cardView.contentLabel.text = "HAPPY"
//            }
            
            
        }
        return cell
    }
    
    func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: bannerCollectionView.frame.height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return layout
    }
}
