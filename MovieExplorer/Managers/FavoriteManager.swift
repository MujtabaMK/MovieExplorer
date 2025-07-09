//
//  FavoriteManager.swift
//  MovieExplorer
//
//  Created by Mujtaba Khan on 08/07/25.
//

import Foundation
import RealmSwift
import UserNotifications

class FavoriteManager {
    static let shared = FavoriteManager()
    private let realm = try! Realm()

    func isFavorite(_ movie: Movie) -> Bool {
        realm.object(ofType: FavoriteMovie.self, forPrimaryKey: movie.id) != nil
    }

    func toggleFavorite(_ movie: Movie) {
        if isFavorite(movie) {
            try! realm.write {
                if let obj = realm.object(ofType: FavoriteMovie.self, forPrimaryKey: movie.id) {
                    realm.delete(obj)
                }
            }
        } else {
            let fav = FavoriteMovie()
            fav.id = movie.id
            fav.title = movie.title
            fav.posterPath = movie.posterPath ?? ""
            try! realm.write {
                realm.add(fav)
            }
            sendNotification(movie.title)
        }
    }
    
    func getAllFavorites() -> [FavoriteMovie] {
        Array(realm.objects(FavoriteMovie.self))
    }

    private func sendNotification(_ title: String) {
        let content = UNMutableNotificationContent()
        content.title = "🎬 Added to Favorites"
        content.body = "\(title) is now marked as favorite!"
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}
