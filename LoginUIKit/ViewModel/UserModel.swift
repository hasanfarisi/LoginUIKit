//
//  UserModel.swift
//  LoginUIKit
//
//  Created by mac on 10/10/24.
//
import Foundation
import Combine
import SwiftyJSON

class UserModel: ObservableObject {
    @Published var data: [User] = []

    init(token: String) {
        let url = "https://dev-qr1rd7py7m4bxg32.us.auth0.com/userinfo"
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) { (data, _, err) in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            guard let data = data else {
                print("No data returned")
                return
            }
            
            do {
                let json = try JSON(data: data)
                DispatchQueue.main.async {
                    self.data.append(User(
                        sub: json["sub"].rawValue as! String,
                        nickname: json["nickname"].rawValue as! String,
                        name: json["name"].rawValue as! String,
                        picture: json["picture"].rawValue as! String,
                        updated_at: json["updated_at"].rawValue as! String,
                        email: json["email"].rawValue as! String,
                        email_verified: json["email_verified"].rawValue as! String
                    ))
                }
            } catch {
                print("Failed to parse JSON: \(error.localizedDescription)")
            }
        }.resume()
    }

    
//    func getProfile(token:String){
//        guard let url = URL(string: "https://dev-qr1rd7py7m4bxg32.us.auth0.com/userinfo") else { return }
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data else { return }
//            if let httpResponse = response as? HTTPURLResponse {
//                if httpResponse.statusCode == 200{
//                    if let result = try? JSONDecoder().decode(User.self, from: data) {
//                        DispatchQueue.main.async {
//
//                        }
//                    }else{
//                        DispatchQueue.main.async {
//                            
//                        }
//                    }
//                }else{
//                    print("Unexpexted status code: \(httpResponse.statusCode)")
//                    DispatchQueue.main.async {
//                        
//                    }
//                }
//            }
//        }.resume()
//    }
}
