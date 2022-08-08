//
//  Endpoint.swift
//  SeSACWeek6
//
//  Created by 이병현 on 2022/08/08.
//

import Foundation
//enum애서 저장프로퍼티는 못 쓰고 연산 프로퍼티는 사용할 수 있는 이유? : 메서드처럼 작용하기 때문에
enum Endpoint {
    case blog
    case cafe
    
    var requestURL: String {
        switch self {
        case .blog:
            return URL.makeEndPointString("blog?query=")
        case.cafe:
            return URL.makeEndPointString("cafe?query=")
        }
    }
}
