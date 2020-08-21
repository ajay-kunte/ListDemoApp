//
//  TaskListViewModel.swift
//  Zalck
//
//  Created by Tudip Technologies on 17/02/20.
//  Copyright © 2020 Zalck. All rights reserved.
//

import Foundation

protocol TaskListViewModelDelegate: class {
    func getProjectTasksSuccessful(model: TaskDataModel)
}

class TaskListViewModel {
    
    weak var delegate: TaskListViewModelDelegate?
    
    func getProjectTasks() {
        let parameters = ["projectId": 1]
        APIService.getTicketsForAProject(requestEndPoint: .getTicketsForAProject(parameters: parameters)) { (model: TaskDataModel?, error: Error?) -> Void in
            if let model = model, model.status == "success" {
                self.delegate?.getProjectTasksSuccessful(model: model)
            } else {
                
            }
        }
    }
    
}
