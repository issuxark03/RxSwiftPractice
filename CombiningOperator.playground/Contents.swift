import RxSwift

let disposebag = DisposeBag()

print("-----------startWith------------") //초기값붙일때 사용
let yellowClass = Observable<String>.of("1","2","3")

yellowClass
    .enumerated()
    .map({ index, element in
        return element + " 어린이 " + "\(index)"
    })
    .startWith("teacher") //string
    .subscribe(onNext: {
            print($0)
    })
    .disposed(by: disposebag)

print("-----------concat1------------") //
let yellowClassChildren = Observable<String>.of("1","2","3")
let teacher = Observable<String>.of("teacher")

let line = Observable
    .concat([teacher, yellowClassChildren])

line
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposebag)

print("-----------concat2------------") //
teacher
    .concat(yellowClassChildren)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposebag)


print("-----------concatMap------------")
let childrenHouse: [String: Observable<String>] = [
    "yellowClass": Observable.of("1","2","3"),
    "blueClass": Observable.of("4","5")
]

Observable.of("yellowClass","blueClass")
    .concatMap { ban in
        childrenHouse[ban] ?? .empty()
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposebag)


print("-----------merge1------------") //순서보장x 합침
let gangbuk = Observable.from(["gangbuk","sungbuk","dongdaemon","jongno"])
let gangnam = Observable.from(["gangnam","gangdong","yeongdeungpo","yangcheon"])

Observable.of(gangbuk,gangnam)
    .merge()
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposebag)


print("-----------merge2------------")
Observable.of(gangbuk,gangnam)
    .merge(maxConcurrent: 1)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposebag)


print("-----------combineLatest1------------") //가장마지막(최신)요소만 사용
let lastName = PublishSubject<String>()
let firstName = PublishSubject<String>()

let name = Observable
    .combineLatest(lastName, firstName) { lastName, firstName in
        lastName + firstName
        
    }

name
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposebag)

lastName.onNext("김")
firstName.onNext("똘똘")
firstName.onNext("영수")
firstName.onNext("은영")
lastName.onNext("박")
lastName.onNext("이")
lastName.onNext("조")

print("-----------combineLatest2------------")
let calanderFormat = Observable<DateFormatter.Style>.of(.short, .long)
let currentDate = Observable<Date>.of(Date())

let displayCurrentDate = Observable
    .combineLatest(
        calanderFormat,
        currentDate,
        resultSelector: { format, date -> String in
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = format
            return dateFormatter.string(from: date)
        }
    )

displayCurrentDate
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposebag)



print("-----------combineLatest2------------")
let lastName2 = PublishSubject<String>()
let firstName2 = PublishSubject<String>()

let fullName2 = Observable
    .combineLatest([firstName2,lastName2]) { name in
        name.joined(separator: " ")
    }

fullName2
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposebag)

lastName2.onNext("Kim")
firstName2.onNext("Paul")
firstName2.onNext("Stella")
firstName2.onNext("Lily")


print("-----------zip------------")
enum winLose {
    case win
    case lose
}


let fight = Observable<winLose>.of(.win, .win, .lose, .win, .lose)
let ath = Observable<String>.of("korea","usa","japan","china","england","canada")

let fightResult = Observable
    .zip(fight, ath) { result, mainAth  in
        return mainAth + " 선수 " + "\(result)"
    }

fightResult
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposebag)

print("-----------withLatestFrom1------------")
let bullet = PublishSubject<Void>()
let runner = PublishSubject<String>()


bullet
    .withLatestFrom(runner)
    .distinctUntilChanged() //쓰면 sample이랑 똑같아짐. 동일한이벤트 걸러줘서 1번
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposebag)

runner.onNext("1")
runner.onNext("1 2")
runner.onNext("1 2 3")
bullet.onNext(Void())
bullet.onNext(Void())


print("-----------sample------------")
let start = PublishSubject<Void>()
let f1Driver = PublishSubject<String>()

f1Driver
    .sample(start)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposebag)


f1Driver.onNext("1")
f1Driver.onNext("1 2")
f1Driver.onNext("1 2 3")
start.onNext(Void())
start.onNext(Void())
start.onNext(Void()) //sample은 여러번 해도 한번만나옴


print("-----------amb------------")
let bus1 = PublishSubject<String>()
let bus2 = PublishSubject<String>()

let busStop = bus1.amb(bus2) //둘중하나가 먼저 이벤트를 방출해도 무시함.

busStop
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposebag)

bus2.onNext("bus2 pass0") //버스2가 먼저 발생했으므로, 이후에나오는 버스1은 무시됨
bus1.onNext("bus1 pass0")
bus1.onNext("bus1 pass1")
bus2.onNext("bus2 pass1")
bus1.onNext("bus1 pass1")
bus2.onNext("bus2 pass2")


print("-----------switchLatest------------")
let student1 = PublishSubject<String>()
let student2 = PublishSubject<String>()
let student3 = PublishSubject<String>()

let handsUp = PublishSubject<Observable<String>>()

let classRoomOnlyHandsUp = handsUp.switchLatest() //손든사람만말할수있는교실

classRoomOnlyHandsUp
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposebag)

handsUp.onNext(student1)
student1.onNext("stu1 : im student1")
student2.onNext("stu2 : hi")

handsUp.onNext(student2)
student2.onNext("stu2 : im student2")
student1.onNext("stu1 : bye")

handsUp.onNext(student3)
student2.onNext("stu2 : asdf")
student1.onNext("stu1 : 1111")
student3.onNext("stu3 : im student3")

handsUp.onNext(student1)
student2.onNext("stu2 : zzzz")
student1.onNext("stu1 : 111")
student3.onNext("stu3 : im")
student2.onNext("stu2 : fff")
//손든학생만 나옴


print("-----------reduce------------")
Observable.from((1...10))
//    .reduce(0, accumulator: {summary, newValue in
//        return summary + newValue
//    })
//    .reduce(0){summary, newValue in
//        return summary + newValue
//    }
    .reduce(0, accumulator: +)
    
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposebag)


print("-----------scan------------")
Observable.from((1...10))
    .scan(0, accumulator: +) //1부터 10까지더함
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposebag)



