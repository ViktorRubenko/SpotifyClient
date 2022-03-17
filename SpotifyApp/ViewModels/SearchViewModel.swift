//
//  SearchViewModel.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 15.03.2022.
//

import Foundation

struct searchResultSection {
    let title: String
    private(set) var items: [ItemModel]
    
    fileprivate mutating func addNoResultItem() {
        items.append(ItemModel(id: "", name: "No Results", info: nil, imageURL: nil, type: .noResults))
    }
}

final class SearchViewModel {
    
    let categories = Observable<[CategoryCellModel]>([])
    let resultSections = Observable<[searchResultSection]>([])
    
    func performSearch(for searchText: String) {
        print("perform search")
        let searchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if searchText.isEmpty {
            return
        }
        APICaller.shared.searchRequest(searchText) { [weak self] response in
            switch response {
            case .success(let result):
                var sections = [searchResultSection]()
                
                if let arists = result.artists {
                    sections.append(
                        searchResultSection(
                            title: "Artists",
                            items: arists.items.compactMap {
                                ItemModel(
                                    id: $0.id,
                                    name: $0.name,
                                    info: "Artist",
                                    imageURL: findClosestSizeImage(images: $0.images, height: 100, width: 100),
                                    type: .trackContainer)
                            })
                    )
                }
                
                if let tracks = result.tracks, let items = tracks.items {
                    sections.append(
                        searchResultSection(
                            title: "Tracks",
                            items: items.compactMap {
                                ItemModel(
                                    id: $0.id,
                                    name: $0.name,
                                    info: "Track • \($0.artists.compactMap({$0.name}).joined(separator: ", "))",
                                    imageURL: findClosestSizeImage(images: $0.album!.images, height: 100, width: 100),
                                    type: .track)
                            })
                    )
                }
                
                if let albums = result.albums {
                    sections.append(
                        searchResultSection(
                            title: "Album",
                            items: albums.items.compactMap {
                                ItemModel(
                                    id: $0.id,
                                    name: $0.name,
                                    info: "Album • \($0.artists.compactMap({$0.name}).joined(separator: ", "))",
                                    imageURL: findClosestSizeImage(images: $0.images, height: 100, width: 100),
                                    type: .trackContainer)
                            })
                    )
                }
                
                if let playlists = result.playlists {
                    let items = playlists.items
                    sections.append(
                        searchResultSection(
                            title: "Playlist",
                            items: items.compactMap {
                                ItemModel(
                                    id: $0.id,
                                    name: $0.name,
                                    info: "Playlist",
                                    imageURL: findClosestSizeImage(images: $0.images, height: 100, width: 100),
                                    type: .trackContainer)
                            })
                    )
                }
                for (index, section) in sections.enumerated() {
                    if section.items.isEmpty {
                        sections[index].addNoResultItem()
                    }
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
                    CategoryCellModel(
                        name: item.name,
                        id: item.id,
                        imageURL: URL(string: item.icons.first?.url ?? ""),
                        info: nil)
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
