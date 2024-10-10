//
//  AuthUser.swift
//  LoginUIKit
//
//  Created by mac on 10/9/24.
//

import Foundation
import Combine
import SystemConfiguration

class AuthUser:ObservableObject {
    var didChange = PassthroughSubject<AuthUser, Never>()
    @Published var isCorrect:Bool = true
    @Published var isError:String = ""
    @Published var needVerified:Bool = false
    @Published var needVerifiedEmail:Bool = false
    @Published var isLoggedIn:Bool = false
    @Published var token:String = ""
    private var client_id: String = "6GfC0AII0iISQP1cO3Hjd1owAiXQgUXU" // your client id of Auth0
    private var connection: String = "MyFirstMockAPIwithAuth0" // your database name connection on Auth0
    private var grant_type: String = "http://auth0.com/oauth/grant-type/passwordless/otp"
    private var realm: String = "email" //email or sms
    private var redirect_uri: String = "https://sampulkreativ.com/" //your website for redirect when success
    
    func checkRegister(username:String,password:String, email:String){
        guard let url = URL(string: "https://dev-qr1rd7py7m4bxg32.us.auth0.com/dbconnections/signup") else { return }

        let body: [String: String] = ["password": password, "email": email, "username": username, "client_id": client_id, "connection": connection]
        guard let finalBody = try? JSONEncoder().encode(body) else { return }

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = finalBody

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print("No data or an error occurred: \(error?.localizedDescription ?? "Unknown error")")
                DispatchQueue.main.async {
                    // your state of API reachable or not
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                // Check if the status code indicates an error (400 Bad Request, etc.)
                if httpResponse.statusCode == 400 {
                    // Try to parse the error message from the response
                    if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                        DispatchQueue.main.async {
                            print("Error: \(errorResponse)")
                            self.isCorrect = false
                            self.isError = "\(errorResponse.code)"
                        }
                    } else {
                        // If decoding fails, print the raw response for debugging
                        if let errorResponse = try? JSONDecoder().decode(SimpleErrorResponse.self, from: data) {
                            print("Error: \(errorResponse.error)")
                            DispatchQueue.main.async {
                                self.isCorrect = false
                                self.isError = "\(errorResponse.error)"
                            }
                        }else{
                            if let responseString = String(data: data, encoding: .utf8) {
                                print("Failed to decode error response: \(responseString)")
                                DispatchQueue.main.async {
                                    self.isCorrect = false
                                }
                            }
                        }
                    }
                } else if httpResponse.statusCode == 200 {
                    // Handle success response
                    DispatchQueue.main.async {
                        self.isCorrect = true
                        self.needVerifiedEmail = true
                    }
                } else {
                    // Handle other status codes if necessary
                    print("Unexpected status code: \(httpResponse.statusCode)")
                    DispatchQueue.main.async {
                        self.isCorrect = false
                    }
                }
            }
        }.resume()
    }
    
    func checkLogin(email:String, password:String){
        // in this example, we are using passwordless function, that mean we are not using password for sign in
        guard let url = URL(string: "https://dev-qr1rd7py7m4bxg32.us.auth0.com/passwordless/start") else { return }
        
        let body: [String:String] = ["client_id": client_id, "send": "code", "email": email, "connection": "email"]
        guard let finalBody = try? JSONEncoder().encode(body) else { return }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = finalBody
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data, error == nil else { return }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 400 {
                    if let errorResponse = try? JSONDecoder().decode(SimpleErrorResponse.self, from: data) {
                        DispatchQueue.main.async {
                            print("Error: \(errorResponse.error)")
                            self.isError = "\(errorResponse.error)"
                            self.isCorrect = false
                        }
                    }else{
                        if let responseString = String(data: data, encoding: .utf8) {
                            print("Failed to decode error response: \(responseString)")
                            DispatchQueue.main.async {
                                self.isCorrect = false
                            }
                        }
                    }
                }else if httpResponse.statusCode == 200{
                    DispatchQueue.main.async {
                        self.isCorrect = true
                        self.needVerified = true
                    }
                }else{
                    print("Unexpexted status code: \(httpResponse.statusCode)")
                    DispatchQueue.main.async {
                        self.isCorrect = false
                    }
                }
            }
        }.resume()
    }
    
    func verifiedOTP(otp:String, emailID:String) {
        guard let url = URL(string: "https://dev-qr1rd7py7m4bxg32.us.auth0.com/oauth/token") else { return }
        
        let body: [String:String] = ["otp": otp, "grant_type" : grant_type, "client_id": client_id, "realm": realm, "redirect_uri": redirect_uri, "username": emailID]
        guard let finalBody = try? JSONEncoder().encode(body) else { return }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = finalBody
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data, error == nil else { return }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 400 || httpResponse.statusCode == 403 {
                    if let errorResponse = try? JSONDecoder().decode(SimpleErrorResponse.self, from: data) {
                        DispatchQueue.main.async {
                            print("Error: \(errorResponse.error)")
                            self.isError = "\(errorResponse.error)"
                            self.isCorrect = false
                        }
                    }else{
                        if let responseString = String(data: data, encoding: .utf8) {
                            print("Failed to decode error response: \(responseString)")
                            DispatchQueue.main.async {
                                self.isCorrect = false
                            }
                        }
                    }
                }else if httpResponse.statusCode == 200{
                    if let result = try? JSONDecoder().decode(Token.self, from: data){
                        DispatchQueue.main.async {
                            self.isCorrect = true
                            self.isLoggedIn = true
                            self.token = result.access_token
                        }
                    }
                }else{
                    print("Unexpexted status code: \(httpResponse.statusCode)")
                    DispatchQueue.main.async {
                        self.isCorrect = false
                    }
                }
            }
        }.resume()
    }        
}
