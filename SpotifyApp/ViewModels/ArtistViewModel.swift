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
    case popularTracks, popularReleases, appearsOn, reletedArtists
}

struct ArtistSection {
    let title: String
    let items: [ItemModel]
    let sectionType: ArtistSectionType
}

final class ArtistViewModel {
    private let itemID: String
    private var artistResponse: ArtistDetailResponse?
    private var artistsTopTracksResposne: ArtistsTopTracksResponse?
    
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
        
        group.notify(queue: .main) { [weak self] in
            self?.extractSections()
        }
    }
    
    private func extractSections() {
        var sections = [ArtistSection]()
        
        if let topTracks = artistsTopTracksResposne {
            let count = topTracks.tracks.count >= 5 ? 4 : topTracks.tracks.count
            sections.append(ArtistSection(
                title: "Popular tracks",
                items: topTracks.tracks[0...count].compactMap({
                    ItemModel(
                        id: $0.id,
                        name: $0.name,
                        info: nil,
                        imageURL: findClosestSizeImage(images: $0.album?.images, height: 80, width: 80),
                        itemType: .track)
                }),
                sectionType: .popularTracks))
        }
        
        self.sections.value = sections
    }
    
    func createTrackActionsViewModel(index: Int) -> TrackActionsViewModel {
        let trackResponse = artistsTopTracksResposne!.tracks[index]
        return TrackActionsViewModel(trackResponse: trackResponse, albumImages: trackResponse.album?.images, fromArtist: true)
    }
}
