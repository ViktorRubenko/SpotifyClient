//
//  AlbumViewModel.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 13.03.2022.
//

import Foundation
import UIKit
import SDWebImage

final class AlbumViewModel {
    
    private let albumID: String
    
    let album = Observable<AlbumDetailModel>(
        AlbumDetailModel(name: "",
                         imageURL: nil,
                         year: "",
                         albumType: "",
                         artistName: "",
                         tracks: [], date: "",
                         artists: [],
                         copyright: "", id: ""))
    
    private(set) var albumHeader = AlbumHeaderModel(name: "", artists: "", info: "")
    
    init(id: String) {
        albumID = id
    }
    
    public func fetch() {
        APICaller.shared.getAlbum(id: albumID) { [weak self] result in
            switch result {
            case .success(let albumDetails):
                self?.albumHeader = AlbumHeaderModel(
                    name: albumDetails.name,
                    artists: albumDetails.artists.compactMap({$0.name}).joined(separator: "•"),
                    info: "\(albumDetails.releaseDate)")
                self?.album.value = AlbumDetailModel(
                    name: albumDetails.name,
                    imageURL: findClosestSizeImage(images: albumDetails.images, height: 250, width: 250),
                    year: albumDetails.releaseDate,
                    albumType: albumDetails.type,
                    artistName: albumDetails.artists.compactMap({$0.name}).joined(separator: ", "),
                    tracks: albumDetails.tracks.items.compactMap {
                        TrackModel(
                            name: $0.name,
                            type: $0.type,
                            albumImageURL: nil,
                            artistsName: $0.artists.compactMap({$0.name}).joined(separator: ", "),
                            id: $0.id) },
                    date: albumDetails.releaseDate,
                    artists: albumDetails.artists.compactMap({ArtistModel(name: $0.name, id: $0.id)}),
                    copyright: albumDetails.copyrights.compactMap({$0.text}).joined(separator: ",\n"),
                    id: albumDetails.id)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
