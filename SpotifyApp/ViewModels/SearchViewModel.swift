//
//  SearchViewModel.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 15.03.2022.
//

import Foundation


final class searchViewModel {
    
    let categories = Observable<[CategoryCellModel]>([])
    
    func performSearch(for searchText: String) {
        let searchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if searchText.isEmpty {
            return
        }
        APICaller.shared.searchRequest(searchText) { response in
            switch response {
            case .success(let result):
                print(result)
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
                        iconURL: URL(string: item.icons.first?.url ?? ""))
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
