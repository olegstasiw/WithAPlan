//
//  AlertController.swift
//  With a Plan
//
//  Created by mac on 17.09.2020.
//  Copyright © 2020 Oleg Stasiw. All rights reserved.
//

import UIKit

class AlertController: UIAlertController {
    func action(firstTitle: String, secondTitle: String, completion: @escaping () -> Void, completionTwo: (() -> Void)? = nil ) {
        
        let okAction = UIAlertAction(title: firstTitle, style: UIAlertAction.Style.destructive, handler: { _ in
            completion()
        })
        
        let noAction = UIAlertAction(title: secondTitle,
                                     style: UIAlertAction.Style.default, handler: { _ in

                                        guard let completionTwo = completionTwo else {return}
                                        completionTwo()
                                     })
        
        addAction(okAction)
        addAction(noAction)
    }
    
    func actionWithoutAction() {
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive)

        addAction(okAction)

    }

}
