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
    @Published var isApiReachable:Bool = true{
        didSet {
            didChange.send(self)
        }
    }
    func checkRegister(username:String,password:String, email:String){
        guard let url = URL(string: "https://dev-qr1rd7py7m4bxg32.us.auth0.com/dbconnections/signup") else { return }

        let body: [String: String] = ["password": password, "email": email, "username": username, "client_id": "6GfC0AII0iISQP1cO3Hjd1owAiXQgUXU", "connection": "MyFirstMockAPIwithAuth0"]
        guard let finalBody = try? JSONEncoder().encode(body) else { return }

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = finalBody

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print("No data or an error occurred: \(error?.localizedDescription ?? "Unknown error")")
                DispatchQueue.main.async {
                    self.isApiReachable = false
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
                            self.needVerified = false
                            self.isError = "\(errorResponse.code)"
                        }
                    } else {
                        // If decoding fails, print the raw response for debugging
                        if let responseString = String(data: data, encoding: .utf8) {
                            print("Failed to decode error response: \(responseString)")
                            self.isCorrect = false
                            self.needVerified = false
                        }
                    }
                } else if httpResponse.statusCode == 200 {
                    // Handle success response
                    if let result = try? JSONDecoder().decode(User.self, from: data) {
                        DispatchQueue.main.async {
                            if !result._id.isEmpty {
                                print(result._id)
                                self.needVerified = true
                                self.isCorrect = true
                            } else {
                                self.isCorrect = false
                                self.needVerified = false
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.isCorrect = false
                            self.needVerified = false
                            self.isError = "Invalid response from web server..."
                            print("Invalid response from web server...")
                        }
                    }
                } else {
                    // Handle other status codes if necessary
                    print("Unexpected status code: \(httpResponse.statusCode)")
                }
            }
        }.resume()
    }
}
