//
//  CreateEventViewController.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 28.08.2023.
//

import UIKit
import RxSwift

final class CreateEventViewController: UIViewController {
    lazy var mainView = CreateEventView(eventType: eventType)
    
    private lazy var viewModel = CreateEventViewModel(eventType: eventType)
    
    private lazy var disposeBag = DisposeBag()
    
    private let eventType: EventType
    private let didClose: ((CreateEventViewController) -> Void)
    
    private init(eventType: EventType, didClose: @escaping ((CreateEventViewController) -> Void)) {
        self.eventType = eventType
        self.didClose = didClose
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.closeButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.didClose(base)
            })
            .disposed(by: disposeBag)
        
        mainView.rx.keyboardHeight
            .asDriver(onErrorJustReturn: 0)
            .drive(Binder(mainView.scrollView) { base, keyboardHeight in
                base.contentInset.bottom = keyboardHeight > 0 ? keyboardHeight : 0
            })
            .disposed(by: disposeBag)
        
        let hideKeyboardGesture = UITapGestureRecognizer()
        mainView.addGestureRecognizer(hideKeyboardGesture)
        mainView.isUserInteractionEnabled = true
        hideKeyboardGesture.rx.event
            .mapToVoid()
            .bind(to: mainView.rx.hideKeyboardObserver)
            .disposed(by: disposeBag)
        
        mainView.selectDateView.rx.tap
            .bind(to: Binder(mainView.eventTimeView) { base, void in
                base.show()
            })
            .disposed(by: disposeBag)
        
        mainView.selectRepeatView.rx.tap
            .bind(to: Binder(mainView.repeatModeView) { base, void in
                base.show()
            })
            .disposed(by: disposeBag)
        
        mainView.eventTimeView.didSelectDate
            .emit(to: Binder(mainView.selectDateView) { base, date in
                let formatter = DateFormatter()
                formatter.dateFormat = "MMM dd, yyyy HH:mm"
                base.setup(value: formatter.string(from: date))
            })
            .disposed(by: disposeBag)
        
        mainView.repeatModeView.didSelectMode
            .emit(to: Binder(mainView.selectRepeatView) { base, mode in
                base.setup(value: mode.title)
            })
            .disposed(by: disposeBag)
        
        let output = viewModel.configure(input: CreateEventViewModel.Input(
            didChangeNote: mainView.noteField.rx.text.compactMap { $0 }.asSignal(onErrorSignalWith: .never()),
            didChangeDate: mainView.eventTimeView.didSelectDate,
            didChangeRepeatMode: mainView.repeatModeView.didSelectMode,
            didTapCreate: mainView.saveButton.rx.tap.asSignal()
        ))
        
        output.enableSave
            .drive(Binder(mainView.saveButton) { base, enable in
                base.isEnabled = enable
                base.alpha = enable ? 1 : 0.4
            })
            .disposed(by: disposeBag)
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension CreateEventViewController {
    static func make(eventType: EventType, didClose: @escaping ((CreateEventViewController) -> Void)) -> CreateEventViewController {
        CreateEventViewController(eventType: eventType, didClose: didClose)
    }
}

// MARK: Private
private extension CreateEventViewController {
    func route(_ route: CreateEventViewModel.Route) {
        switch route {
        case .created:
            didClose(self)
        }
    }
}
