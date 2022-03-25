//
//  LibraryViewModel.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 25.03.2022.
//

import Foundation

final class LibraryViewModel: PlayingTrackViewModel {
    let tracks = Observable<[ItemModel]>([])
    private(set) var trackResponses = [TrackResponse]()
    private(set) var nextURL: String?
    
    func fetch() {
        APICaller.shared.getUsersSavedTracks(limit: 50) { [weak self] result in
            switch result {
            case .success(let tracks):
                self?.trackResponses = tracks.items.compactMap({ $0.track })
                self?.nextURL = tracks.next
                self?.tracks.value = tracks.items.compactMap({
                    ItemModel(
                        id: $0.track.id,
                        name: $0.track.name,
                        info: $0.track.artists.compactMap({ $0.name }).joined(separator: ", "),
                        imageURL: findClosestSizeImage(images: $0.track.album?.images, height: 100, width: 100),
                        itemType: .track)
                })
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchNext() {
        guard let nextURL = nextURL else {
            return
        }
        APICaller.shared.getNextTracks(url: nextURL) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(UsersSavedTracksResponse.self, from: data)
                    self?.trackResponses += response.items.compactMap({ $0.track })
                    self?.nextURL = response.next
                    self?.tracks.value += response.items.compactMap({
                        ItemModel(
                            id: $0.track.id,
                            name: $0.track.name,
                            info: $0.track.artists.compactMap({ $0.name }).joined(separator: ", "),
                            imageURL: findClosestSizeImage(images: $0.track.album?.images, height: 100, width: 100),
                            itemType: .track)
                    })
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
