
import ThemeManager from '../../utils/ThemeManager'

interface FavBtnItem{
  count:number;
  title:string;
  pagePath:string;
}

interface ListBtnItem{
  title:string;
  pagePath:string;
}

interface FunBtnItem{
  title:string;
  color:string;
  icon:string;
  pagePath:string;
}

@Component
export default struct Mine {
  pageStack: NavPathStack = new NavPathStack()
  @State isDarkMode: boolean = ThemeManager.isDarkMode()

  private favButtons:FavBtnItem[] = [
    {count:0,title:"收藏影视",pagePath:""},
    {count:0,title:"播放历史",pagePath:""},
    {count:0,title:"收藏音乐",pagePath:""},
    {count:0,title:"我的足迹",pagePath:""},
  ]

  private listButtons:ListBtnItem[] = [
    {title:"我的消息",pagePath:""},
    {title:"意见反馈",pagePath:""},
    {title:"分享链接",pagePath:""},
    {title:"检查更新",pagePath:""},
    {title:"关于我们",pagePath:""},
  ]

  private funButtons:FunBtnItem[] = [
    {title:"电视直播",color:'#00FF00',icon:'app.media.camera_video',pagePath:""},
    {title:"本地视频",color:'#00FF00',icon:'app.media.music',pagePath:""},
    {title:"本地图片",color:'#00FF00',icon:'app.media.music',pagePath:""},
    {title:"在线音乐",color:'#00FF00',icon:'app.media.music',pagePath:""},
    {title:"播放链接",color:'#00FF00',icon:'app.media.music',pagePath:""},
  ]
  aboutToAppear() {
    // 监听主题变化
    ThemeManager.addThemeChangeListener((theme: string) => {
      this.isDarkMode = theme === 'dark';
    });
  }

  aboutToDisappear() {
    // 清理监听器
    ThemeManager.removeThemeChangeListener((theme: string) => {
      this.isDarkMode = theme === 'dark';
    });
  }

  build() {
    Navigation(this.pageStack) {
      Column() {
        Column(){
            Button('登录').width(120).fontColor(ThemeManager.getPrimaryColor())
              .align(Alignment.Center).backgroundColor(ThemeManager.getCardBackgroundColor())
        }
        .justifyContent(FlexAlign.Center)
        .backgroundColor(ThemeManager.getCardBackgroundColor())
        .size({ width: '100%', height: 200 })

        Row({space:30}){
          ForEach(this.favButtons, (item:FavBtnItem,idx) => {
            Column({space:2}){
              Text(item.count.toString()).fontColor(ThemeManager.getTextPrimaryColor())
              Text(item.title).fontColor(ThemeManager.getTextSecondaryColor())
            }
          })
        }
        .justifyContent(FlexAlign.Center)
        .backgroundColor(ThemeManager.getCardBackgroundColor())
        .width('100%').height(80)

        //功能列表
        Column(){
          Text('功能列表').width('100%').padding(10).fontColor(ThemeManager.getTextPrimaryColor())
          Grid() {
            ForEach(this.funButtons, (item:FunBtnItem,idx) => {
              GridItem() {
                Column({space:2}){
                  Image($r(item.icon)).width(32).fillColor(item.color)
                  Text(item.title).fontSize(14).fontColor(ThemeManager.getTextPrimaryColor())
                }
              }
            })
            }
          .rowsTemplate('1fr 1fr')
          .columnsTemplate('1fr 1fr 1fr 1fr')
          .width('100%').height(150)

        }.width('100%').height(200).justifyContent(FlexAlign.Start).backgroundColor(ThemeManager.getCardBackgroundColor())

        //菜单项
        List({ space: 15 }) {
          ForEach(this.listButtons, (item:ListBtnItem,idx) => {
            ListItem(){
              Row(){
                Text(item.title).layoutWeight(12).fontColor(ThemeManager.getTextPrimaryColor())
                Text('>').fontColor(ThemeManager.getTextSecondaryColor()).layoutWeight(1)
              }
            }
          })
        }.divider({strokeWidth:2,color:ThemeManager.getDividerColor()})
        .padding(10)
      }
      .backgroundColor(ThemeManager.getBackgroundColor())
      .size({ width: '100%', height: '100%' })
    }
    .mode(NavigationMode.Stack)
    .titleMode(NavigationTitleMode.Mini)
    .title("我的")
    .hideBackButton(true)
    .backgroundColor(ThemeManager.getBackgroundColor())
    .width('100%').height('100%')

  }
}