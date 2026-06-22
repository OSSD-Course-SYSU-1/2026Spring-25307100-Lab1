
import ThemeManager from '../../utils/ThemeManager'

@Component
export default struct Home {
  pageStack: NavPathStack = new NavPathStack()
  @State isDarkMode: boolean = ThemeManager.isDarkMode()

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
        // 内容项
        Text("首页")
          .width('100%')
          .height('100%')
          .textAlign(TextAlign.Center)
          .fontSize("25fp")
          .fontColor(ThemeManager.getTextPrimaryColor())
      }
      .size({ width: '100%', height: '100%' })
      .backgroundColor(ThemeManager.getBackgroundColor())
    }
    .mode(NavigationMode.Stack)
    .titleMode(NavigationTitleMode.Mini)
    .title("首页")
    .hideBackButton(true)
    .width('100%')
    .height('100%')
    .backgroundColor(ThemeManager.getBackgroundColor())
  }
}