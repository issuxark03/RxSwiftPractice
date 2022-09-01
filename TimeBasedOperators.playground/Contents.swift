import RxSwift
import RxCocoa
import UIKit
import PlaygroundSupport

/*
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposebag)
*/

let disposebag = DisposeBag()


print("-----------replay------------")
let greetings = PublishSubject<String>()
let repeatBird = greetings.replay(1) //bufferSize 1. 구독전에 발생한 이벤트여도 과거 1개는 받는다.

repeatBird.connect()

greetings.onNext("1. hello")
greetings.onNext("2. hi")

repeatBird
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposebag)


print("-----------replayAll------------")
let doctorStrange = PublishSubject<String>()
let timeStone = doctorStrange.replayAll() //구독한시점에 있는 모든것을 방출(갯수상관X)

timeStone.connect()

doctorStrange.onNext("도르마무")
doctorStrange.onNext("거래를 하러왔다.")

timeStone
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposebag)

/*
print("-----------buffer------------")
let source = PublishSubject<String>()

var count = 0
let timer = DispatchSource.makeTimerSource()

timer.schedule(deadline: .now() + 2, repeating: .seconds(1)) //현재시점 부터 2초뒤부터 1초마다
timer.setEventHandler {
    count += 1
    source.onNext("\(count)")
}
timer.resume()

source
    .buffer(timeSpan: .seconds(2), //2초내에 받는건 방출
            count: 2, //최대 2개
            scheduler: MainScheduler.instance)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposebag)
*/

print("-----------window------------")
/*
let maxObservableCnt = 0
let makeTime = RxTimeInterval.seconds(2)

let window = PublishSubject<String>()

var windowCount = 0
let windowTimerSource = DispatchSource.makeTimerSource()
windowTimerSource.schedule(deadline: .now() + 2, repeating: .seconds(1))
windowTimerSource.setEventHandler {
    windowCount += 1
    window.onNext("\(windowCount)")
}
windowTimerSource.resume()


window
    .window(timeSpan: makeTime,
            count: maxObservableCnt,
            scheduler: MainScheduler.instance)
    .flatMap { windowObservable -> Observable<(index: Int, element: String)> in
        return windowObservable.enumerated()
    }
    .subscribe(onNext: {
        print("\($0.index)번째 Observable의 요소 \($0.element)")
    })
    .disposed(by: disposebag)
*/


print("-----------delaySubscription------------") //구독을 천천히하겠다. 구독지연
/*
let delaySource = PublishSubject<String>()

var delayCount = 0
let delayTimeSource = DispatchSource.makeTimerSource()
delayTimeSource.schedule(deadline: .now() + 2, repeating: .seconds(1))
delayTimeSource.setEventHandler {
    delayCount += 1
    delaySource.onNext("\(delayCount)")
}
delayTimeSource.resume()

delaySource
    .delaySubscription(.seconds(5), scheduler: MainScheduler.instance)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposebag)
*/

print("-----------delay------------") //즉시구독. 요소의방출을 미룸
/*
let delaySubject = PublishSubject<Int>()

var delayCount = 0
let delayTimerSource = DispatchSource.makeTimerSource()
delayTimerSource.schedule(deadline: .now(), repeating: .seconds(1))
delayTimerSource.setEventHandler {
    delayCount += 1
    delaySubject.onNext(delayCount)
}
delayTimerSource.resume()

delaySubject
    .delay(.seconds(3), scheduler: MainScheduler.instance)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposebag)
*/
print("-----------interval------------")
/*
Observable<Int>
    .interval(.seconds(3), scheduler: MainScheduler.instance)
    .subscribe(onNext: {
        print($0) //타입추론으로 0부터 3초마다 방출
    })
    .disposed(by: disposebag)
*/
/*
print("-----------timer------------")
Observable<Int>
    .timer(.seconds(5), //구독한시점부터 첫 방출까지 듀 타임
           period: .seconds(2),
           scheduler: MainScheduler.instance)
    .subscribe(onNext: {
        print($0) //타입추론으로 0부터 3초마다 방출
    })
    .disposed(by: disposebag)
*/
print("-----------timeout------------")
let errorOccuredWhenDontPushed = UIButton(type: .system)
errorOccuredWhenDontPushed.setTitle("Please Push!", for: .normal)
errorOccuredWhenDontPushed.sizeToFit()

PlaygroundPage.current.liveView = errorOccuredWhenDontPushed

errorOccuredWhenDontPushed.rx.tap
    .do(onNext: {
        print("tap")
    })
    .timeout(.seconds(5), scheduler: MainScheduler.instance) //5초가 지나도 아무런이벤트가 발생안하면 타임아웃 에러발생
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposebag)
