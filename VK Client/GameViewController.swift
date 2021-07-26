//
//  GameViewController.swift
//  VK Client
//
//  Created by Woodshox on 19.05.21.
//

import UIKit

class GameViewController: UIViewController {


    
    @IBOutlet var Buttons: [UIButton]!
    @IBOutlet weak var nextDigit: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var newGameButton: UIButton!
    
    lazy var game = Game(countItems: Buttons.count, time: 30) { [weak self](status, time) in
        guard let self = self else {return}
        
        self.timerLabel.text = time.secondsToString()
        self.updateInfoGame(with: status)
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()
    }
    
    @IBAction func pressButton(_ sender: UIButton) {
        
        guard let buttonIndex = Buttons.firstIndex(of: sender) else {return}
        game.check(index:buttonIndex)
        updateUI()
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        game.newGame()
        sender.isHidden = true
        setupScreen()
    }
    
    private func setupScreen(){
        
        for index in game.items.indices{
            Buttons[index].setTitle(game.items[index].title, for: .normal)
            //Buttons[index].isHidden = false
            Buttons[index].alpha = 1
            Buttons[index].isEnabled = true
        }
        
        nextDigit.text = game.nextItem?.title
        
    }
    
    private func updateUI(){
        for index in game.items.indices{
//            Buttons[index].isHidden = game.items[index].isFound
            
            Buttons[index].alpha = game.items[index].isFound ? 0 : 1
            Buttons[index].isEnabled = !game.items[index].isFound
            
            if game.items[index].isError{
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self?.Buttons[index].backgroundColor = .red
                } completion: { [weak self] (_) in
                    self?.Buttons[index].backgroundColor = .white
                    self?.game.items[index].isError = false
                }

            }
        }
        nextDigit.text = game.nextItem?.title
        
        updateInfoGame(with: game.status)
    }
    
    private func updateInfoGame(with status:StatusGame){
        switch status {
        case .start:
            statusLabel.text = "Game started."
            statusLabel.textColor = .black
            newGameButton.isHidden = true
        case .win:
            statusLabel.text = "You Won."
            statusLabel.textColor = .green
            newGameButton.isHidden = false
        case .lose:
            statusLabel.text = "You lost."
            statusLabel.textColor = .red
            newGameButton.isHidden = false

        }
    }

}
