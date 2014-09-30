//
//  CollectionsTableViewController.swift
//  TweaksDemo
//
//  Created by dasdom on 28.09.14.
//  Copyright (c) 2014 Dominik Hauser. All rights reserved.
//

import UIKit

class CollectionsTableViewController: UITableViewController {

    let collections: [TweakCollection]
    
    init(collections: [TweakCollection]) {
        self.collections = collections
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerClass(StepperTableViewCell.self, forCellReuseIdentifier: "StepperCell")
        tableView.registerClass(SwitchTableViewCell.self, forCellReuseIdentifier: "SwitchCell")
        tableView.rowHeight = 44
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "dismiss:")
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return collections.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collections[section].allTweaks().count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell?

        let tweak: AnyObject = collections[indexPath.section].allTweaks()[indexPath.row]
        println("tweak: \(tweak)")
        if let tweak = tweak as? Tweak<Int> {
            println("Tweak<Int>: currentValue \(tweak.currentValue)")
            let stepperCell = tableView.dequeueReusableCellWithIdentifier("StepperCell", forIndexPath: indexPath) as StepperTableViewCell
            configStepperCell(stepperCell, tweak: tweak)
            stepperCell.stepper.value = Double(tweak.currentValue!)
            stepperCell.stepper.stepValue = 1
            cell = stepperCell
        } else if let tweak = tweak as? Tweak<Float> {
            println("Tweak<Float>: currentValue \(tweak.currentValue)")
            let stepperCell = tableView.dequeueReusableCellWithIdentifier("StepperCell", forIndexPath: indexPath) as StepperTableViewCell
            configStepperCell(stepperCell, tweak: tweak)
            stepperCell.stepper.value = Double(tweak.currentValue!)
            stepperCell.stepper.stepValue = 0.01
            cell = stepperCell
//        } else if let tweak = tweak as? Tweak<CGFloat> {
//            println("tweak is CGFloat: \(tweak.currentValue)")
//            configStepperCell(cell, tweak: tweak)
//            cell.stepper.value = Double(tweak.currentValue!)
//            cell.stepper.stepValue = 0.01
        } else if let tweak = tweak as? Tweak<Double> {
            println("Tweak<Double>: currentValue \(tweak.currentValue)")
            let stepperCell = tableView.dequeueReusableCellWithIdentifier("StepperCell", forIndexPath: indexPath) as StepperTableViewCell
            configStepperCell(stepperCell, tweak: tweak)
            stepperCell.stepper.value = tweak.currentValue!
            stepperCell.stepper.stepValue = 0.01
            cell = stepperCell
        } else if let tweak = tweak as? Tweak<Bool> {
            println("Tweak<Bool>: currentValue \(tweak.currentValue)")
            let switchCell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as SwitchTableViewCell
            switchCell.nameLable.text = tweak.name
            switchCell.valueSwitch.on = tweak.currentValue!
            switchCell.valueSwitch.addTarget(self, action: "changeBoolValue:", forControlEvents: .ValueChanged)
            cell = switchCell
        } else {
            println("tweak is something else")
        }

        return cell!
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return collections[section].name
    }
    
    func configStepperCell<T>(cell: StepperTableViewCell, tweak: Tweak<T>) {
        cell.nameLabel.text = tweak.name
        cell.valueLabel.text = "\(tweak.currentValue!)"
        cell.stepper.addTarget(self, action: "changeCurrentValue:", forControlEvents: .ValueChanged)
    }
    
    func changeCurrentValue(sender: UIStepper) {
        if let indexPath = indexPathForCellSubView(sender) {
            let tweak: AnyObject = collections[indexPath.section].allTweaks()[indexPath.row]
            if let tweak = tweak as? Tweak<Int> {
                tweak.currentValue = Int(sender.value)
            } else if let tweak = tweak as? Tweak<Float> {
                tweak.currentValue = Float(sender.value)
//            } else if let tweak = tweak as? Tweak<CGFloat> {
//                tweak.currentValue = CGFloat(sender.value)
            } else if let tweak = tweak as? Tweak<Double> {
                tweak.currentValue = sender.value
            }
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        }
    }
    
    func changeBoolValue(sender: UISwitch) {
        if let indexPath = indexPathForCellSubView(sender) {
            let tweak: AnyObject = collections[indexPath.section].allTweaks()[indexPath.row]
            if let tweak = tweak as? Tweak<Bool> {
                tweak.currentValue = sender.on
            }
//            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        }
    }
    
    func indexPathForCellSubView(view: UIView) -> NSIndexPath? {
        let convertedPoint = view.superview!.convertPoint(view.center, toView: tableView)
        let indexPath = tableView.indexPathForRowAtPoint(convertedPoint)
        println("indexPath \(indexPath)")
        return indexPath
    }
    
    func dismiss(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
