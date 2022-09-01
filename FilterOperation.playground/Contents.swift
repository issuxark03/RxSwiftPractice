import RxSwift

let disposeBag = DisposeBag()

print("----------ignoreElements-----------")
let sleepMode = PublishSubject<String>()

sleepMode
    .ignoreElements() //next 무시.
    .subscribe{ //_ in
//        print("sun")
        print($0)
    }
    .disposed(by: disposeBag)

sleepMode.onNext("Speaker")
sleepMode.onNext("Speaker")
sleepMode.onNext("Speaker")

sleepMode.onCompleted()


print("----------elementAt-----------")
let 두번울면깨는사람 = PublishSubject<String>()

두번울면깨는사람
    .element(at: 2) //특정 인덱스
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

두번울면깨는사람.onNext("1") //0
두번울면깨는사람.onNext("1") //1
두번울면깨는사람.onNext("2") //2
두번울면깨는사람.onNext("1") //3

print("----------filter-----------")
Observable.of(1,2,3,4,5,6,7,8) // [1,2,3,4,5,6,7,8]
    .filter { $0 % 2 == 0 }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


print("----------skip-----------")
Observable.of("1","2","3","4","5","6")
    .skip(5) //5까지는 스킵임. 그이후부터 방출
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
    

print("----------skipwhile-----------")
Observable.of("1","2","3","4","5","6","7")
    .skip(while: {
        $0 != "4" //false일때부터 방출. 4부터 방출
    })
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("----------skipuntil-----------")
let 손님 = PublishSubject<String>()
let 문여는시간 = PublishSubject<String>()

손님
    .skip(until: 문여는시간)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

손님.onNext("1")
손님.onNext("1")

문여는시간.onNext("땡!")
손님.onNext("2")


print("---------take-----------")
Observable.of("금","은","동","사람1","사람2")
    .take(3) //3개만. skip의 반대
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("---------takewhile-----------")
Observable.of("금","은","동","사람1","사람2")
    .take(while: {
        $0 != "동" //true일때까지 방출
    }) //3개만. skip의 반대
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


print("---------enumerated-----------")
Observable.of("금","은","동","사람1","사람2")
    .enumerated() //index 같이 방출
    .takeWhile {
        $0.index < 3
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("---------takeUntil-----------")
let 수강신청 = PublishSubject<String>()
let 신청마감 = PublishSubject<String>()

수강신청
    .take(until: 신청마감)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

수강신청.onNext("아1")
수강신청.onNext("아2")
신청마감.onNext("끝")
수강신청.onNext("아3")


print("--------distinctUntilChanged----------")
Observable.of("저는","저는","앵무새","앵무새","앵무새","앵무새","앵무새","입니다","입니다","입니다","입니다","입니다","저는","앵무새","앵무새","일까요?","일까요?")
    .distinctUntilChanged() //연달아나오는 중복제거
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

