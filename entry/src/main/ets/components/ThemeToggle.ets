/**
 * @author: ArmyQin
 * @date: 2026/06/22
 * @description: 主题切换组件
 * @version: 1.0
 */
import ThemeManager, { ThemeColors } from '../utils/ThemeManager';

@Component
export struct ThemeToggle {
  @Link @Watch('onThemeChange') isDarkMode: boolean;
  @State private isAnimating: boolean = false;
  
  // 监听主题变化
  private onThemeChange(): void {
    // 当主题变化时触发动画
    this.isAnimating = true;
    setTimeout(() => {
      this.isAnimating = false;
    }, 300);
  }
  
  build() {
    Row() {
      // 日间模式图标
      Image($r('app.media.sun'))
        .width(20)
        .height(20)
        .fillColor(this.isDarkMode ? ThemeColors.TEXT_SECONDARY_DARK : ThemeColors.PRIMARY_LIGHT)
        .opacity(this.isDarkMode ? 0.5 : 1)
      
      // 切换开关
      Toggle({ type: ToggleType.Switch, isOn: this.isDarkMode })
        .width(40)
        .height(24)
        .selectedColor(ThemeColors.PRIMARY_LIGHT)
        .switchPointColor('#FFFFFF')
        .onChange((isOn: boolean) => {
          this.isDarkMode = isOn;
          ThemeManager.setTheme(isOn ? 'dark' : 'light');
        })
        .margin({ left: 8, right: 8 })
      
      // 夜间模式图标
      Image($r('app.media.moon'))
        .width(20)
        .height(20)
        .fillColor(this.isDarkMode ? ThemeColors.PRIMARY_DARK : ThemeColors.TEXT_SECONDARY_LIGHT)
        .opacity(this.isDarkMode ? 1 : 0.5)
    }
    .padding(8)
    .borderRadius(20)
    .backgroundColor(this.isDarkMode ? 'rgba(255, 255, 255, 0.1)' : 'rgba(0, 0, 0, 0.05)')
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Center)
    .scale({ x: this.isAnimating ? 1.1 : 1, y: this.isAnimating ? 1.1 : 1 })
    .animation({ duration: 300, curve: Curve.EaseInOut })
  }
}

/**
 * 简单的主题切换按钮（仅图标）
 */
@Component
export struct ThemeIconButton {
  @Link @Watch('onThemeChange') isDarkMode: boolean;
  @State private isAnimating: boolean = false;
  
  // 监听主题变化
  private onThemeChange(): void {
    this.isAnimating = true;
    setTimeout(() => {
      this.isAnimating = false;
    }, 300);
  }
  
  build() {
    Button() {
      Image(this.isDarkMode ? $r('app.media.moon') : $r('app.media.sun'))
        .width(24)
        .height(24)
        .fillColor(this.isDarkMode ? ThemeColors.PRIMARY_DARK : ThemeColors.PRIMARY_LIGHT)
    }
    .width(48)
    .height(48)
    .backgroundColor(this.isDarkMode ? 'rgba(255, 255, 255, 0.1)' : 'rgba(0, 0, 0, 0.05)')
    .borderRadius(24)
    .onClick(() => {
      const newTheme = this.isDarkMode ? 'light' : 'dark';
      this.isDarkMode = !this.isDarkMode;
      ThemeManager.setTheme(newTheme);
    })
    .scale({ x: this.isAnimating ? 1.1 : 1, y: this.isAnimating ? 1.1 : 1 })
    .animation({ duration: 300, curve: Curve.EaseInOut })
  }
}