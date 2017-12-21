//
//  BehanceViewController.swift
//  NibFilesExcercise
//
//  Created by Luis Calle on 12/21/17.
//  Copyright © 2017 Luis Calle. All rights reserved.
//

import UIKit

class BehanceViewController: UIViewController {

    @IBOutlet weak var projectsSearchBar: UISearchBar!
    @IBOutlet weak var projectsCollectionView: UICollectionView!
    
    var projects = [Project]() {
        didSet {
            projectsCollectionView.reloadData()
        }
    }
    
    var searchTerm = "" {
        didSet {
            loadProjects(with: searchTerm)
        }
    }
    
    func loadProjects(with searchTerm: String) {
        ProjectAPIClient.manager.getProjects(with: searchTerm, completionHandler: { self.projects = $0 }, errorHandler: { print($0) })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "ProjectCollectionViewCell", bundle: nil)
        self.projectsCollectionView.register(nib, forCellWithReuseIdentifier: "ProjectCell")
        self.projectsCollectionView.delegate = self
        self.projectsCollectionView.dataSource = self
        self.projectsSearchBar.delegate = self
    }

}

extension BehanceViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else { return }
        self.searchTerm = searchBarText
    }
    
}

extension BehanceViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return projects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let projectCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProjectCell", for: indexPath)
        if let projectCell = projectCell as? ProjectCollectionViewCell {
            let selectedProject = projects[indexPath.row]
            projectCell.projectViewsLabel.text = "Views: \(selectedProject.stats.views)"
            projectCell.projectAppreciationsLabel.text = "Appreciations: \(selectedProject.stats.appreciations)"
            projectCell.projectCommentsLabel.text = "Comments: \(selectedProject.stats.comments)"
            ImageFetchHelper.manager.getImage(from: selectedProject.covers.original, completionHandler: { projectCell.projectImageView.image = $0 }, errorHandler: { print($0) })
        }
        return projectCell
    }

}

extension BehanceViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        return CGSize(width: screenWidth, height: screenHeight * 0.8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
