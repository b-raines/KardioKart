//
//  RaceTrackViewController.swift
//  KardioKart
//
//  Created by Robinson Greig on 10/25/15.
//  Copyright © 2015 Kartio. All rights reserved.
//

import UIKit

class RaceTrackViewController: UIViewController {
    @IBOutlet weak var trackPath: UIView!
    @IBOutlet weak var lapCount: UILabel!
    @IBOutlet weak var userPlace: UILabel!
    var users: [PFObject]?

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        queryUsers()
        updateCurrentLapLabel()
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateLapPositionLabel(position: Int) {
        let postfixDict: [Int: String] = [0: "th", 1: "st", 2: "nd", 3: "rd", 4: "th", 5: "th", 6: "th", 7: "th", 8: "th", 9: "th"]
        let userPosition = position + 1;
        let userPositionLastDigit = userPosition % 10
        let userPositionPostfix = postfixDict[userPositionLastDigit]!
        userPlace.text = "\(userPosition)\(userPositionPostfix) Place"
    }
    
    func updateCurrentLapLabel() {
        if let user = PFUser.currentUser(){
            let lapLength:Double = 2500
            let totalLaps:Int = 20
            let step_count = user["stepCount"] as? Double ?? 0.0
            let currentLap:Int = Int(step_count / lapLength)
            lapCount.text = "Lap \(currentLap) of \(totalLaps)"
        }
    }
    
    func queryUsers() {
        let query = PFUser.query()
        query?.orderByDescending("stepCount")
        query?.findObjectsInBackgroundWithBlock { (result, error) -> Void in
            if let result = result {
                for (index, user) in result.enumerate() {
                    self.users = result
                    if let currentUser = PFUser.currentUser(){
                        let userEmail = user["email"] as? String
                        let currentUserEmail = currentUser["email"] as? String
                        if userEmail == currentUserEmail {
                            self.updateLapPositionLabel(index)
                        }
                    }
                }
            }
        }
    }
}
