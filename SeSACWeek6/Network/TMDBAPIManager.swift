//
//  TMDBAPIManager.swift
//  SeSACWeek6
//
//  Created by 이병현 on 2022/08/10.
//

import Foundation

import Alamofire
import SwiftyJSON

class TMDBAPIManager {
    
    static let shared = TMDBAPIManager()
    
    private init() { }
    
    let tvList = [
        ("환혼", 135157),
        ("이상한 변호사 우영우", 197067),
        ("인사이더", 135655),
        ("미스터 션사인", 75820),
        ("스카이 캐슬", 84327),
        ("사랑의 불시착", 94796),
        ("이태원 클라스", 96162),
        ("호텔 델루나", 90447)
    ]
    
    let imageURL = "https://image.tmdb.org/t/p/w500"
    
    func callRequest(query: Int, completionHandler: @escaping ([String]) -> ()) {
        print(#function)
        let url = "https://api.themoviedb.org/3/tv/\(query)/season/1?api_key=\(APIKey.tmdb)&language=ko-KR"
        
        //Alamofire -> URLSession Framework -> 비동기로 Request
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                
                //json still_path > [String]
//                var stillArray: [String] = []
//                for list in json["episodes"].arrayValue {
//                    let value = list["still_path"].stringValue
//                    stillArray.append(value)
//                }
                
                // 고차함수를 이용하여 위 코드 변환
                let value = json["episodes"].arrayValue.map { $0["still_path"].stringValue }
                
                dump(value) // print vs dump
                
                completionHandler(value)
                                
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
    func requestImage(completionHandler: @escaping ([[String]]) -> ()) {
        
        var posterList: [[String]] = []
        
        //나~~~~중에 배울 것: async/await(iOS13 이상)
        TMDBAPIManager.shared.callRequest(query: tvList[0].1) { value in
            posterList.append(value)

            TMDBAPIManager.shared.callRequest(query: self.tvList[1].1) { value in
                posterList.append(value)

                TMDBAPIManager.shared.callRequest(query: self.tvList[2].1) { value in
                    posterList.append(value)
                   
                    TMDBAPIManager.shared.callRequest(query: self.tvList[3].1) { value in
                        posterList.append(value)
                     
                        TMDBAPIManager.shared.callRequest(query: self.tvList[4].1) { value in
                            posterList.append(value)
                           
                            TMDBAPIManager.shared.callRequest(query: self.tvList[5].1) { value in
                                posterList.append(value)
                                
                                TMDBAPIManager.shared.callRequest(query: self.tvList[6].1) { value in
                                    posterList.append(value)
                                    
                                    TMDBAPIManager.shared.callRequest(query: self.tvList[7].1) { value in
                                        posterList.append(value)
                                        completionHandler(posterList)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func requeestEpisodeImage() {
        
        //어떤 문제가 생길 수 있을까요?
        //1.순서 보장 X, 2. 언제 끝날 지 모름 3. Limit (ex: 1초 5번 Block) -> 다음주에 해결해보자!
//        for item in tvList {
//            TMDBAPIManager.shared.callRequest(query: item.1) { stillPath in
//                print(stillPath)
//            }
//        }
        
    }
}
