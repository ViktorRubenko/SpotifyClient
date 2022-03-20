//
//  AritstViewModel.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 18.03.2022.
//

import Foundation
import UIKit
import SDWebImage

enum ArtistSectionType: Int {
    case popularTracks, releases, appearsOn, reletedArtists, discography
}

struct ArtistSection {
    let title: String
    let items: [ItemModel]
    let sectionType: ArtistSectionType
}

final class ArtistViewModel {
    let itemID: String
    private var artistResponse: ArtistDetailResponse? {
        didSet {
            fetchImage()
        }
    }
    private var artistsTopTracksResposne: ArtistsTopTracksResponse?
    private var artistsAlbumsResponse: ArtistsAlbumsResponse?
    
    var sections = Observable<[ArtistSection]>([])
    var name = Observable<String>("")
    var artistImage = Observable<UIImage?>(nil)
    var followers = "Followers: ..."
    
    init(itemID: String) {
        self.itemID = itemID
    }
    
    func fetch() {
        fetchArtist()
        fetchData()
    }
    
    private func fetchArtist() {
        APICaller.shared.getArtist(id: itemID) { [weak self] response in
            switch response {
            case .success(let response):
                self?.artistResponse = response
                self?.name.value = response.name
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchData() {
        let group = DispatchGroup()
        
        group.enter()
        APICaller.shared.getArtistsTopTracks(id: itemID) { [weak self] response in
            switch response {
            case .success(let response):
                self?.artistsTopTracksResposne = response
            case .failure(let error):
                print("Failing get ArtistsTopTracks, \(error.localizedDescription)")
            }
            group.leave()
        }
        
        group.enter()
        APICaller.shared.getArtistAlbums(id: itemID, limit: 50, includeGroups: ["album", "single"]) { [weak self] response in
            switch response {
            case .success(let response):
                self?.artistsAlbumsResponse = response
            case .failure(let error):
                print("Failing get ArtistsAlbums, \(error.localizedDescription)")
            }
            group.leave()
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.extractSections()
        }
    }
    
    private func extractSections() {
        var sections = [ArtistSection]()
        
        if let topTracks = artistsTopTracksResposne {
            let count = topTracks.tracks.count >= 5 ? 5 : topTracks.tracks.count
            sections.append(ArtistSection(
                title: "Popular tracks",
                items: topTracks.tracks[0..<count].compactMap({
                    ItemModel(
                        id: $0.id,
                        name: $0.name,
                        info: ($0.album != nil ? $0.album!.releaseDate.split(separator: "-")[0] : "") + ($0.album?.name != nil ? " • \($0.album!.name)" : ""),
                        imageURL: findClosestSizeImage(images: $0.album?.images, height: 80, width: 80),
                        itemType: .track)
                }),
                sectionType: .popularTracks))
        }
        
        if let albums = artistsAlbumsResponse {
            var namesSet = Set<String>()
            var items = [ItemModel]()
            for release in albums.items {
                if namesSet.contains(release.name) {
                    continue
                }
                namesSet.insert(release.name)
                items.append(ItemModel(
                    id: release.id,
                    name: release.name,
                    info: release.releaseDate.split(separator: "-")[0] + (release.albumType != nil ? "  • \(release.albumType!.capitalized)" : ""),
                    imageURL: findClosestSizeImage(images: release.images, height: 200, width: 200),
                    itemType: .album))
            }
            let count = items.count >= 4 ? 4 : items.count
            sections.append(ArtistSection(
                title: "Releases",
                items: Array(items[0..<count]),
                sectionType: .releases))
        }
        
        self.sections.value = sections
    }
    
    private func fetchImage() {
        SDWebImageManager.shared.loadImage(
            with: findClosestSizeImage(images: artistResponse?.images, height: 500, width: 500),
            options: [.highPriority],
            progress: nil) { image, _, error, _, _, _ in
                if error == nil, let image = image {
                    self.artistImage.value = image
                } else {
                    print("Failing to load artist image with: \(error!.localizedDescription)")
                }
            }
    }
    
    func createTrackActionsViewModel(index: Int) -> TrackActionsViewModel {
        let trackResponse = artistsTopTracksResposne!.tracks[index]
        return TrackActionsViewModel(trackResponse: trackResponse, albumImages: trackResponse.album?.images, fromArtist: true)
    }
}
