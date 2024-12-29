@Preview
@CustomDialog
export default struct UserPrivacyDialog {
  //若用户已经点击过弹窗中的同意按钮,则下次打开app不用弹窗,否则弹窗
  //使用首选项来存储数据
  controller: CustomDialogController = new CustomDialogController({builder: ''})
  cancel: Function = () => {}
  confirm: Function = () => {}
  build() {
    Column({space: 10}) {
      //####更改弹窗标题
      Text($r('app.string.welcome_title'))
        .fontSize(20)
        .fontWeight(FontWeight.Bolder)
        .margin({top: 8, bottom: 5})
      //####更改弹窗文本1
      Text() {
        Span($r('app.string.welcome_span_one'))
      }
      Text() {
        Span($r('app.string.welcome_span_two'))
        Span($r('app.string.personal_privacy_protocol'))
          .fontColor($r('app.color.privacy_color'))
        Span($r('app.string.welcome_span_three'))
        Span($r('app.string.user_protocol'))
          .fontColor($r('app.color.privacy_color'))
        Span($r('app.string.welcome_span_four'))
      }
      Text() {
        Span($r('app.string.welcome_span_end'))
      }
      Button('同意')
        .fontColor(Color.White)
        .backgroundColor("#ff06ae27")
        .width(150)
        .onClick(() => {
          this.confirm()
          this.controller.close()
        })
      Button('不同意')
        .fontColor("#d09d9d9d")
        .backgroundColor("#412ef550")
        .width(150)
        .onClick(() => {
          this.cancel()
          this.controller.close()
        })
    }
    .width('80%')
    .height('75%')
  }
}