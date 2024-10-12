

@Component
export default struct Mine {
  build() {
    Column() {
      // 标题栏
      Text("我的")
        .size({ width: '100%', height: 50 })
        .backgroundColor("#28bff1")
        .fontColor("#ffffff")
        .textAlign(TextAlign.Center)
        .fontSize("18fp")
      Text("我的").width('100%').height('100%').textAlign(TextAlign.Center).fontSize("25fp")
    }.size({ width: '100%', height: '100%' })
  }
}