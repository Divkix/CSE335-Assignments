//
//  SearchCompleterViewModel.swift
//  NomadNavigator
//
//  Created by Divanshu Chauhan on 11/30/24.
//


import Foundation
import MapKit
import Combine

class SearchCompleterViewModel: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var queryFragment: String = ""
    @Published var searchResults: [MKLocalSearchCompletion] = []

    private var completer: MKLocalSearchCompleter
    private var cancellable: AnyCancellable?

    override init() {
        self.completer = MKLocalSearchCompleter()
        super.init()
        
        configureCompleter()
        observeQueryFragment()
    }
    
    private func configureCompleter() {
        completer.resultTypes = [.address, .pointOfInterest]
        completer.delegate = self
    }
    
    private func observeQueryFragment() {
        // Observe queryFragment for debouncing search input
        cancellable = $queryFragment
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates() // Prevent redundant searches
            .sink { [weak self] query in
                guard let self = self else { return }
                self.updateQueryFragment(query)
            }
    }

    private func updateQueryFragment(_ query: String) {
        if !query.isEmpty {
            self.completer.queryFragment = query
        }
    }

    // Delegate methods
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        DispatchQueue.main.async {
            self.searchResults = completer.results
        }
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Search completer error: \(error.localizedDescription)")
        DispatchQueue.main.async {
            self.searchResults = []
        }
    }
    
    func resetCompleter() {
        completer.delegate = self
    }
}

