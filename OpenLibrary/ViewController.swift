//
//  ViewController.swift
//  OpenLibrary
//
//  Created by Carlos Manzanas on 25/09/16.
//  Copyright (c) 2016 foskon. All rights reserved.
//


import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var textview: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.textfield.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func searchISBN(isbn: String) {
        let session = NSURLSession.sharedSession()
        let search = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:{ISBN}"
        let searchISBN = search.stringByReplacingOccurrencesOfString("{ISBN}", withString: isbn)
        let url = NSURL(string: searchISBN)
        let req = NSURLRequest(URL: url!)
        let task = session.dataTaskWithRequest(req, completionHandler: {
            (data: NSData?, response: NSURLResponse?, error: NSError?) in
            guard let mData = data
                else {
                    let alert = UIAlertController(title: "Error", message: "Error de red", preferredStyle: .Alert)
                    self.presentViewController(alert, animated: true, completion: nil)
                    return
            }
            
            let json = String(data: mData, encoding: NSUTF8StringEncoding)
            dispatch_sync(dispatch_get_main_queue(), {
                self.textview.text = json
            })
        })
        
        task.resume()
    }

}

extension ViewController: UITextFieldDelegate {

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.searchISBN(textField.text!)
        return true
    }

}
