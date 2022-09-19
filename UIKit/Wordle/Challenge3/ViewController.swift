//
//  ViewController.swift
//  Challenge3
//
//  Created by Azoz Salah on 08/09/2022.
//

import UIKit

class ViewController: UIViewController {
    var currentWord: UITextField!
    var letterButtons = [UIButton]()
    let letters: [Character] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    var words = [String]()
    var currentSolution = ""
    var usedButtons = [UIButton]()
    var scoreLabels = [UILabel]()
    var lives = 7
    
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.secondarySystemBackground

        let scoreView = UIView()
        scoreView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scoreView)
        
        currentWord = UITextField()
        currentWord.text = "???"
        currentWord.translatesAutoresizingMaskIntoConstraints = false
        currentWord.textAlignment = .center
        currentWord.isUserInteractionEnabled = false
        currentWord.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        currentWord.font = UIFont.systemFont(ofSize: 44)
        view.addSubview(currentWord)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        
        NSLayoutConstraint.activate([
            scoreView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scoreView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scoreView.heightAnchor.constraint(equalToConstant: 50),
            scoreView.widthAnchor.constraint(equalToConstant: 210),
            
            currentWord.topAnchor.constraint(equalTo: scoreView.bottomAnchor, constant: 40),
            currentWord.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentWord.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 400),
            buttonsView.heightAnchor.constraint(equalToConstant: 300),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: currentWord.bottomAnchor, constant: 100),
            buttonsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
            
        ])
        
        let scoreWidth = 30
        let scoreHeight = 50
        
        for column in 0..<7 {
            let scoreLabel = UILabel()
            scoreLabel.font = UIFont.systemFont(ofSize: 20)
            scoreLabel.text = "❤️"
            
            let frame = CGRect(x: column * scoreWidth, y: 0, width: scoreWidth - 3, height: scoreHeight)
            scoreLabel.frame = frame
            
            scoreView.addSubview(scoreLabel)
            scoreLabels.append(scoreLabel)
        }
        
        let height = 75
        let width = 57
        
        for row in 0..<4 {
            for column in 0..<7 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterButton.setTitle("Z", for: .normal)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                letterButton.layer.borderWidth = 1
                letterButton.layer.borderColor = UIColor.lightGray.cgColor
                
                let frame = CGRect(x: (column * width), y: (row * height), width: width - 3, height: height - 3)
                letterButton.frame = frame
                
                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
            }
        }
        letterButtons[21].removeFromSuperview()
        letterButtons[27].removeFromSuperview()
        letterButtons.remove(at: 21)


//        let EnterButton = UIButton(type: .system)
//        EnterButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
//        EnterButton.setTitle("ENTER", for: .normal)
//        EnterButton.layer.borderWidth = 1
//        EnterButton.layer.borderColor = UIColor.lightGray.cgColor
//
//        let frame = CGRect(x: 5 * width, y: 3 * height, width: 111, height: height - 3)
//        EnterButton.frame = frame
//
//        buttonsView.addSubview(EnterButton)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "WORDLE"
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Restart", style: .plain, target: self, action: #selector(playAgain))
        
        settingUp()
        
    }
    
    func settingUp() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let url = Bundle.main.url(forResource: "start", withExtension: "txt") {
                if let contents = try? String(contentsOf: url) {
                    self?.words = contents.components(separatedBy: "\n")
                    self?.words.shuffle()
                    self?.currentSolution = (self?.words.randomElement())!
                }
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            for i in 0..<(self?.letters.count)! {
                self?.letterButtons[i].setTitle(String((self?.letters[i])!), for: .normal)
            }
            
            self?.currentWord.text = String(repeating: "?", count: (self?.currentSolution.count)!)
        }
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        usedButtons.append(sender)
        
        guard let buttonTitle = sender.titleLabel?.text  else { return }
        
        var updateText: [Character] = Array(currentWord.text!)
        
        if currentSolution.contains(buttonTitle.lowercased()) {
            for (index, letter) in currentSolution.enumerated() {
                if letter == Character(buttonTitle.lowercased()) {
                    updateText[index] = letter
                }
            }
            currentWord.text = String(updateText)
            
            if currentWord.text == currentSolution {
                levelUp()
            }
        }else {
            wrongAnswer()
        }
        sender.isHidden = true
    }
    
    func wrongAnswer() {
        lives -= 1
        scoreLabels[lives].isHidden = true
        if lives != 0 {
            let ac = UIAlertController(title: "Wrong letter", message: "Remaining tries: \(lives)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            present(ac, animated: true)
        }else {
            let ac = UIAlertController(title: "You lost", message: "The word was: \(currentSolution)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Play again", style: .default, handler: playAgain))
            present(ac, animated: true)
        }
    }
    
    @objc func playAgain(_ action: UIAlertAction) {
        settingUp()
        lives = 7
        for i in scoreLabels {
            i.isHidden = false
        }
        for i in usedButtons {
            i.isHidden = false
        }
    }
    
    func levelUp() {
        let ac = UIAlertController(title: "You won!", message: "Let's go to the next level!", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: playAgain))
        present(ac, animated: true)
    }


}

