import RxSwift
import Foundation

let disposeBag = DisposeBag()

enum TraitsError: Error {
    case single
    case maybe
    case completable
}

print("-----Single1-----")
Single<String>.just("✅")
    .subscribe(onSuccess: {
            print($0)
    }, onFailure: {
            print("error: \($0)")
    }, onDisposed: {
        print("disposed")
    })

print("-----Single2-----")
Observable<String>
    .create{ observer -> Disposable in
    observer.onError(TraitsError.single)
    return Disposables.create()
}
    .asSingle()
    .subscribe(
        onSuccess: {
        print($0)
    }, onFailure: {
        print("error: \($0.localizedDescription)")
    }, onDisposed: {
        print("disposed")
    }
    ).disposed(by: disposeBag)


print("-----Single3-----")
struct SomeJSON: Decodable {
    let name: String
}

enum JSONerror: Error {
    case decodingError
}

let json1 = """
    {"name":"park"}
    """

let json2 = """
    {"my_name":"young"}
    """

func decode(json: String) -> Single<SomeJSON> {
    Single<SomeJSON>.create { observer -> Disposable in
        
        guard let data = json.data(using: .utf8),
              let json = try? JSONDecoder().decode(SomeJSON.self, from: data)
        else {
            observer(.failure(JSONerror.decodingError))
            return Disposables.create()
        }
        observer(.success(json))
        return Disposables.create()
    }
}


decode(json: json1)
    .subscribe {
        switch $0 {
        case .success(let json):
            print(json.name)
        case .failure(let error):
            print(error)
        }
    }
    .disposed(by: disposeBag)

decode(json: json2)
    .subscribe {
        switch $0 {
        case .success(let json):
            print(json.name)
        case .failure(let error):
            print(error)
        }
    }
    .disposed(by: disposeBag)


print("-----Maybe1-----")
Maybe<String>.just("✅")
