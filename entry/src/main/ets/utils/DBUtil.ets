//数据库工具类
import { relationalStore, ValuesBucket} from "@kit.ArkData"
import { common } from "@kit.AbilityKit";
import Logger from "./Logger";

// 创建接口 属性为要向数据库中存的数据
export interface KeepDBInfo extends ValuesBucket {
  id: number | null;

  // 运动id
  keep_id: number;

  // 运动时间或数量
  amount: number;

  // 记录数据的时间
  create_time: string;

  // 运动完成的个数或者时间
  success_amount: number;
}

//####更改数据库名称
const DB_FILENAME: string = 'bzk.db'

const tableName: string = 'records'

const CREATE_TABLE_SQL: string = `
CREATE TABLE IF NOT EXISTS ${tableName} (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  keep_id INTEGER NOT NULL,
  amount DOUBLE NOT NULL,
  create_time STRING NOT NULL,
  success_amount DOUBLE NOT NULL
)
`

class DBUtil {
  /*
  初始化数据库
   */
  async initDB(context?: common.UIAbilityContext) {
    let config: relationalStore.StoreConfig = {
      name: DB_FILENAME,
      securityLevel: relationalStore.SecurityLevel.S1
    }

    const store: relationalStore.RdbStore = await relationalStore.getRdbStore((context ? context : getContext()), config)
    Logger.info('创建/打开数据库')
    return store
  }

  /*
  创建数据库表
   */
  async createTable() {
    // 打开数据库
    const store: relationalStore.RdbStore = await this.initDB()
    // 执行创建表的sql语句
    store.executeSql(CREATE_TABLE_SQL)
  }

  /*
  增
   */
  async insert(value: KeepDBInfo) {
    // 打开数据库
    const store: relationalStore.RdbStore = await this.initDB()
    // 向数据库中添加数据
    let ins = await store.insert(tableName, value)
    Logger.info(JSON.stringify(ins))
  }

  /*
  删
   */
  async delete(id: number) {
    // 打开数据库
    const store: relationalStore.RdbStore = await this.initDB()
    // 声明删除条件(根据id删除数据)
    const predicates = new relationalStore.RdbPredicates(tableName)
    // 匹配id条件
    predicates.equalTo('id', id)
    // 执行删除操作
    store.delete(predicates)
  }

  /*
  查(根据日期查)
   */
  async queryByDate(date: string) {
    // 打开数据库
    const store: relationalStore.RdbStore = await this.initDB()

    // 定义变量接受谓词(条件)
    const predicates = new relationalStore.RdbPredicates(tableName)
    // 匹配时间
    predicates.equalTo('create_time', date)

    // 定义变量接收查询出来的对象数组
    const resultSet = await store.query(predicates)

    // 定义数组接收遍历的resultSet
    const list: KeepDBInfo[] = []
    // 遍历resultSet，将对象属性重新按照指定类型赋值
    while (resultSet.goToNextRow()) {
      const item: KeepDBInfo = {
        id: resultSet.getLong(0),
        keep_id: resultSet.getLong(1),
        amount: resultSet.getDouble(2),
        create_time: resultSet.getString(3),
        success_amount: resultSet.getDouble(4)
      }
      // 将对象添加到list数组中
      list.push(item)
    }
    Logger.info(JSON.stringify(list))
    return list
  }

  /*
  查所有
   */
  async queryAll() {
    // 打开数据库
    const store: relationalStore.RdbStore = await this.initDB()

    // 定义变量接受谓词(条件)
    const predicates = new relationalStore.RdbPredicates(tableName)

    // 定义变量接收查询出来的对象数组
    const resultSet = await store.query(predicates)

    // 定义数组接收遍历的resultSet
    const list: KeepDBInfo[] = []
    // 遍历resultSet，将对象属性重新按照指定类型赋值
    while (resultSet.goToNextRow()) {
      const item: KeepDBInfo = {
        id: resultSet.getLong(0),
        keep_id: resultSet.getLong(1),
        amount: resultSet.getDouble(2),
        create_time: resultSet.getString(3),
        success_amount: resultSet.getDouble(4)
      }
      // 将对象添加到list数组中
      list.push(item)
    }
    Logger.info(JSON.stringify(list))
    return list
  }

  /*
  改
   */
  async update(id: number, value: KeepDBInfo) {
    // 打开数据库
    const store: relationalStore.RdbStore = await this.initDB()
    // 谓词
    const predicates = new relationalStore.RdbPredicates(tableName)
    // 通过id匹配修改的数据
    predicates.equalTo('id', id)

    store.update(value, predicates)
  }
}

let dbUtil: DBUtil = new DBUtil()

export default dbUtil as DBUtil