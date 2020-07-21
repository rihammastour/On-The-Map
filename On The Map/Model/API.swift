//
//  API.swift
//  On The Map
//
//  Created by Riham Mastour on 27/11/1441 AH.
//  Copyright © 1441 Riham Mastour. All rights reserved.
//

import Foundation

class API {
    static let PARSE_HEADER_KEY_APP_ID = "X-Parse-Application-Id"
    static let PARSED_HEADER_KEY_API_KEY = "X-Parse-REST-API-Key"
    static let PARSE_HEADER_VALUE_APP_ID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    static let PARSE_HEADER_VALUE_API_KEY = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    
    
    private static var userInfo = UserInfo()
    private static var sessionId: String?
    
    //MARK: - LOGIN
    static func login (username: String!, password: String!, completion: @escaping(String?)->Void) {
            var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let body = LoginRequest(udacity: Udacity(username: username, password: password))
            request.httpBody =  try! JSONEncoder().encode(body)
        
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data else {
                    completion(error?.localizedDescription)
                    return
                }
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode >= 200  && statusCode < 300 {
                
                    let range = (5..<data.count)
                    let decoder = JSONDecoder()
                    let newData = data.subdata(in: range)
                    do {
                        let responseObject = try decoder.decode(PostSessionResponse.self, from: newData)
                        API.userInfo.key = responseObject.account.key
                        API.sessionId = responseObject.session.id
                        API.getPublicUserData(completion: { err in
                                               
                       })
                        completion(nil)
                    } catch {
                        completion("Failed parsing response")
                    }
                } else {
                    completion("Check your email or password")
                    }
                }else {
                completion("Check your internet connection")
            }
        }
        task.resume()
    }
    
    
    //MARK: - Get User Info
    static func getPublicUserData(completion: @escaping (Error?) -> Void){
        let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/users/\(API.userInfo.key ?? "3903878747")")!)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else {
            completion(error)
            return
          }
        let range = (5..<data.count)
        let newData = data.subdata(in: range) /* subset response data! */

        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            let statusCodeError = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
            completion(statusCodeError)
            return
        }
            let decoder = JSONDecoder()
            if statusCode >= 200 && statusCode < 300 {
                do{
                    let responseObject = try decoder.decode(UserInfoResponse.self, from: newData)
                    let nickname = responseObject.nickname.split(separator: " ")
                    API.userInfo.firstName = String(nickname[0])
                    API.userInfo.lastName = String(nickname[1])
                }catch {
                    debugPrint(error)
                    completion( error)
                    return
                }
                DispatchQueue.main.async {
                    completion( nil)
                }
            }else {
                completion(NSError(domain: "status_code", code: statusCode, userInfo: nil))
            }
        }
   
        task.resume()
    }
    
   
    //MARK: - Get Student Location
    static func getStudentLocation(limit: Int = 100, order: StudentLocationParameters = .updatedAt, completion: @escaping (AllLocations?, Error?) -> Void) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?limit=\(limit)&order=-\(order.rawValue)")!)
            request.httpMethod = "GET"
            request.addValue(API.PARSE_HEADER_KEY_APP_ID, forHTTPHeaderField: API.PARSE_HEADER_VALUE_APP_ID)
            request.addValue(API.PARSE_HEADER_VALUE_APP_ID, forHTTPHeaderField: API.PARSE_HEADER_VALUE_API_KEY)
        
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                var allLocations: AllLocations?
                guard let data = data else {
                    completion(nil, error)
                    return
                }
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                    let statusCodeError = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                    completion(nil, statusCodeError)
                    return
                }
                
                if statusCode >= 200 && statusCode < 300 {
                    do{
                         allLocations = try JSONDecoder().decode(AllLocations.self, from: data)
                    }catch {
                        completion(nil, error)
                        return
                    }
                    DispatchQueue.main.async {
                        completion(allLocations, nil)
                    }
                    
                }else {
                    completion(nil, NSError(domain: "status_code", code: statusCode, userInfo: nil))
                }
            }
        task.resume()
    }

    
    //MARK: - Post Student Location
    static func postStudentLocation(studentLocation: StudentLocation, completion: @escaping (String?) -> Void) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = PostLocationRequest(uniqueKey: API.userInfo.key!, firstName: API.userInfo.firstName!, lastName: API.userInfo.lastName!, mapString: studentLocation.mapString!, mediaURL: studentLocation.mediaURL!, latitude: studentLocation.latitude!, longitude: studentLocation.longitude!)
        request.httpBody = try! JSONEncoder().encode(body)
        let task =  URLSession.shared.dataTask(with: request) { data, response, error in
            guard data != nil else {
                completion(error?.localizedDescription)
                return
            }

           if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                          
                if statusCode >= 200  && statusCode < 300 {
                    DispatchQueue.main.async {
                        completion(nil)
                        print("Location Added Successfully")
                    }
                } else {
                    completion("Failed parsing response")
                }
            } else {
                completion("Check your internet connection")
            }
          
        }
        task.resume()
    }
    
    
    //MARK: - LOGOUT
    static func logout(completion: @escaping(Error?) -> Void){
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error…
            completion(error)
            return
          }
          let range = (5..<data!.count)
          let newData = data?.subdata(in: range) /* subset response data! */
          print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
    }

}
