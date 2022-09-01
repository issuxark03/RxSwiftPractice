import RxSwift
import Dispatch

let disposeBag = DisposeBag()

print("-----------toArray------------")
Observable.of("A","B","C")
    .toArray()
    .subscribe(onSuccess: {
     print($0)
    })
    .disposed(by: disposeBag)


print("-----------map------------")
Observable.of(Date())
    .map{ date -> String in
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-mm-dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: date)
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("-----------flatMap------------")
protocol ath {
    var score: BehaviorSubject<Int> { get }
}

struct 양궁선수: ath {
    var score: BehaviorSubject<Int>
}

let 한국국가대표 = 양궁선수(score: BehaviorSubject<Int>(value: 10))
let 미국국가대표 = 양궁선수(score: BehaviorSubject<Int>(value: 8))

let 올림픽경기 = PublishSubject<ath>()

올림픽경기
    .flatMap { 선수 in
        선수.score
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

올림픽경기.onNext(한국국가대표)
한국국가대표.score.onNext(10)

올림픽경기.onNext(미국국가대표)
한국국가대표.score.onNext(10)
미국국가대표.score.onNext(9)


print("-----------flatMapLatest------------")
struct high: ath {
    var score: BehaviorSubject<Int>
}

let seoul = high(score:BehaviorSubject<Int>(value: 7))
let jeju = high(score:BehaviorSubject<Int>(value: 6))

let korea = PublishSubject<ath>()

korea
    .flatMapLatest { ath in
        ath.score
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

korea.onNext(seoul)
seoul.score.onNext(9)

korea.onNext(jeju)
seoul.score.onNext(10) //변경된값을 무시
jeju.score.onNext(8)


print("-----------materialize and dematerialize---------")

enum banchik: Error {
    case bujungchulbal
}

struct runner: ath {
    var score: BehaviorSubject<Int>
}

let kimRabbit = runner(score: BehaviorSubject(value: 0))
let parkChitta = runner(score: BehaviorSubject(value: 1))

let run100m = BehaviorSubject<ath>(value: kimRabbit)

run100m
    .flatMapLatest{ ath in
        ath.score
            .materialize() //이벤트들을 함께 표시
    }
    .filter{
        guard let error = $0.error else {
            return true
        }
        print(error)
        return false
    }
    .dematerialize()
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

kimRabbit.score.onNext(1)
kimRabbit.score.onError(banchik.bujungchulbal)
kimRabbit.score.onNext(2)

run100m.onNext(parkChitta)


print("-------전화번호 11자리---------")
let input = PublishSubject<Int?>()

let list: [Int] = [1]

input
    .flatMap{
        $0 == nil
        ? Observable.empty() //nil이면
        : Observable.just($0) //아니면
    }
    .map{ $0! }
    .skip(while: {$0 != 0})
    .take(11)
    .toArray()
    .asObservable()
    .map {
        $0.map { " \($0) " } //string으로 변환
    }
    .map { numbers in
        var numberList = numbers
        numberList.insert("-", at: 3) //010-
        numberList.insert("-", at: 8) //010-1234-
        let number = numberList.reduce(" ",+)
        return number
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

input.onNext(10)
input.onNext(0)
input.onNext(nil)
input.onNext(1)
input.onNext(0)
input.onNext(4)
input.onNext(3)
input.onNext(nil)
input.onNext(1)
input.onNext(8)
input.onNext(9)
input.onNext(4)
input.onNext(9)
input.onNext(1)
