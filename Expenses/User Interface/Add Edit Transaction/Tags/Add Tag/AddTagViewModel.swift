import Combine

class AddTagViewModel: ObservableObject {
    
    let dismissPublisher = PassthroughSubject<Void, Never>()
    
    @Published var isSaveEnabled = false
    @Published var name: String = ""
    
    private let walletRepository: WalletRepository
    private let tagRepository: TagRepository
    private let restrictedTagNames: Set<String>
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(
        walletRepository: WalletRepository,
        tagRepository: TagRepository,
        restrictedTagNames: Set<String>
    ) {
        self.walletRepository = walletRepository
        self.tagRepository = tagRepository
        self.restrictedTagNames = restrictedTagNames
        
        $name.sink { [weak self] name in
            self?.isSaveEnabled = !name.isEmptyOrBlank && !restrictedTagNames.contains(name)
        }.store(in: &cancellables)
    }
    
    func saveTag() {
        guard let walletID = walletRepository.selectedWalletID else { return }
        let tag = Tag(id: "", name: name)
        _ = tagRepository.insert(tag: tag, toWalletWithID: walletID)
        dismissPublisher.send()
    }
}

extension AddTagViewModel {
    
    static func fake(restrictedTagNames: Set<String>) -> AddTagViewModel {
        AddTagViewModel(
            walletRepository: FakeWalletRepostiory(),
            tagRepository: FakeTagRepository(),
            restrictedTagNames: restrictedTagNames
        )
    }
    
    static func firebase(restrictedTagNames: Set<String>) -> AddTagViewModel {
        AddTagViewModel(
            walletRepository: FirebaseWalletRepository.shared,
            tagRepository: FirebaseTagRepository.shared,
            restrictedTagNames: restrictedTagNames
        )
    }
}
