
@Component
export default struct Home {
  pageStack: NavPathStack = new NavPathStack()

  build() {
    Navigation(this.pageStack) {
      Column() {

        // 内容项
        Text("首页").width('100%').height('100%').textAlign(TextAlign.Center).fontSize("25fp")
      }.size({ width: '100%', height: '100%' })
    }
    .mode(NavigationMode.Stack)
    .titleMode(NavigationTitleMode.Mini)
    .title("首页")
    .hideBackButton(true)
    .width('100%').height('100%')
  }
}