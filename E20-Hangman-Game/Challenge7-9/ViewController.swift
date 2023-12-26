//
//  ViewController.swift
//  Challenge7-9
//
//  Created by Mahmud CIKRIK on 12.10.2023.
//

import UIKit

class ViewController: UIViewController {
    
    
    var scoreLabel: UILabel!
    var levelLabel: UILabel!
    var currentQuestionWord: UITextField!
    var shuffledLevelWords = [String?]()
    
    var letterButtons = [UIButton]()
    
    var activatedButtons = [UIButton]()
    var levelWords = [String]()
    var answeredWords = [String]()
    var currentQuestionLetters = [String]()
    var yeniWord = ""
    var newWord = ["R", "T"]
    var acilanHarfler = ["R", "T"]
    
    var word = ""
    var usedLetters = ["R", "T"]
    var promptWord = ""
    var hiddenCurrentWord = ""
    var hiddenCurrentWord2 = ""
    var hiddenCurrentLetters = [String]()
    
    var score = 0 {
        
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
        
    }
    
    var level = 1 {
        
        didSet {
            
            levelLabel.text = "Level: \(level)"
            
        }
        
    }
    var health = 7
    var x = 0
    
    var clueString = ""
    var solutionString = ""
    var alphabetString = [String]()
    
    override func loadView() {
        
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.text = "Score: 0"
        scoreLabel.textAlignment = .right
        view.addSubview(scoreLabel)
        
        levelLabel = UILabel()
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        levelLabel.text = "Level: 1"
        levelLabel.textAlignment = .left
        view.addSubview(levelLabel)
        
        currentQuestionWord = UITextField()
        currentQuestionWord.translatesAutoresizingMaskIntoConstraints = false
        currentQuestionWord.placeholder = hiddenCurrentWord
        currentQuestionWord.textAlignment = .center
        currentQuestionWord.font = UIFont.systemFont(ofSize: 30)
        currentQuestionWord.isUserInteractionEnabled = false
        view.addSubview(currentQuestionWord)
        
        let buttonsView = UIView() //container gibi
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
        
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            levelLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            levelLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            
            currentQuestionWord.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentQuestionWord.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
//            currentQuestionWord.topAnchor.constraint(equalTo: levelLabel.bottomAnchor, constant: 20),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 315),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: currentQuestionWord.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
            
            
        ])
    
        let width = 45
        let height = 45
            
            for row in 0..<4 {
                for column in 0..<7 {
                    let letterButton = UIButton(type: .system)
                    letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                    letterButton.setTitle("W", for: .normal)
                    letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                    letterButton.layer.borderColor = UIColor.gray.cgColor
                    letterButton.layer.borderWidth = 0.5
                    letterButton.layer.cornerRadius = 3
                    
                    
                    let frame = CGRect(x: column * width, y: row * height , width: width-5, height: height-5)
                    letterButton.frame = frame
                    
                    buttonsView.addSubview(letterButton)
                    letterButtons.append(letterButton)
                    
                    if letterButtons.count == 26 {
                        return
                    }
                    
                }
                
                
            }
        
        
    }
    
    @objc func letterTapped (_ sender: UIButton) {
        
        guard let buttonTitle = sender.titleLabel?.text else {return} //safety check if have title in button
        
        
        if newWord.contains(buttonTitle) {
            
            
            if let harfIndex = newWord.firstIndex(of: buttonTitle) {
                
                let buttonTitleString = String(buttonTitle)  // Karakteri bir String'e dönüştürün
                var gosterilenIndex = hiddenCurrentWord.startIndex
                yeniWord = newWord.joined()
                
                while let range = yeniWord.range(of: buttonTitle, range: gosterilenIndex..<hiddenCurrentWord.endIndex) {
                    hiddenCurrentWord.removeSubrange(range)
                    hiddenCurrentWord.insert(contentsOf: buttonTitle, at: range.lowerBound)
                    gosterilenIndex = range.upperBound
                }
                
            }
        }
            
        currentQuestionWord.text = hiddenCurrentWord
//        currentQuestionWord.text = hiddenCurrentWord.appending(buttonTitle)
// ????????? Sender ne işe yarıyor?? append sender yapınca ne oluyor? appending append farkı??
        activatedButtons.append(sender)
        sender.isHidden = true
        
        guard let answerText = shuffledLevelWords[x] else { return }
        // ilk aranan kelime answer text'e eşitlendi
        if let solutionPosition = shuffledLevelWords.firstIndex(of: answerText) {
        // levelWords'te pozisyonu bulundu int olarak.
            
            
            if shuffledLevelWords[solutionPosition] == hiddenCurrentWord {
                
                answeredWords.append(answerText)
                score += 1
                x += 1
                newWord = levelWords[x].map { String($0)}
                print(x)
               // currentQuestionWord.text = levelWords[x]
                hiddenCurrentLetters = levelWords[x].map{ _  in "?" }
                hiddenCurrentWord = hiddenCurrentLetters.joined()
                hiddenCurrentWord = hiddenCurrentWord.trimmingCharacters(in: .whitespacesAndNewlines)
                currentQuestionWord.text = hiddenCurrentWord
                print(levelWords[x])
               
                for button in activatedButtons {
                    button.isHidden = false
                 
                }
                activatedButtons.removeAll()
                
            }

            
            if score*level >= (level*7)-2 && levelWords == answeredWords {
                
                let ac = UIAlertController(title: "Well Done!", message: "Are you ready for next level?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's Go!", style: .default, handler: levelUp))
                present(ac, animated: true)
                
                
            }
            
            
        } else {
            
            let ac = UIAlertController(title: "Oops! Wrong Answer!", message: "Try Again", preferredStyle: .alert)
//            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: clearWrongAnswer))
            present(ac, animated: true)
            score -= 1
        
    }
        
        
        
        
        
    }
            
            
            
//            for i in 1..<levelWords.count {
//
//                currentQuestionWord.text = levelWords[i]
//
//            }
            
            
            
     
            
            
            
//        if let solutionPosition = levelWords.firstIndex(of: answerText) {
//
//            activatedButtons.removeAll()
//
//            var splitAnswers = answersLabel.text?.components(separatedBy: "\n")
//            splitAnswers?[solutionPosition] = answerText
//            answersLabel.text = splitAnswers?.joined(separator: "\n")
//
//            currentQuestionWord.text = ""
//            score += 1
            

    
    @objc func loadLevel () {
    
        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            
            if let levelContents = try? String(contentsOf: levelFileURL) {
                
                    // buraya kadarki tüm işlem dosyaya ulaşmak için. şimdi ise dosyanın içindeki her ayrı satırı çağıracağız.
                
                levelWords = levelContents.components(separatedBy: "\n")
                levelWords.shuffle()
                shuffledLevelWords = levelWords
                word = shuffledLevelWords[x]!
//                print("loading1: \(word)")
                newWord = word.map { String($0)}
//                print("loading2: \(newWord)")
                hiddenCurrentLetters = word.map{ _  in "?" }
                hiddenCurrentWord = hiddenCurrentLetters.joined()
                
     
                
//                for (index, line) in lines.enumerated() {
//
//                    let parts = line.components(separatedBy: ": ")
//                    let answer = parts[0]
//                    let clue = parts[1]
//
//                    clueString += "\(index + 1). \(clue)\n"
//
//                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
//                    solutionString += "\(solutionWord.count) letters\n"
//                    solutions.append(solutionWord)
//
//                    let bits = answer.components(separatedBy: "|")
//                    letterBits += bits
//
//                }
                
            }
            
        }
        
        performSelector(onMainThread: #selector(loadGameContent), with: nil, waitUntilDone: false)
  
        
    }
    
    func levelUp (action: UIAlertAction) {

        level += 1
        x = 0
        
        levelWords.removeAll(keepingCapacity: true)
        loadLevel()
        
        for button in letterButtons {
            button.isHidden = false
        }
        
    }

    
    @objc func loadGameContent () {
        
        
        if let levelFileURL = Bundle.main.url(forResource: "alphabet", withExtension: "txt") {
            
            if let levelContents = try? String(contentsOf: levelFileURL) {
                
                // buraya kadarki tüm işlem dosyaya ulaşmak için. şimdi ise dosyanın içindeki her ayrı satırı çağıracağız.
                
                alphabetString = levelContents.components(separatedBy: "\n")
                
                for i in 0..<letterButtons.count {
                    
                    letterButtons[i].setTitle(alphabetString[i], for: .normal)
                    
                }
                
            }
            
        }
        
        currentQuestionWord.text = hiddenCurrentWord
    
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        performSelector(inBackground: #selector(loadLevel), with: nil)

    }


    
    
    
}

