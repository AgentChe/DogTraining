//
//  CreateEventViewController.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 28.08.2023.
//

import UIKit
import RxSwift
import RxCocoa

final class CreateEventViewController: UIViewController {
    enum Mode {
        case create(EventType)
        case edit(Event)
        
        var eventType: EventType {
            switch self {
            case .create(let type):
                return type
            case .edit(let event):
                return event.type
            }
        }
        
        var eventId: String? {
            switch self {
            case .edit(let event):
                return event.id
            default:
                return nil
            }
        }
        
        var isCreate: Bool {
            switch self {
            case .create:
                return true
            default:
                return false
            }
        }
    }
    
    lazy var mainView = CreateEventView(mode: mode)
    
    private lazy var viewModel = CreateEventViewModel(mode: mode)
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var insertDateTrigger = PublishRelay<Date>()
    private lazy var insertRepeatModeTrigger = PublishRelay<EventRepeatMode>()
    
    private let mode: Mode
    private let didClose: ((CreateEventViewController) -> Void)
    
    private init(mode: Mode, didClose: @escaping ((CreateEventViewController) -> Void)) {
        self.mode = mode
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
            .emit(to: Binder(self) { base, date in
                base.display(date: date)
            })
            .disposed(by: disposeBag)
        
        mainView.repeatModeView.didSelectMode
            .emit(to: Binder(self) { base, mode in
                base.display(repeatMode: mode)
            })
            .disposed(by: disposeBag)
        
        mainView.removeButton.rx.tap
            .bind(to: Binder(mainView.confirmRemoveView) { base, void in
                base.show()
            })
            .disposed(by: disposeBag)
        
        let output = viewModel.configure(input: CreateEventViewModel.Input(
            didChangeNote: mainView.noteField.rx.text.compactMap { $0 }.asSignal(onErrorSignalWith: .never()),
            didChangeDate: Signal.merge(
                insertDateTrigger.asSignal(),
                mainView.eventTimeView.didSelectDate
            ),
            didChangeRepeatMode: Signal.merge(
                insertRepeatModeTrigger.asSignal(),
                mainView.repeatModeView.didSelectMode
            ),
            didTapCreate: mainView.saveButton.rx.tap.asSignal(),
            didTapRemove: mainView.confirmRemoveView.didTapRemove
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
        
        fillIfNeeded()
    }
}

// MARK: Public
extension CreateEventViewController {
    static func make(mode: Mode, didClose: @escaping ((CreateEventViewController) -> Void)) -> CreateEventViewController {
        CreateEventViewController(mode: mode, didClose: didClose)
    }
}

// MARK: Private
private extension CreateEventViewController {
    func route(_ route: CreateEventViewModel.Route) {
        switch route {
        case .created, .removed:
            didClose(self)
        }
    }
    
    func fillIfNeeded() {
        guard case let .edit(event) = mode else {
            return
        }
        
        mainView.noteField.text = event.note
        mainView.noteField.sendActions(for: [.editingChanged])
        
        display(date: event.date)
        insertDateTrigger.accept(event.date)
        
        display(repeatMode: event.repeatMode)
        insertRepeatModeTrigger.accept(event.repeatMode)
    }
    
    func display(date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy HH:mm"
        mainView.selectDateView.setup(value: formatter.string(from: date))
    }
    
    func display(repeatMode: EventRepeatMode) {
        mainView.selectRepeatView.setup(value: repeatMode.title)
    }
}
