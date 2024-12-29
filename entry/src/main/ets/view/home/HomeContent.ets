import DateUtil from '../../utils/DateUtil'
import AddBtn from './AddBtn'
import router from '@ohos.router'
import Logger from '../../utils/Logger'
import DateDialog from '../../dialog/DateDialog'
import dbUtil, { KeepDBInfo } from '../../utils/DBUtil'
import itemModel from '../../model/RecordItemModel'

@Preview
@Component
export default struct HomeContent {
  @StorageProp('date')
  @Watch('aboutToAppear')
  //获取当天日期 从全局获取
  date: number = DateUtil.beginTimeOfDay(new Date())
  @Watch('aboutToAppear')
  @State list: KeepDBInfo[] = []

  async aboutToAppear() {
    // 根据日期查询当天的运动任务
    this.list = await dbUtil.queryByDate(DateUtil.formatDate(this.date))
  }

  @Builder
  DelBtn(id: number) {
    Button() {
      Image($r('app.media.delete'))
        .width(20)
        .fillColor(Color.Red)
    }
    .width(30)
    .height(30)
    .backgroundColor(Color.White)
    .stateEffect(false)
    .onClick(() => {
      dbUtil.delete(id)
      this.aboutToAppear()
    })
  }

  //添加任务
  addTask(): void {
    router.pushUrl({ url: "pages/AddTaskPage" })
    Logger.debug('跳转到添加任务页面')
  }

  controller: CustomDialogController = new CustomDialogController({
    builder: DateDialog({ date: new Date(this.date) })
  })

  build() {
    Column() {
      Column() {
        //####更改
        Text('百战健身')
          .fontSize(25)
          .fontWeight(600)
          .margin({ top: 10, bottom: 100, left: 20 })

        //展示日期选择组件
        Row() {
          Text(DateUtil.formatDate(this.date))
            .fontSize(15)
            .fontWeight(500)
          Image($r('app.media.arrow_down'))
            .width(20)
        }
        .width('90%')
        .height(50)
        .backgroundColor(Color.White)
        .margin({ left: 19, top: 90 })
        .borderRadius(20)
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          this.controller.open()
        })
      }
      //####更改背景图片
      .backgroundImage($r('app.media.home_bg'))
      .backgroundImageSize({ width: '100%', height: '100%' })
      .width('100%')
      .height('40%')
      .alignItems(HorizontalAlign.Start)
      .borderRadius({ bottomLeft: 20, bottomRight: 20 })

      //展示任务列表
      Stack() {
        Column() {
          Text('任务列表')
            .fontSize(13)
            .fontWeight(700)
            .margin({ left: 20, top: 20, bottom: 10 })
          if (this.list.length !== 0) {
            //目前有任务
            List({ space: 10 }) {
              ForEach(this.list, (item: KeepDBInfo) => {

                ListItem() {
                  Row() {
                    Row() {
                      Image(itemModel.getById(item.keep_id).image)
                        .width(50)
                        .height(50)
                      Text(itemModel.getById(item.keep_id).name)
                        .fontSize(13)
                        .fontWeight(600)
                        .opacity(0.8)
                    }
                    .onClick(() => {
                      // 判断 只能完成当天的运动任务， 如果不是当天运动任务则不执行修改操作
                      if(DateUtil.formatDate(this.date) === DateUtil.formatDate(new Date().getTime())) {
                        if(item.success_amount <= item.amount - item.amount % 1) {
                          item.success_amount += 1
                          if(item.success_amount > item.amount) {
                            item.success_amount = item.amount
                          }
                        }
                        dbUtil.update(item.id as number, {
                          id: item.id,
                          keep_id: item.keep_id,
                          amount: item.amount,
                          create_time: item.create_time,
                          success_amount: item.success_amount})
                      }
                      this.aboutToAppear()
                    })
                    Blank()
                    if (item.amount === item.success_amount) {
                      Text('消耗' + (itemModel.getById(item.keep_id).calorie * item.amount) + '卡路里')
                        .fontSize(13)
                        .fontWeight(600)
                        .margin({ right: 10 })
                        .fontColor($r('app.color.task_color'))
                    } else {
                      Text(item.success_amount + ':' + item.amount + itemModel.getById(item.keep_id).unit)
                        .fontSize(13)
                        .fontWeight(600)
                        .margin({ right: 10 })
                    }
                  }
                  .width('100%')
                  .backgroundColor(Color.White)
                  .borderRadius(15)
                }
                .width('90%')
                .swipeAction({ end: this.DelBtn(item.id) })
              })
            }
            .width('100%')
            .alignListItem(ListItemAlign.Center)
          } else {
            //目前没有任务
            //####更改背景图片
            Column({ space: 8 }) {
              Image($r('app.media.ic_no_data'))
                .width(350)
                .height(220)
              Text('暂无任务，请添加任务')
                .fontSize(20)
                .opacity(0.4)
            }
            .margin({ top: 68, left: 25 })
          }
        }
        .width('100%')
        .height('100%')
        .alignItems(HorizontalAlign.Start)
        if(DateUtil.formatDate(this.date) === DateUtil.formatDate(new Date().getTime())) {
          AddBtn({ clickAction: () => this.addTask() })
        }
      }
      .width('100%')
      .height('100%')
    }
    .backgroundColor($r('app.color.light_gray'))
  }
}