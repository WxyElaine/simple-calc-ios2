//
//  HistoryViewController.swift
//  simple-calc
//
//  Created by Xinyi Wang on 10/31/17.
//  Copyright © 2017 Xinyi Wang. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    @IBOutlet weak var historyViewTitle: UILabel!
    @IBOutlet weak var historyView: UIScrollView!
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var clear: UIButton!
    
    var historyList: Array<String> = []
    var allHistories: Array<String> = []
    var historyLabels: Array<UILabel> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        back.translatesAutoresizingMaskIntoConstraints = false
        clear.translatesAutoresizingMaskIntoConstraints = false
        historyViewTitle.translatesAutoresizingMaskIntoConstraints = false
        
        historyView.translatesAutoresizingMaskIntoConstraints = false
        historyView.backgroundColor = UIColor(red:0.97, green:0.96, blue:0.98, alpha:1.0)
        allHistories.append(contentsOf: historyList)
        historyList.removeAll()
        if !allHistories.isEmpty {
            var even = true
            for i in 0...allHistories.count - 1 {
                let itemFrame = CGRect.init(origin: view.frame.origin, size: CGSize.init(width: historyView.frame.width, height: view.frame.height / 9))
                let item = UILabel.init(frame: itemFrame)
                item.text = allHistories[i]
                if even {
                    item.backgroundColor = UIColor(red: 0.91, green: 0.89, blue: 0.95, alpha: 1.0)
                } else {
                    item.backgroundColor = UIColor(red: 0.80, green: 0.75, blue: 0.87, alpha: 1.0)
                }
                item.translatesAutoresizingMaskIntoConstraints = false
                historyLabels.append(item)
                even = !even
            }
        }
        
        setUpLayout(self.view.frame.height, self.view.frame.width)
    }
    
    public func setUpLayout(_ height: CGFloat, _ width: CGFloat) {
        historyView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: CGFloat(Int(width * 0.078))).isActive = true
        historyView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -CGFloat(Int(width * 0.078))).isActive = true
        historyView.topAnchor.constraint(equalTo: view.topAnchor, constant: CGFloat(Int(height * 0.039))).isActive = true
        historyViewTitle.centerXAnchor.constraintEqualToSystemSpacingAfter(view.centerXAnchor, multiplier: 1).isActive = true
        historyViewTitle.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        historyViewTitle.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        historyViewTitle.adjustsFontSizeToFitWidth = true
        historyViewTitle.font = historyViewTitle.font.withSize(CGFloat(Int(height * 0.048)))
        
        back.leftAnchor.constraint(equalTo: view.leftAnchor, constant: CGFloat(Int(width * 0.09))).isActive = true
        back.topAnchor.constraint(equalTo: view.topAnchor, constant: CGFloat(Int(height * 0.078))).isActive = true
        back.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.045).isActive = true
        back.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25).isActive = true
        back.titleLabel!.adjustsFontSizeToFitWidth = true
        back.titleLabel!.font = back.titleLabel!.font.withSize(CGFloat(Int(height * 0.04)))
        
        clear.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -CGFloat(Int(width * 0.09))).isActive = true
        clear.topAnchor.constraint(equalTo: view.topAnchor, constant: CGFloat(Int(height * 0.078))).isActive = true
        clear.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.045).isActive = true
        clear.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25).isActive = true
        clear.titleLabel!.adjustsFontSizeToFitWidth = true
        clear.titleLabel!.font = clear.titleLabel!.font.withSize(CGFloat(Int(height * 0.04)))
        
        let contentHeight = historyViewTitle.frame.height
        let itemHeight = (view.frame.height - contentHeight) / 8
        if !historyLabels.isEmpty {
            for i in 0...historyLabels.count - 1 {
                historyView.addSubview(historyLabels[i])

                historyLabels[i].topAnchor.constraint(equalTo: view.topAnchor, constant: CGFloat(Int(height * 0.09 + itemHeight * (CGFloat(i) + 1)))).isActive = true
                historyLabels[i].leftAnchor.constraint(equalTo: view.leftAnchor, constant: CGFloat(Int(width * 0.078))).isActive = true
                historyLabels[i].widthAnchor.constraint(equalToConstant: historyView.frame.width)
                historyLabels[i].heightAnchor.constraint(equalToConstant: itemHeight)
                historyLabels[i].adjustsFontSizeToFitWidth = true
                historyLabels[i].font = historyLabels[i].font.withSize(CGFloat(Int(itemHeight * 2 / 3)))
                historyLabels[i].setNeedsLayout()
                historyLabels[i].layoutIfNeeded()
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        removeViewConstraints(self.view)
        
        for item in historyLabels {
            item.removeConstraints(item.constraints)
        }
    }

    // Refreshes the layout
    override func viewWillLayoutSubviews() {
        setUpLayout(self.view.frame.height, self.view.frame.width)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func removeViewConstraints(_ view: UIView) {
        if view.subviews.count > 0 {
            for element in view.subviews {
                removeViewConstraints(element)
            }
        }
        view.removeConstraints(view.constraints)
    }
    
    @IBAction func clearHistoryPressed(_ sender: UIButton) {
        allHistories.removeAll()
        for label in historyLabels {
            historyView.willRemoveSubview(label)
            setUpLayout(view.frame.height, view.frame.width)
        }
        historyLabels.removeAll()
    }
}
