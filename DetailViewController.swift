//
//  DetailViewController.swift
//  MapApplication
//
//  Created by Vishwajeet Dagar on 1/20/17.
//  Copyright © 2017 Vishwajeet. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var locate: String=""
    @IBOutlet weak var temp: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        temp.text=locate
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
