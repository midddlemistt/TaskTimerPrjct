//
//  NewTaskViewController.swift
//  TaskTimerProjct
//
//  Created by 123 on 31.01.24.
//

import UIKit

class NewTaskViewController: UIViewController {
    
    //MARK: - outlets
    
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var taskDescriptionTextField: UITextField!
    
    @IBOutlet weak var hourTextField: UITextField!
    @IBOutlet weak var minuteTextField: UITextField!
    @IBOutlet weak var secondTeftField: UITextField!
    
    @IBOutlet weak var NameDescriptionContainerView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var NewTaskTopConstraint: NSLayoutConstraint!
    
    //MARK: - Variables
    
    private var taskViewmodel: TaskViewModel!
    private var keyboardOpened = false
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.taskViewmodel = TaskViewModel()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.register(UINib(nibName: TaskTypeCollectionViewCell.description(), bundle: .main), forCellWithReuseIdentifier: TaskTypeCollectionViewCell.description())
        
        self.startButton.layer.cornerRadius = 12
        
        self.NameDescriptionContainerView.layer.cornerRadius = 12
        
        [self.hourTextField, self.minuteTextField, self.secondTeftField].forEach {
            $0?.attributedPlaceholder = NSAttributedString(string: "00", attributes: [NSAttributedString.Key.font : UIFont(name: "Helvetica Bold", size: 42)!,NSAttributedString.Key.foregroundColor: UIColor.black])
            $0?.delegate = self
            $0?.addTarget(self, action: #selector(self.textFieldInputChanged(_:)), for: .editingChanged)
            
        }
        
        self.taskNameTextField.attributedPlaceholder = NSAttributedString(string: "Task Name", attributes: [NSAttributedString.Key.font : UIFont(name: "Geeza Pro Bold", size: 14)!, NSAttributedString.Key.foregroundColor : UIColor.black.withAlphaComponent(0.55)])
        self.taskNameTextField.addTarget(self, action: #selector(self.textFieldInputChanged(_:)), for: .editingChanged)
        self.taskDescriptionTextField.attributedPlaceholder = NSAttributedString(string: "Short Description", attributes: [NSAttributedString.Key.font : UIFont(name: "Geeza Pro Bold", size: 14)!, NSAttributedString.Key.foregroundColor : UIColor.black.withAlphaComponent(0.55)])
        self.taskDescriptionTextField.addTarget(self, action: #selector(self.textFieldInputChanged(_:)), for: .editingChanged)
        
        self.disableButton()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped(_:)))
        tapGesture.cancelsTouchesInView = false
        
        self.view.addGestureRecognizer(tapGesture)
        
        self.taskViewmodel.getHours().bind { hours in
            self.hourTextField.text = hours.appendZeros()
        }
        
        self.taskViewmodel.getMinutes().bind { minutes in
            self.minuteTextField.text = minutes.appendZeros()
        }
        
        self.taskViewmodel.getSeconds().bind { seconds in
            self.secondTeftField.text = seconds.appendZeros()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    //MARK: - Outlets & objc functions
    
    @IBAction func startButtonPressed(_ sender: Any) {
        guard let timerVC = self.storyboard?.instantiateViewController(withIdentifier: TimerViewController.description()) as? TimerViewController else {return}
        taskViewmodel.computeSeconds()
        timerVC.taskViewModel = taskViewmodel
        self.present(timerVC, animated: true)
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
    }
    
    @objc func textFieldInputChanged(_ textfield:UITextField) {
        
        
        guard let text = textfield.text else {return}
        
        if (textfield == taskNameTextField) {
            
            self.taskViewmodel.setTaskName(to: text)
            
        } else if (textfield == taskDescriptionTextField) {
            
            self.taskViewmodel.setTaskDescription(to: text)
            
        } else if (textfield == hourTextField) {
            
            guard let hours = Int(text) else {return}
            self.taskViewmodel.setHours(to: hours)
            
        } else if (textfield == minuteTextField) {
            
            guard let minutes = Int(text) else {return}
            self.taskViewmodel.setMinutes(to: minutes)
            
        } else /*if (textfield == secondTeftField)*/ {
            
            guard let seconds = Int(text) else {return}
            self.taskViewmodel.setSeconds(to: seconds)
            
        }
        
        checkButtonStatus()
    
    }
    
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if !Constants.hasTopNotch, !keyboardOpened {
            self.keyboardOpened.toggle()
            self.NewTaskTopConstraint.constant -= self.view.frame.height * 0.2
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        self.NewTaskTopConstraint.constant = 20
        self.keyboardOpened = false
        self.view.layoutIfNeeded()
    }
    
    //MARK: - Functions
    override class func description() -> String {
        return "NewTaskViewController"
    }
    
    func enableButton () {
        if (self.startButton.isUserInteractionEnabled == false) {
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut) {
                self.startButton.layer.opacity = 1
            } completion: { _ in
                self.startButton.isUserInteractionEnabled.toggle()
            }
        }
    }
    
    func disableButton () {
        if (self.startButton.isUserInteractionEnabled) {
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut) {
                self.startButton.layer.opacity = 0.25
            } completion: { _ in
                self.startButton.isUserInteractionEnabled.toggle()
            }
        }
    }
    
    func checkButtonStatus() {
        
        if taskViewmodel.isTaskValid() {
            // enable button
            enableButton()
        } else {
            // disable button
            disableButton()
        }
        
    }
    
}

extension NewTaskViewController: UITextFieldDelegate {
    
    internal func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 2
        let currentText:NSString = (textField.text ?? "") as NSString
        let newString: NSString = currentText.replacingCharacters(in: range, with: string) as NSString
        
        guard let text = textField.text else {return false}
        
        if (text.count == 2 && text.starts(with: "0")) {
            textField.text?.removeFirst()
            textField.text? += string
            self.textFieldInputChanged(textField)
            
        }
        
        return newString.length <= maxLength
    }
    
}



extension NewTaskViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return taskViewmodel.getTaskTypes().count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let columns: CGFloat = 3.75
        let width: CGFloat = collectionView.frame.width
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let adjustedWidth = width - (flowLayout.minimumLineSpacing * (columns - 1))
        
        return CGSize(width: adjustedWidth / columns, height: self.collectionView.frame.height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaskTypeCollectionViewCell.description(), for: indexPath) as! TaskTypeCollectionViewCell
        cell.setupCell(taskType: self.taskViewmodel.getTaskTypes()[indexPath.item], isSelected: taskViewmodel.getSelectedIndex() == indexPath.item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.taskViewmodel.setSelectedIndex(to: indexPath.item)
        self.collectionView.reloadSections(IndexSet(0..<1))
        checkButtonStatus()
    }
    
}
