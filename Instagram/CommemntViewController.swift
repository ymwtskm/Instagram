//
//  CommemntViewController.swift
//  Instagram
//
//  Created by 小西椋磨 on 2018/02/19.
//  Copyright © 2018年 ryoma.konishi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SVProgressHUD

class CommemntViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    var index = 0
    var postArray: [PostData] = []
    var commentArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let postDate = postArray[index]
        let comment = postDate.comment
        return comment.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let postDate = postArray[index]
        let comment = postDate.comment
        let com = comment[indexPath.row]
        cell.textLabel?.text = com
        return cell
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func commentButton(_ sender: Any) {
        if textField.text != "" {
            if let user = Auth.auth().currentUser?.displayName {
                let commentText = textField.text!
                let postDate = postArray[index]
                commentArray = postDate.comment
                postDate.comment.insert(commentText, at: 0)
                commentArray.insert("\(user):\(commentText)", at: 0)
            }
        
            let postDate = postArray[index]
            postDate.comment = commentArray
                print("コメント\(commentArray)")
            // 増えたcommentをFirebaseに保存する
            let postRef = Database.database().reference().child(Const.PostPath).child(postDate.id!)
            let comment = ["comment": postDate.comment]
            postRef.updateChildValues(comment)
            tableView.reloadData()
            textField.text = nil
        }
    }
}
