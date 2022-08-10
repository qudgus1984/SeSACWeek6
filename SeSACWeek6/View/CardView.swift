//
//  CardView.swift
//  SeSACWeek6
//
//  Created by 이병현 on 2022/08/09.
//

import UIKit

/*
 Xml Interface Builder
 1. UIView Custom Class
 2. File's owner > 여러 뷰 활용 어려움 /
 */

/*
 View:
 - 인터페이스 빌더 UI 초기화 구문 : required init?
    - 프로토콜 초기화 구문: required > 초기화 구문이 프로토콜로 명시되어 있음
 - 코드 UI 초기화 구문 : override init
 */

protocol A {
    func example()
    init ()
}

class CardView: UIView {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var contentLabel: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        let view = UINib(nibName: "CardView", bundle: nil).instantiate(withOwner: self).first as! UIView
        view.frame = bounds
        view.backgroundColor = .lightGray
        self.addSubview(view)

        //카드뷰를 인터페이스 빌더 기반으로 만들고, 레이아웃도 설정했는데 왜 false가 아닌 true로 나올까...?
        //xib가 코드형식으로 구현하는 형식이기 때문!
        //true. 오토레이아웃 적용이 되는 관점보다 오토리사이징이 내부적으로 constraints 처리가 됨...
        print(view.translatesAutoresizingMaskIntoConstraints)
    }
    
}
