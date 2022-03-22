//
//  AlbumViewModel.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 13.03.2022.
//

import Foundation
import UIKit
import SDWebImage

final class AlbumViewModel: TrackContainerViewModelProtocol {
    let itemID: String
    private(set) var trackResponses: [TrackResponse] = []
    var model: TrackContainerModelProtocol?
    var headerModel: TrackContainerHeaderModel?
    let fetched = Observable<Bool>(false)
    let playingTrackID = Observable<String?>(nil)
    private var binderID: UUID?
    
    init(id: String) {
        itemID = id
        
        playingTrackID.value = PlayerManager.shared.currentTrackID.value
        binderID = PlayerManager.shared.currentTrackID.bind { [weak self] value in
            self?.playingTrackID.value = value
        }
    }
    
    deinit {
        if let uuid = binderID {
            PlayerManager.shared.currentTrackID.removeBind(uuid: uuid)
        }
    }
    
    func createTrackActionsViewModel(index: Int) -> TrackActionsViewModel {
        TrackActionsViewModel(trackResponse: trackResponses[index])
    }
    
    func fetch() {
        APICaller.shared.getAlbum(id: itemID) { [weak self] result in
            switch result {
            case .success(let albumDetails):
                self?.headerModel = TrackContainerHeaderModel(
                    topText: albumDetails.name,
                    middleText: albumDetails.artists.compactMap({$0.name}).joined(separator: "•"),
                    bottomText: String(albumDetails.releaseDate.split(separator: "-")[0]))
                self?.model = AlbumDetailModel(
                    name: albumDetails.name,
                    imageURL: findClosestSizeImage(images: albumDetails.images, height: 250, width: 250),
                    year: String(albumDetails.releaseDate.split(separator: "-")[0]),
                    albumType: albumDetails.type!,
                    artistName: albumDetails.artists.compactMap({$0.name}).joined(separator: ", "),
                    tracks: albumDetails.tracks!.items.compactMap {
                        ItemModel(
                            id: $0.id,
                            name: $0.name,
                            info: $0.artists.compactMap({$0.name}).joined(separator: ", "),
                            imageURL: nil,
                            itemType: .track)},
                    date: albumDetails.releaseDate,
                    artists: albumDetails.artists.compactMap({
                        ItemModel(
                            id: $0.id,
                            name: $0.name,
                            info: "Artist",
                            imageURL: nil,
                            itemType: .artist)}),
                    copyright: albumDetails.copyrights!.compactMap({$0.text}).joined(separator: ",\n"),
                    id: albumDetails.id)
                for index in 0..<albumDetails.tracks!.items.count {
                    var trackResponse = albumDetails.tracks!.items[index]
                    trackResponse.album = albumDetails
                    self?.trackResponses.append(trackResponse)
                }
                self?.fetched.value = true
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
