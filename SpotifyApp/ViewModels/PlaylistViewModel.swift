//
//  PlaylistViewModel.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 15.03.2022.
//

import Foundation

final class PlaylistViewModel: TrackContainerViewModelProtocol {
    var itemID: String
    
    var model: TrackContainerModelProtocol?
    
    var headerModel: TrackContainerHeaderModel?
    
    var fetched = Observable<Bool>(false)
    
    init(id: String) {
        self.itemID = id
    }
    
    func fetch() {
        APICaller.shared.getPlaylist(id: itemID) { [weak self] result in
            switch result {
            case .success(let response):
                self?.model = PlaylistDetailModel(
                    name: response.name,
                    imageURL: findClosestSizeImage(images: response.images, height: 250, width: 250),
                    tracks: response.tracks.items.compactMap( {
                        TrackModel(
                            name: $0.track.name,
                            type: $0.track.type,
                            albumImageURL: findClosestSizeImage(images: $0.track.album.images, height: 50, width: 50),
                            artistsName: $0.track.artists.compactMap({$0.name}).joined(separator: ", "),
                            id: $0.track.id)}),
                    id: response.id)
                
                self?.headerModel = TrackContainerHeaderModel(
                    topText: response.welcomeDescription,
                    middleText: response.owner.displayName ?? "Spotify",
                    bottomText: "Followers: \(response.followers.total)")
            case .failure(let error):
                print(error.localizedDescription)
            }
            self?.fetched.value = true
        }
    }
    
    
}
