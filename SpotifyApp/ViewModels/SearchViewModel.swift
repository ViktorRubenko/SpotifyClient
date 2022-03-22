//
//  SearchViewModel.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 15.03.2022.
//

import Foundation

struct SearchResultSection {
    let title: String
    private(set) var items: [ItemModel]
    
    fileprivate mutating func addNoResultItem() {
        items.append(ItemModel(id: "", name: "No Results", info: nil, imageURL: nil, itemType: .noResults))
    }
}

final class SearchViewModel: PlayingTrackViewModel {
    
    let categories = Observable<[ItemModel]>([])
    let resultSections = Observable<[SearchResultSection]>([])
    private(set) var trackResponses = [TrackResponse]()
    
    func performSearch(for searchText: String) {
        let searchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if searchText.isEmpty {
            resultSections.value.removeAll()
            trackResponses = []
            return
        }
        APICaller.shared.searchRequest(searchText) { [weak self] response in
            switch response {
            case .success(let result):
                var sections = [SearchResultSection]()
                
                if let arists = result.artists {
                    sections.append(
                        SearchResultSection(
                            title: "Artists",
                            items: arists.items.compactMap {
                                ItemModel(
                                    id: $0.id,
                                    name: $0.name,
                                    info: "Artist",
                                    imageURL: findClosestSizeImage(images: $0.images, height: 100, width: 100),
                                    itemType: .artist)
                            })
                    )
                }
                
                if let items = result.tracks?.items {
                    sections.append(
                        SearchResultSection(
                            title: "Tracks",
                            items: items.compactMap {
                                ItemModel(
                                    id: $0.id,
                                    name: $0.name,
                                    info: "Track • \($0.artists.compactMap({$0.name}).joined(separator: ", "))",
                                    imageURL: findClosestSizeImage(images: $0.album!.images, height: 100, width: 100),
                                    itemType: .track)
                            })
                    )
                    self?.trackResponses = items
                }
                
                if let albums = result.albums {
                    sections.append(
                        SearchResultSection(
                            title: "Album",
                            items: albums.items.compactMap {
                                ItemModel(
                                    id: $0.id,
                                    name: $0.name,
                                    info: "Album • \($0.artists.compactMap({$0.name}).joined(separator: ", "))",
                                    imageURL: findClosestSizeImage(images: $0.images, height: 100, width: 100),
                                    itemType: .album)
                            })
                    )
                }
                
                if let playlists = result.playlists {
                    let items = playlists.items
                    sections.append(
                        SearchResultSection(
                            title: "Playlist",
                            items: items.compactMap {
                                ItemModel(
                                    id: $0.id,
                                    name: $0.name,
                                    info: "Playlist",
                                    imageURL: findClosestSizeImage(images: $0.images, height: 100, width: 100),
                                    itemType: .playlist)
                            })
                    )
                }
                for (index, section) in sections.enumerated() where section.items.isEmpty {
                    sections[index].addNoResultItem()
                }
                self?.resultSections.value = sections
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchCategories() {
        APICaller.shared.getCategories(limit: 40) { [weak self] response in
            switch response {
            case .success(let result):
                self?.categories.value = result.categories.items.compactMap({ item in
                    ItemModel(
                        id: item.id,
                        name: item.name,
                        info: nil,
                        imageURL: URL(string: item.icons.first?.url ?? ""),
                        itemType: .unknown)
                })
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func createPlaylistsViewModel(index: Int) -> CategoryPlaylistsViewModel {
        let category = categories.value[index]
        return CategoryPlaylistsViewModel(name: category.name, itemID: category.id)
    }
}
