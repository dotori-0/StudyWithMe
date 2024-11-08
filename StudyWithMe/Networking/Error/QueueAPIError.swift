//
//  QueueAPIError.swift
//  SeSACStudy
//
//  Created by SC on 2023/01/05.
//

import Foundation

/// fetchNearbyUsers, rate
enum QueueAPIError: Int, Error {
    case success = 200
    case firebaseTokenError = 401
    case unregisteredUser = 406
    case serverError = 500
    case clientError = 501
    
    enum Find: Int, Error {
        case reportedMoreThanThreeTimes = 201
        case cancelPenaltyLevelOne = 203
        case cancelPenaltyLevelTwo
        case cancelPenaltyLevelThree
    }
    
    enum MyQueueState: Int, Error {
        case defaultState = 201
    }
    
    enum RequestStudy: Int, Error {
        case alreadyRequestedByTheOther = 201
        case theOtherStopped
    }
    
    enum SendChat: Int, Error {
        case cannotSendChat = 201  // 상대방에게 채팅을 보낼 수 없는, 일반 상태
    }
}

extension QueueAPIError: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .success:
                return "성공"
            case .firebaseTokenError:
                return "Firebase Token Error"
            case .unregisteredUser:
                return "미가입 유저"
            case .serverError:
                return "서버 에러가 발생했습니다.\n"
            case .clientError:
                return "Client Error"
        }
    }
}
