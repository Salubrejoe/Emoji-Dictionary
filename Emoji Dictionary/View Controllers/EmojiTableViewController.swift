//
//  ViewController.swift
//  Emoji Dictionary
//
//  Created by Lore P on 14/02/2023.
//

import UIKit



class EmojiTableViewController: UITableViewController {
    

    public var emojis: [Emoji] = []
    
    // MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(EmojiTableViewCell.self, forCellReuseIdentifier: EmojiTableViewCell.identifier)
        configureNavigationController()
        
        // Resize the cell to fit its content
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        
        // Load Emojis from disk
        if let data = try? Data(contentsOf: Emoji.archiveURL),
           let decodedEmoji = try? PropertyListDecoder().decode(Array<Emoji>.self, from: data) {
            emojis = decodedEmoji
        } else {
            emojis = Emoji.sampleEmojis
        }
        
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    
    // MARK: Configure Navigation Bar (with #selector)
    func configureNavigationController() {
        title                                                  = "Emoji Dictionary"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor          = .systemTeal
        
        navigationItem.leftBarButtonItem  = editButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(didTapAddBarButton))
    }
    
    
    // MARK: Selector for Add button
    // Instead of an @IBAction I define a #selector func @objc that pushes or presents a Vew Controller
    @objc func didTapAddBarButton() {
        
        let addEditViewController      = AddEditViewController()
        addEditViewController.title    = "Add New Emoji"
        addEditViewController.delegate = self
        
        let vc = UINavigationController(rootViewController: addEditViewController)
        
        navigationController?.present(vc, animated: true)
    }
    
    
    
    
    
    // MARK: TV Data Source and Delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emojis.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EmojiTableViewCell.identifier, for: indexPath) as? EmojiTableViewCell else {
            return UITableViewCell()
        }
        
        let currentEmoji           = emojis[indexPath.row]
        
        cell.emojiLabel.text       = currentEmoji.symbol
        cell.nameLabel.text        = currentEmoji.name
        cell.descriptionLabel.text = currentEmoji.description
        
        
        cell.showsReorderControl   = true
        
        return cell
    }
    
    // Configure Rearrange Action
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let movedEmoji = emojis.remove(at: sourceIndexPath.row)
        
        emojis.insert(movedEmoji, at: destinationIndexPath.row)
        Emoji.saveToFile(emojis: emojis)
    }
    
    // DS method to update the model to reflect user action (in this case is delete)
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        emojis.remove(at: indexPath.row)
        Emoji.saveToFile(emojis: emojis)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }

    // Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let emoji = emojis[indexPath.row]
        
        // Present the AddEditVC
        let addEditViewController       = AddEditViewController()
        addEditViewController.title     = "Edit Emoji"
        addEditViewController.emoji     = emoji
        addEditViewController.delegate  = self
        
        let secondNavigationController  = UINavigationController(rootViewController: addEditViewController)
        
        navigationController?.present(secondNavigationController, animated: true)
    }
    
    // Editing mode:
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
}


// MARK: Delegate Protocol
// Send back a message from the second ViewController method
extension EmojiTableViewController: AddEditViewControllerDelegate {
    
    func finishPassing(emoji: Emoji) {
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            
            emojis[selectedIndexPath.row]  = emoji
            Emoji.saveToFile(emojis: emojis)
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
            
        } else {
            
            let newIndexPath = IndexPath(row: emojis.count, section: 0)
            emojis.append(emoji)
            Emoji.saveToFile(emojis: emojis)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
}

