
import ThemeManager from '../../utils/ThemeManager'
import { BreakpointConstants, BreakpointType } from "../../utils/BreakpointSystem";
import BreakpointSystem from "../../utils/BreakpointSystem";
import { TextAlign } from '@kit.ArkUI';

@Component
export default struct Home {
  pageStack: NavPathStack = new NavPathStack()
  @State isDarkMode: boolean = ThemeManager.isDarkMode()
  @StorageProp(BreakpointConstants.CURRENT_BREAKPOINT_KEY) currentBreakpoint: string = BreakpointConstants.BREAKPOINT_NAMES[0]

  // 判断是否为大屏设备
  private isLargeScreen(): boolean {
    const breakpoint = this.currentBreakpoint;
    return breakpoint === BreakpointType.LG || breakpoint === BreakpointType.XL;
  }

  // 根据屏幕尺寸获取字体大小
  private getFontSize(baseSize: number): number {
    return BreakpointSystem.getFontSize(baseSize);
  }

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
        // 响应式标题
        Text(this.isLargeScreen() ? "知乎日报 - 首页" : "首页")
          .width('100%')
          .height(this.isLargeScreen() ? '15%' : '100%')
          .textAlign(TextAlign.Center)
          .fontSize(this.isLargeScreen() ? "32fp" : "25fp")
          .fontColor(ThemeManager.getTextPrimaryColor())
          .fontWeight(this.isLargeScreen() ? FontWeight.Bold : FontWeight.Normal)
          .margin({ top: this.isLargeScreen() ? 40 : 0 })

        // 大屏布局：显示更多内容
        if (this.isLargeScreen()) {
          Column({ space: 24 }) {
            Text("欢迎使用知乎日报")
              .fontSize(this.getFontSize(18))
              .fontColor(ThemeManager.getTextSecondaryColor())
              .textAlign(TextAlign.Center)
              .width('100%')

            Text("在这里，您可以浏览最新的知乎日报内容，了解热点新闻和深度分析。")
              .fontSize(this.getFontSize(16))
              .fontColor(ThemeManager.getTextTertiaryColor())
              .textAlign(TextAlign.Center)
              .width('80%')
              .multilineTextAlignment(TextAlign.Center)
          }
          .width('100%')
          .height('85%')
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
        }
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