//
//  ClosureViewController.swift
//  SeSACWeek6
//
//  Created by 이병현 on 2022/08/08.
//

import UIKit

class ClosureViewController: UIViewController {
    
    @IBOutlet weak var purpleView: UIView!
    //Frame Based
    var sampleButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //위치, 크기, 추가
        /*
         오토리사이징을 오토레이아웃 제약조건처럼 설정해주는 기능이 내부적으로 구현되어 있음.
         이 기능은 디폴트가 true, 하지만 오토레이아웃을 지정해주면 오토리사이징을 안쓰겠다는 의미인 false로 상태가 내부적으로 변경됨! 오토리사이징 + 오토레이아웃 = 충돌
         코드 기반 UI > true
         인터페이스 빌더 기반 레이아웃 UI > false
         autoresizing -> autolayout constraints
         */
        print(purpleView.translatesAutoresizingMaskIntoConstraints)
        print(sampleButton.translatesAutoresizingMaskIntoConstraints)
        print(cardView.translatesAutoresizingMaskIntoConstraints)
        sampleButton.frame = CGRect(x: 100, y: 400, width: 100, height: 100)
        sampleButton.backgroundColor = .purple
        view.addSubview(sampleButton)
        
        cardView.posterImageView.backgroundColor = .red
        cardView.likeButton.backgroundColor = .yellow
        cardView.likeButton.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
    }
    
    @objc func likeButtonClicked() {
        print("버튼클릭")
    }
    
    
    @IBOutlet weak var cardView: CardView!
    
    @IBAction func colorPickerButtonClicked(_ sender: UIButton) {
        showAlert(title: "컬러피커", message: "띄우시겠습니까?", okTitle: "띄우기") {
            let picker = UIColorPickerViewController() //UIFontPickerViewController
            self.present(picker, animated: true)
        }
    }
    
    @IBAction func backgroundColorChanged(_ sender: UIButton) {
        showAlert(title: "배경색 변경", message: "배경색을 바꾸시겠습니까", okTitle: "바꾸기") {
            self.view.backgroundColor = .gray
        }
    }
}

extension UIViewController {
    func showAlert(title: String, message: String?, okTitle: String, okAction: @escaping () -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let ok = UIAlertAction(title: okTitle, style: .default) { action in
            
            okAction()
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        
        present(alert, animated: true)
    }
}

