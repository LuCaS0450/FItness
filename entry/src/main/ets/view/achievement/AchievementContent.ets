import itemModel from '../../model/RecordItemModel'
import DateUtil from '../../utils/DateUtil'
import dbUtil, { KeepDBInfo } from '../../utils/DBUtil'
import Logger from '../../utils/Logger'
import AchievementInfo from '../../viewmodel/AchievementInfo'
import AchievementMapInfo from '../../viewmodel/AchievementMapInfo'
import AchievementTop from './AchievementTop'

@Component
export default struct AchievementContent {
  achievementMapInfo: AchievementMapInfo = new AchievementMapInfo()
  @Watch('aboutToAppear')
  @StorageProp('date')
  date: number = DateUtil.beginTimeOfDay(new Date())
  @State calorie: number = 0
  @State consume: number = 0
  @State records: KeepDBInfo[] = []
  @State allRecords: KeepDBInfo[] = []
  @Link isRefreshing: boolean
  @State successDays: number = 0
  @State success: Array<AchievementInfo> = [
    new AchievementInfo(3, this.achievementMapInfo.on_3, this.achievementMapInfo.off_3),
    new AchievementInfo(7, this.achievementMapInfo.on_7, this.achievementMapInfo.off_7),
    new AchievementInfo(30, this.achievementMapInfo.on_30, this.achievementMapInfo.off_30),
    new AchievementInfo(50, this.achievementMapInfo.on_50, this.achievementMapInfo.off_50),
    new AchievementInfo(73, this.achievementMapInfo.on_73, this.achievementMapInfo.off_73),
    new AchievementInfo(99, this.achievementMapInfo.on_99, this.achievementMapInfo.off_99),
  ]

  async aboutToAppear() {
    // 查询当天有多少运动任务
    this.records = await dbUtil.queryByDate(DateUtil.formatDate(this.date))
    Logger.info('查询当天运动任务')

    this.consume = 0
    this.calorie = 0

    this.records.forEach((item: KeepDBInfo) => {
      let cal = itemModel.getById(item.keep_id).calorie
      // 计算消耗掉的卡路里
      this.consume += cal * item.success_amount
      // 计算总共要消耗的卡路里
      this.calorie += cal * item.amount
    })

    this.allRecords = await dbUtil.queryAll()
    //改变successDays可以调试是否正确展示成就图标
    this.successDays = 0
    for (let i = 0; i < this.allRecords.length; i++) {
      let success_keeps: number = 0
      // 判断， 如果记录项下标大于0，且当前记录项日期等于上一条记录项日期，不执行任何操作
      if(i > 0 && this.allRecords[i].create_time === this.allRecords[i-1].create_time) {

      } else {
        // 根据日期查询当天的运动任务
        let ro: KeepDBInfo[] = await dbUtil.queryByDate(this.allRecords[i].create_time)
        // 将当天的运动任务遍历
        ro.forEach((item: KeepDBInfo) => {
          // 判断该项运动是否完成
          if(item.success_amount == item.amount) {
            success_keeps += 1
          }
        })
        // 判断当天任务是否全部完成， 如果全部完成 完成天数 + 1
        if(success_keeps === ro.length) {
          this.successDays += 1
        }
      }
    }

  }

  build() {
    Column() {
      Row() {
        AchievementTop({ calorie: $calorie, consume: $consume })
      }
      .height('40%')

      Column() {
        Row() {
          Text('成就')
            .fontSize(20)
            .fontWeight(500)
            .fontColor(Color.White)
        }
        .width('95%')

        Column({ space: 10 }) {
          Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap }) {
            ForEach(this.success, (item: AchievementInfo) => {
              Column() {
                Image(this.successDays >= item.days ? item.icOn : item.icOff)
                  .width('100%')
                  .height(88)
                  .objectFit(ImageFit.Contain)
                Text($r('app.string.task_achievement_level', item.days))
                  .lineHeight(16)
                  .fontSize(12)
                  .fontColor(Color.White)
              }
              .width('33%')
              .padding({ top: 38, bottom: 10 })
            })
          }
        }
      }
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Black)

  }
}