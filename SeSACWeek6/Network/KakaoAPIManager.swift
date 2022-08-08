//
//  KakaoAPIManager.swift
//  SeSACWeek6
//
//  Created by 이병현 on 2022/08/08.
//

import Foundation

import Alamofire
import SwiftyJSON

class KakaoAPIManager {
    static let shared = KakaoAPIManager()
    
    private init() { }
    
    let header: HTTPHeaders = ["Authorization": "KakaoAK \(APIKey.kakao)"]
    func callRequest(type: Endpoint, query: String, completionHandler: @escaping (JSON) -> ()) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let url = type.requestURL + query
        
        //Alamofire -> URLSession Framework -> 비동기로 Request
        AF.request(url, method: .get, headers: header).validate().responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)                
                completionHandler(json)
                                
            case .failure(let error):
                print(error)
                
            }
        }
    }
}
