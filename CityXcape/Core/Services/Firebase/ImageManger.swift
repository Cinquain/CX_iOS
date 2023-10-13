//
//  ImageManger.swift
//  CityXcape
//
//  Created by James Allan on 8/31/23.
//

import UIKit
import FirebaseStorage


class ImageManager: NSObject {
    
    static let shared = ImageManager()
    private override init() {}
    
    private var storageRef = Storage.storage()
    
    
    //MARK: USER PROFILE IMAGE FUNCTIONS
    func uploadProfileImage(uid: String, image: UIImage) async throws -> String {
        let path = getProfileImagePath(uid: uid)
        do {
            let url = try await uploadImage(path: path, image: image)
            UserDefaults.standard.set(url, forKey: AppUserDefaults.profileUrl)
            return url
        } catch {
            throw error
        }
    }
    
    //MARK: LOCATION IMAGE FUNCTIONS
    func uploadLocationImage(id: String, image: UIImage) async throws -> String {
        let path = getLocationMainImagePath(spotId: id)
        do {
            let url = try await uploadImage(path: path, image: image)
            return url
        } catch (let error) {
            throw error
        }
    }
    
    //MARK: STORAGE PATHS
    fileprivate func getProfileImagePath(uid: String) -> StorageReference {
        let userPath = "users/\(uid)/profileImage"
        let path = storageRef.reference(withPath: userPath)
        return path
    }
    
    
    fileprivate func getLocationMainImagePath(spotId: String) -> StorageReference {
        let locationPath = "posts/\(spotId)/mainImage"
        let path = storageRef.reference(withPath: locationPath)
        return path
    }
    
    fileprivate func getStampImagePath(uid: String, spotId: String) -> StorageReference {
        let stampPath = "users/\(uid)/\(spotId)/stampImage"
        let path = storageRef.reference(withPath: stampPath)
        return path
    }
    
    //MARK: DELETE FUNCTIONS
    func deleteUserProfile(uid: String) async throws {
        let userPath = "users/\(uid)"
        let path = storageRef.reference(withPath: userPath)
        try await path.delete()
    }
    
    func deleteSpotImage(spotId: String) async throws {
        let locationPath = "posts/\(spotId)"
        let path = storageRef.reference(withPath: locationPath)
        try await path.delete()
    }
    
    fileprivate func uploadImage(path: StorageReference, image: UIImage) async throws -> String {
        
        var compression: CGFloat = 1.0
        let maxFileSize: Int = 550 * 550
        let maxCompression: CGFloat = 0.3
        
        guard var originalData = image.jpegData(compressionQuality: compression) else {
            print("Error getting data from image")
            throw MyError.failedCompression("Failed to Compress Image")
        }
        
        while (originalData.count > maxFileSize) && (compression > maxCompression) {
            compression -= 0.05
            if let compressedData = image.jpegData(compressionQuality: compression) {
                originalData = compressedData
            }
        }
        
        
        guard let finalData = image.jpegData(compressionQuality: compression) else {
            print("Error getting data from final image")
            throw MyError.failedCompression("Failed to Compress Image")
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        path.putData(finalData, metadata: metadata)
        
        do {
            let downloadUrl = try await path.downloadURL().absoluteString
            return downloadUrl
        } catch (let error) {
            print("Error fetching download url")
            throw error
        }
   
    }
    
    
}
