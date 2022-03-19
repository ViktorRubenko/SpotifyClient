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

    private var detailTracks: [TrackResponse] = []
    var model: TrackContainerModelProtocol?
    var headerModel: TrackContainerHeaderModel?
    let fetched = Observable<Bool>(false)
    private var albumImages = [SpotifyImage]()
    
    init(id: String) {
        itemID = id
    }
    
    func createTrackActionsViewModel(index: Int) -> TrackActionsViewModel {
        TrackActionsViewModel(
            trackResponse: detailTracks[index],
            albumImages: albumImages)
    }
    
    func fetch() {
        APICaller.shared.getAlbum(id: itemID) { [weak self] result in
            switch result {
            case .success(let albumDetails):
                self?.albumImages = albumDetails.images
                self?.headerModel = TrackContainerHeaderModel(
                    topText: albumDetails.name,
                    middleText: albumDetails.artists.compactMap({$0.name}).joined(separator: "•"),
                    bottomText: String(albumDetails.releaseDate.split(separator: "-")[0]))
                self?.model = AlbumDetailModel(
                    name: albumDetails.name,
                    imageURL: findClosestSizeImage(images: albumDetails.images, height: 250, width: 250),
                    year: String(albumDetails.releaseDate.split(separator: "-")[0]),
                    albumType: albumDetails.type,
                    artistName: albumDetails.artists.compactMap({$0.name}).joined(separator: ", "),
                    tracks: albumDetails.tracks.items.compactMap {
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
                    copyright: albumDetails.copyrights.compactMap({$0.text}).joined(separator: ",\n"),
                    id: albumDetails.id)
                self?.detailTracks = albumDetails.tracks.items
                self?.fetched.value = true
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
