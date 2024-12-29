export default class AchievementInfo {
  days: number;
  icOn: ResourceStr;//打开状态
  icOff: ResourceStr;//关闭状态

  constructor(days: number, icOn: ResourceStr, icOff: ResourceStr) {
    this.days = days;
    this.icOn = icOn;
    this.icOff = icOff;
  }
}