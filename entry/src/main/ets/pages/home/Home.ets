
@Component
export default struct Home {
  build() {
    Column() {
      // 标题栏
      Text("首页")
        .size({ width: '100%', height: 50 })
        .backgroundColor("#28bff1")
        .fontColor("#ffffff")
        .textAlign(TextAlign.Center)
        .fontSize("18fp")
      // 内容项
      Text("首页").width('100%').height('100%').textAlign(TextAlign.Center).fontSize("25fp")
    }.size({ width: '100%', height: '100%' })
  }
}