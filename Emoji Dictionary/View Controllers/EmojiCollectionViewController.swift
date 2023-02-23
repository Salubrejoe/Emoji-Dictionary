//
//  EmojiCollectionViewController.swift
//  Emoji Dictionary
//
//  Created by Lore P on 23/02/2023.
//

import UIKit



class EmojiCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
  
  
  private var emojis: [Emoji] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Emoji Dictionary"
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(didTapAddBarButton))
    navigationController?.navigationBar.tintColor = .systemTeal
    
    collectionView.backgroundColor = .systemBackground
    
    // Register cell classes
    self.collectionView!.register(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: EmojiCollectionViewCell.identifier)
    
    // Do any additional setup after loading the view.
    
    
    // Load Emojis from disk
    if let data = try? Data(contentsOf: Emoji.archiveURL),
       let decodedEmoji = try? PropertyListDecoder().decode(Array<Emoji>.self, from: data) {
      emojis = decodedEmoji
    } else {
      emojis = Emoji.sampleEmojis
    }
    
  }
  
  // Fixes a bug that impedes the layout to get the right width after rotating BACK from landscape
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    
    collectionView.collectionViewLayout.invalidateLayout()
  }
  
  
  // MARK: Selector
  @objc func didTapAddBarButton() {
    
    let addEditViewController      = AddEditViewController()
    addEditViewController.title    = "Add New Emoji"
    addEditViewController.delegate = self
    
    let vc = UINavigationController(rootViewController: addEditViewController)
    
    navigationController?.present(vc, animated: true)
  }
  
  
  
  // MARK: Delegate and DataSource
  
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return emojis.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCollectionViewCell.identifier, for: indexPath) as! EmojiCollectionViewCell
    
    // Configure the cell
    let emoji = emojis[indexPath.row]
    cell.update(with: emoji)
    
    cell.backgroundColor    = .secondarySystemBackground
    cell.layer.cornerRadius = 20
    
    
    return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    let emoji = emojis[indexPath.row]
    
    // Present the AddEditVC
    let addEditViewController       = AddEditViewController()
    addEditViewController.title     = "Edit Emoji"
    addEditViewController.emoji     = emoji
    addEditViewController.delegate  = self
    
    let secondNavigationController  = UINavigationController(rootViewController: addEditViewController)
    
    navigationController?.present(secondNavigationController, animated: true)
  }
  
  override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
    
    let contextMenuConfig = UIContextMenuConfiguration(
      identifier: nil,
      previewProvider: nil) { _ in
        
        let deleteAction = UIAction(title: "Delete") { _ in
          self.emojis.remove(at: indexPath.row)
          collectionView.deleteItems(at: [indexPath])
          Emoji.saveToFile(emojis: self.emojis)
        }
        return UIMenu(title: "", options: [], children: [deleteAction])
      }
    return contextMenuConfig
  }
  
  
  
  
  
  // MARK: Flow Layout
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let availableWidth = view.frame.width
    let layoutSize     = CGSize(
      width: availableWidth - 40,
      height: 70
    )
    
    return layoutSize
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 6
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 32, left: 0, bottom: 0, right: 0)
  }
  
}


// MARK: Delegate Protocol
// Send back a message from the second ViewController method
extension EmojiCollectionViewController: AddEditViewControllerDelegate {
  
  func finishPassing(emoji: Emoji) {
    
    if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {

      emojis[selectedIndexPath.row]  = emoji
      Emoji.saveToFile(emojis: emojis)
      collectionView.reloadItems(at: [selectedIndexPath])

    } else {

      let newIndexPath = IndexPath(row: emojis.count, section: 0)
      emojis.append(emoji)
      Emoji.saveToFile(emojis: emojis)
      collectionView.insertItems(at: [newIndexPath])
    }
  }
}
