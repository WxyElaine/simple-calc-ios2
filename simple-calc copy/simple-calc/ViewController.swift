//
//  ViewController.swift
//  simple-calc
//
//  Created by Xinyi Wang on 10/22/17.
//  Copyright © 2017 Xinyi Wang. All rights reserved.
//
//  Project: simple-calc-ios2
//  Class: INFO 449

import UIKit

class ViewController: UIViewController {
    // Calculator
    @IBOutlet weak var zero: UIButton!
    @IBOutlet weak var one: UIButton!
    @IBOutlet weak var two: UIButton!
    @IBOutlet weak var three: UIButton!
    @IBOutlet weak var four: UIButton!
    @IBOutlet weak var five: UIButton!
    @IBOutlet weak var six: UIButton!
    @IBOutlet weak var seven: UIButton!
    @IBOutlet weak var eight: UIButton!
    @IBOutlet weak var nine: UIButton!
    @IBOutlet weak var point: UIButton!
    @IBOutlet weak var negative: UIButton!
    @IBOutlet weak var add: UIButton!
    @IBOutlet weak var subtract: UIButton!
    @IBOutlet weak var times: UIButton!
    @IBOutlet weak var divide: UIButton!
    @IBOutlet weak var mod: UIButton!
    @IBOutlet weak var equal: UIButton!
    @IBOutlet weak var clear: UIButton!
    @IBOutlet weak var fact: UIButton!
    @IBOutlet weak var count: UIButton!
    @IBOutlet weak var avg: UIButton!
    @IBOutlet weak var enter: UIButton!
    
    @IBOutlet weak var resultArea: UILabel!
    @IBOutlet weak var mode: UISegmentedControl!
    @IBOutlet weak var goToHistory: UIButton!
    
    // Different types of buttons
    var buttons: Array<UIButton> = []
    var numbers: Array<UIButton> = []
    var operators: Array<UIButton> = []
    var multiOperand: Array<UIButton> = []
    // Button size
    var buttonSize = CGFloat(0)
    var buttonWidth = CGFloat(0)
    
    // Data to keep track of the calculating process
    var inputNumbers: [Double] = []
    var lastInput = "0"
    var calcOperator = ""
    var resultText = ""
    var lastOperator: UIButton? = nil
    var currentHistory = ""
    var histories: Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.buttons = [zero, one, two, three, four, five, six, seven, eight, nine, point, negative, add, subtract, times, divide, mod, equal, clear, fact, count, avg, enter]
        self.numbers = [zero, one, two, three, four, five, six, seven, eight, nine, point, negative]
        self.operators = [add, subtract, times, divide, mod]
        self.multiOperand = [fact, count, avg]

//        // Enable auto layout
        mode.translatesAutoresizingMaskIntoConstraints = false
        resultArea.translatesAutoresizingMaskIntoConstraints = false
//        goToHistory.translatesAutoresizingMaskIntoConstraints = false
        for element in buttons {
            element.translatesAutoresizingMaskIntoConstraints = false
        }

        setupLayout(view.frame.height, view.frame.width)
        
        // Display the default view
        for element in multiOperand {
            element.isHidden = true
        }
        enter.isHidden = true
    }
    
    // Takes the screen height and width as parameters, sets up the layout.
    public func setupLayout(_ height: CGFloat, _ width: CGFloat) {
        let borderLeft = CGFloat(Int(width * 0.078))
        let borderRight = -CGFloat(Int(width * 0.078))
        let borderTop = CGFloat(Int(height * 0.03))
        if height >= width {
            buttonSize = CGFloat(Int((width - borderLeft * 2) / 5))
            buttonWidth = buttonSize
        } else {
            buttonSize = CGFloat(Int((height * 0.83 - borderTop * 3.5) / 7))
            buttonWidth = buttonSize * 2
        }

        // mode setup
        // set position
        mode.topAnchor.constraint(equalTo: view.topAnchor, constant: borderTop * 1.3).isActive = true
        mode.leftAnchor.constraint(equalTo: view.leftAnchor, constant: borderLeft).isActive = true
        mode.rightAnchor.constraint(equalTo: view.rightAnchor, constant: borderRight).isActive = true
        // set height
        mode.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.04).isActive = true
        // set font --- mode
        let font = UIFont.systemFont(ofSize: CGFloat(Int((width + height) * 0.04 / 3)))
        mode.setTitleTextAttributes([NSAttributedStringKey.font: font], for: .normal)

        // resultArea
        // set position
        resultArea.topAnchor.constraint(equalTo: mode.bottomAnchor, constant: borderTop).isActive = true
        resultArea.leftAnchor.constraint(equalTo: view.leftAnchor, constant: (width - buttonSize * 4) / 5 + buttonSize).isActive = true
        resultArea.rightAnchor.constraint(equalTo: view.rightAnchor, constant: borderRight).isActive = true
        // set height
        resultArea.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.13).isActive = true
        // set font --- resultArea
        resultArea.minimumScaleFactor = 0.5
        resultArea.adjustsFontSizeToFitWidth = true
        resultArea.font = resultArea.font.withSize(CGFloat(Int(height * 0.13)))
        
        // buttons
        setUpButtons(height, width, borderTop)
        
        // goToHistory
//        goToHistory.centerXAnchor.constraintEqualToSystemSpacingAfter(view.centerXAnchor, multiplier: 0)
//        goToHistory.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -borderTop).isActive = true
//        goToHistory.widthAnchor.constraint(equalToConstant: view.frame.width * 0.1).isActive = true
//        goToHistory.titleLabel!.adjustsFontSizeToFitWidth = true
//        goToHistory.titleLabel!.font = goToHistory.titleLabel!.font.withSize(CGFloat(Int(height * 0.08)))
    }

    // Removes all the previous constraints when the screen rotates.
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        removeViewConstraints(self.view)
    }
    
    // Refreshes the layout
    override func viewWillLayoutSubviews() {
        setupLayout(view.frame.height, view.frame.width)
    }
    
    @IBAction func unwindToViewController(unwindSegue: UIStoryboardSegue) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func numbersOrOperatorsPressed(_ sender: UIButton) {
        if clear.currentTitle != "C" {
            clear.setTitle("C", for: .normal)
        }
        if numbers.contains(sender) {   // handles the case when entering a number
            // enable the disabled button
            if lastOperator != nil {
                setButton(lastOperator!, .white)
                lastOperator = nil
            }
            // handle the case for positive, nagative and decimal number
            switch sender.currentTitle! {
            case ".":
                if !lastInput.contains(".") {
                    lastInput += sender.currentTitle!
                }
            case "(-)":
                if !lastInput.hasPrefix("-") {
                    lastInput = "-" + lastInput
                }
            default:
                if lastInput == "0" {
                    lastInput = sender.currentTitle!
                } else if lastInput == "-0" {
                    lastInput = "-" + sender.currentTitle!
                } else {
                    lastInput += sender.currentTitle!
                }
            }
            resultText = lastInput
        } else {    // handles the case when an operator is pressed
            // enable the disabled button
            if lastOperator != nil {
                setButton(lastOperator!, .white)
                lastOperator = nil
            }
            // disable the pressed button
            lastOperator = sender
            setButton(sender, .yellow)
            // record the input number and operator
            checkIfValid(&lastInput)
            // record the operator
            if sender.currentTitle != "Enter" {
                calcOperator = sender.currentTitle!
            }
        }
        // display the input number
        resultArea.text = resultText
    }
    
    @IBAction func equalPressed(_ sender: UIButton) {
        // record the last input number if exists
        checkIfValid(&lastInput)
        
        if inputNumbers.count >= 2 || calcOperator.count > 1 {
            // enable the disabled button
            if lastOperator != nil {
                setButton(lastOperator!, .white)
                lastOperator = nil
            }
            // calculate the result
            var calcResult = 0.0
            var error = ""
            if calcOperator.count > 1 {     // multi-operand
                switch calcOperator {
                case "count":
                    calcResult = Double(inputNumbers.count)
                case "avg":
                    for i in 0...inputNumbers.count - 1 {
                        calcResult += inputNumbers[i]
                    }
                    calcResult = calcResult / Double(inputNumbers.count)
                default:
                    if inputNumbers.count == 1 && inputNumbers[0] >= 0.0 && inputNumbers[0] - Double(Int(inputNumbers[0])) == 0.0 {
                        calcResult = 1.0
                        for i in 1...Int.init(inputNumbers[0]) {
                            calcResult *= Double(i)
                        }
                    } else {
                        error = "Error"
                    }
                }
            } else {      // + - × ÷ %
                switch calcOperator {
                case "+":
                    calcResult = inputNumbers[0] + inputNumbers[1]
                case "−":
                    calcResult = inputNumbers[0] - inputNumbers[1]
                case "×":
                    calcResult = inputNumbers[0] * inputNumbers[1]
                case "÷":
                    if inputNumbers[1] != 0.0 {
                        calcResult = inputNumbers[0] / inputNumbers[1]
                    } else {
                        error = "Error"
                    }
                default:
                    if inputNumbers[1] != 0.0 {
                        let mod = Int(inputNumbers[0]) - (Int(inputNumbers[0]) / Int(inputNumbers[1])) * Int(inputNumbers[1])
                        calcResult = Double(mod)
                    } else {
                        error = "Error"
                    }
                }
            }
            // display result
            if error != "" {
                clearAction(clear, "AC", error)
                error = ""
            } else if calcResult - Double(Int(calcResult)) != 0.0 {
                clearAction(clear, "AC", calcResult)
            } else {
                clearAction(clear, "AC", Int(calcResult))
            }
        }
    }
    
    @IBAction func clearPressed(_ sender: UIButton) {
        clearAction(sender, sender.currentTitle!, 0)
    }
    
    /* Takes the clear button, the button title and the text to display after the data
         has been cleaned as parameters. Clears all data or the last input number
         based on the button title, and displays the given text. */
    private func clearAction<IntDoubleString> (_ sender: UIButton, _ currentTitle: String, _ text: IntDoubleString) {
        // enable the disabled button
        if lastOperator != nil {
            setButton(lastOperator!, .white)
            lastOperator = nil
        }
        // record the last input number if exists
        if calcOperator != "" {
            checkIfValid(&lastInput)
        }
        // initialize the final result as a String
        let finalResult = String.init(describing: text)
        // record the calculation history
        if !inputNumbers.isEmpty && !calcOperator.isEmpty{
            switch mode.selectedSegmentIndex {
            case 1:
                for input in inputNumbers {
                    currentHistory += "\(input) "
                }
                currentHistory += "\(calcOperator) = \(finalResult)"
            case 2:
                currentHistory = "\(inputNumbers[0]) \(inputNumbers[1]) \(calcOperator) = \(finalResult)"
            default:
                currentHistory = "\(inputNumbers[0]) \(calcOperator) \(inputNumbers[1]) = \(finalResult)"
            }
        }
        histories.append(currentHistory)
        currentHistory = ""
        // clear
        if currentTitle == "AC" {   // clear everything
            calcOperator = ""
            inputNumbers.removeAll()
            currentHistory = ""
        } else if inputNumbers.count != 0 {     // clear the last input number
            inputNumbers.remove(at: inputNumbers.count - 1)
        }
        lastInput = "0"
        resultText = ""
        // display the result
        resultArea.text = finalResult
        sender.setTitle("AC", for: .normal)
    }
    
    @IBAction func viewChanged(_ sender: UISegmentedControl) {
        // clear all previous data
        clearAction(clear, "AC", 0)
        
        switch sender.selectedSegmentIndex {
        case 1:
            hideOrDisplay(operators, true)
            hideOrDisplay(multiOperand, false)
            hideOrDisplay([enter], true)
        case 2:
            hideOrDisplay(operators, false)
            hideOrDisplay(multiOperand, true)
            hideOrDisplay([enter], false)
        default:
            hideOrDisplay(operators, false)
            hideOrDisplay(multiOperand, true)
            hideOrDisplay([enter], true)
        }
    }
    
    // Sends the histories to the History view.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let historyView = segue.destination as! HistoryViewController
        historyView.historyList = histories
        histories.removeAll()
    }
    
    /* Takes a string as parameter. Checks if the given string is a valid number. Records the number if it is valid, records 0.0 if not. */
    func checkIfValid(_ checkString: inout String) {
        if checkString != "0" {
            let range = checkString.startIndex..<checkString.endIndex
            let correctRange = checkString.range(of: "^[+-]?[0-9]+(.[0-9]?)?$", options: .regularExpression)
            if correctRange == range {
                inputNumbers.append(Double.init(checkString)!)
            } else {
                inputNumbers.append(0.0)
            }
        checkString = "0"
        }
    }
    
    /* Takes a UIView as parameter and removes all constraints of its children. */
    private func removeViewConstraints(_ view: UIView) {
        if view.subviews.count > 0 {
            for element in view.subviews {
                removeViewConstraints(element)
            }
        }
        view.removeConstraints(view.constraints)
    }
    
    /* Takes an array of UIButtons and a Bool indicating whether to hide or display
     buttons as parameters. Hides or displays the button(s) accordingly. */
    private func hideOrDisplay(_ element: Array<UIButton>, _ hide: Bool) {
        if hide {
            for i in element {
                i.isHidden = true
            }
        } else {
            for i in element {
                i.isHidden = false
            }
        }
    }
    
    /* Takes a UIButton and an Optional UIColor as parameters. Enables or disables the
     button and changes its appearance. */
    private func setButton(_ button: UIButton, _ color: UIColor?) {
        button.isEnabled = !button.isEnabled
        button.setTitleColor(color, for: .normal)
    }
    
    /* Takes the screen height, wdith and the calculated top border as parameters.
     Sets up constraints for all buttons. */
    private func setUpButtons(_ height: CGFloat, _ width: CGFloat, _ borderTop: CGFloat) {
        let doubleWidthButtons: Array<UIButton> = [count, equal]
        let squareButtons: Array<UIButton> = [zero, one, two, three, four, five, six, seven, eight, nine, point, negative, add, subtract, times, divide, mod, clear, fact, avg, enter]
        let leftAlignOne: Array<UIButton> = [zero, one, four, seven, clear, enter]
        let leftAlignTwo: Array<UIButton> = [point, two, five, eight, negative]
        let leftAlignThree: Array<UIButton> = [equal, three, six, nine, mod, count]
        let leftAlignFour: Array<UIButton> = [add, subtract, times, divide, avg, fact]
        let allAlignLeft: Array<Array<UIButton>> = [leftAlignOne, leftAlignTwo, leftAlignThree, leftAlignFour, [enter]]
        
        let bottomAlignOne: Array<UIButton> = [zero, point, equal]
        let bottomAlignTwo: Array<UIButton> = [one, two, three, add]
        let bottomAlignThree: Array<UIButton> = [four, five, six, subtract]
        let bottomAlignFour: Array<UIButton> = [seven, eight, nine, times]
        let bottomAlignFive: Array<UIButton> = [clear, negative, mod, divide, count]
        let allAlignBottom: Array<Array<UIButton>> = [bottomAlignOne, bottomAlignTwo, bottomAlignThree, bottomAlignFour, bottomAlignFive, [enter]]
        
        let buttonBorderLeft = CGFloat(Int((width - buttonWidth * 4) / 5))
        let borderBottom = -CGFloat(Int((height * 0.83 - borderTop * 3.3 - buttonSize * 5) / 5))
        
        for element in buttons {
            // set height
            element.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
            // set font --- buttons
            element.titleLabel!.font = element.titleLabel!.font.withSize(CGFloat(Int(buttonSize / 2)))
            element.titleLabel!.adjustsFontSizeToFitWidth = true
            // change button appearance
            element.layer.cornerRadius = buttonSize / 2
        }
        // set width
        for element in doubleWidthButtons {
            element.widthAnchor.constraint(equalToConstant: buttonWidth * 2 + buttonBorderLeft).isActive = true
        }
        for element in squareButtons {
            element.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        }
        // set position
        for index in 0...allAlignLeft.count - 1 {
            for element in allAlignLeft[index] {
                element.leftAnchor.constraint(equalTo: view.leftAnchor, constant: buttonBorderLeft * CGFloat(index + 1) + buttonWidth * CGFloat(index)).isActive = true
            }
        }
        for index in 0...allAlignBottom.count - 1 {
            for element in allAlignBottom[index] {
                element.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: borderBottom * CGFloat(index + 1) - buttonSize * CGFloat(index) - borderTop).isActive = true
            }
        }
        // set fact and avg buttons
        fact.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -buttonSize * 2 + borderBottom * 2.5).isActive = true
        avg.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -buttonSize * 3 + borderBottom * 3.5).isActive = true
    }
}
