@Entry
@Component
struct SplashIndex {
  build() {
    Column() {
      //更改欢迎界面图片
      Image($r('app.media.logo'))
        .width(70)
        .position({x:140,y:20})
        .margin({top: 10})
        .borderRadius(15)

      //更改欢迎界面文本
      Text('欢迎进入健身')
        .fontSize(15)
        .fontColor('#182431')
        .fontWeight(700)
        .letterSpacing(0.1)
        .opacity(0.6)
        .margin({top: 5, bottom: 10})
    }
    .width('100%')
    .height('100%')
    //更改欢迎界面背景图片
    .backgroundImage($r('app.media.welcomeBg'))
    .backgroundImageSize({width: '100%', height: '100%'})
    .backgroundImagePosition({x: 0, y: 20})
  }
}