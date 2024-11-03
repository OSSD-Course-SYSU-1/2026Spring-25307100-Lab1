

@Component
export default struct Mine {
  pageStack: NavPathStack = new NavPathStack()
  build() {
    Navigation(this.pageStack) {
      Column() {
        Column(){
            Button('登录').width(120).fontColor(Color.Green)
              .align(Alignment.Center).backgroundColor(Color.White)
        }
        .justifyContent(FlexAlign.Center)
        .backgroundColor('rgba(85, 170, 255,0.6)')
        .size({ width: '100%', height: 200 })

        Row({space:30}){
          Column({space:2}){
            Text('0')
            Text('收藏影视').fontColor('#AAAAAA')
          }

          Column({space:2}){
            Text('0')
            Text('播放历史').fontColor('#AAAAAA')
          }

          Column({space:2}){
            Text('0')
            Text('收藏音乐').fontColor('#AAAAAA')
          }

          Column({space:2}){
            Text('0')
            Text('我的足迹').fontColor('#AAAAAA')
          }

        }
        .justifyContent(FlexAlign.Center)
        .backgroundColor(Color.White)
        .width('100%').height(80)

        //功能列表
        Column(){
          Text('功能列表').align(Alignment.TopStart).padding(10)

        }.width('100%').height(200).justifyContent(FlexAlign.Start).backgroundColor(Color.White)

        //菜单项
        List({ space: 15 }) {
          ListItem(){
            Row(){
             Text('我的消息').layoutWeight(12)
             Text('>').fontColor('#AAAAAA').layoutWeight(1)
            }
          }
          ListItem(){
            Row(){
              Text('意见反馈').layoutWeight(12)
              Text('>').fontColor('#AAAAAA').layoutWeight(1)
            }
          }
          ListItem(){
            Row(){
              Text('分享链接').layoutWeight(12)
              Text('>').fontColor('#AAAAAA').layoutWeight(1)
            }
          }
          ListItem(){
            Row(){
              Text('检查更新').layoutWeight(12)
              Text('>').fontColor('#AAAAAA').layoutWeight(1)
            }
          }
          ListItem(){
            Row(){
              Text('关于我们').layoutWeight(12)
              Text('>').fontColor('#AAAAAA').layoutWeight(1)
            }
          }
        }.divider({strokeWidth:2,color:'#F1F3F5'})
        .padding(10)
      }
      .backgroundColor('F4F4F4')
      .size({ width: '100%', height: '100%' })
    }
    .mode(NavigationMode.Stack)
    .titleMode(NavigationTitleMode.Mini)
    .title("我的")
    .hideBackButton(true)
    .width('100%').height('100%')

  }
}