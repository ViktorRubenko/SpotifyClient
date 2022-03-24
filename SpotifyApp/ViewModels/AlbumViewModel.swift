//
//  AlbumViewModel.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 13.03.2022.
//

import Foundation
import UIKit
import SDWebImage

final class AlbumViewModel: PlayingTrackViewModel, TrackContainerViewModelProtocol {
    
    private(set) var itemID: String
    private(set) var model: TrackContainerModelProtocol?
    private(set) var headerModel: TrackContainerHeaderModel?
    private(set) var fetched = Observable<Bool>(false)
    private(set) var fetchedNext = Observable<Bool>(false)
    private(set) var trackResponses = [TrackResponse]()
    private(set) var tracks = [ItemModel]()
    private(set) var nextURL: String?
    
    init(itemID: String) {
        self.itemID = itemID
        super.init()
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
                self?.tracks = albumDetails.tracks!.items.compactMap {
                    ItemModel(
                        id: $0.id,
                        name: $0.name,
                        info: $0.artists.compactMap({$0.name}).joined(separator: ", "),
                        imageURL: nil,
                        itemType: .track)}
                for index in 0..<albumDetails.tracks!.items.count {
                    var trackResponse = albumDetails.tracks!.items[index]
                    trackResponse.album = albumDetails
                    self?.trackResponses.append(trackResponse)
                }
                self?.nextURL = albumDetails.tracks?.next
                self?.fetched.value = true
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchNext() {
        guard let nextURL = nextURL else {
            return
        }

        APICaller.shared.getNextTracksAlbum(url: nextURL) { [weak self] result in
            switch result {
            case .success(let tracks):
                guard let self = self else { return }
                self.tracks += tracks.items.compactMap {
                    ItemModel(
                        id: $0.id,
                        name: $0.name,
                        info: $0.artists.compactMap({$0.name}).joined(separator: ", "),
                        imageURL: nil,
                        itemType: .track)}
                self.trackResponses += tracks.items
                self.fetchedNext.value = true
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func createTrackActionsViewModel(index: Int) -> TrackActionsViewModel {
        let trackResponse = trackResponses[index]
        return TrackActionsViewModel(trackResponse: trackResponse, from: .album)
    }
}
