//
//  AuthService.swift
//  CityXcape
//
//  Created by James Allan on 8/9/23.
//
import Foundation
import Firebase
import FirebaseAuth
import GoogleSignIn
import SwiftUI


final class AuthService: NSObject {
    
    static let shared = AuthService()
    private override init() {}
    
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    func SignInWithGoogle(credentials: AuthCredential) async throws {
        let authResult = try await Auth.auth().signIn(with: credentials)
        let uid = authResult.user.uid
        if await DataService.shared.checkIfUserExist(uid: uid) {
            //User is new
            print("User is brand spanking new")
        } else {
            //User already exist, dismiss view
            print("User already exist")
        }
    }
    
    
}


//Google Signin
extension AuthService {
    
    @MainActor
    func startSignInWithGoogleFlow() async throws {
        guard let view = Utilities.shared.topViewController() else
        {
            print("Cant Find View Conroller")
            return}

        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: view)
        
        guard let idToken = result.user.idToken?.tokenString else {return}
        let accessToken = result.user.accessToken.tokenString

            
        let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: accessToken)
            
        
    }
}
