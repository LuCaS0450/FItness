@CustomDialog
export default struct DateDialog {
  controller: CustomDialogController
  //从全局获取
  date: Date = new Date()

  build() {
    Column() {
      DatePicker({
        start: new Date('2020-01-01'),
        //最新选择到当天
        end: new Date(),
        selected: this.date
      })
        .onDateChange((value: Date) => {
          this.date.setFullYear(value.getFullYear(), value.getMonth(), value.getDate())
        })
      Row({space: 20}) {
        Button('取消')
          .width(120)
          .backgroundColor($r('app.color.light_gray'))
          .onClick(() => {
            //关闭弹窗
            this.controller.close()
          })
        Button('确定')
          .width(120)
          .backgroundColor($r('app.color.theme_color'))
          .onClick(() => {
            //将日期保存到全局
            AppStorage.setOrCreate('date', this.date.getTime())
            //关闭弹窗
            this.controller.close()
          })
      }
    }
    .padding(12)
  }
}