/**
 * @author: ArmyQin
 * @date: 2026/06/22
 * @description: 主题管理器，支持夜间模式和日间模式切换
 * @version: 1.0
 */
import { Log } from './logutil';
import PreferencesUtils from './PreferencesUtils';
import { Context } from '@kit.AbilityKit';

const TAG = '[ThemeManager]';
const THEME_PREF_KEY = 'app_theme_mode';
const THEME_LIGHT = 'light';
const THEME_DARK = 'dark';

/**
 * 主题颜色定义
 */
export class ThemeColors {
  // 背景色
  static readonly BACKGROUND_LIGHT = '#FFFFFF';
  static readonly BACKGROUND_DARK = '#121212';
  
  // 卡片背景色
  static readonly CARD_BACKGROUND_LIGHT = '#F8F9FA';
  static readonly CARD_BACKGROUND_DARK = '#1E1E1E';
  
  // 文字颜色
  static readonly TEXT_PRIMARY_LIGHT = '#000000';
  static readonly TEXT_PRIMARY_DARK = '#FFFFFF';
  static readonly TEXT_SECONDARY_LIGHT = '#666666';
  static readonly TEXT_SECONDARY_DARK = '#AAAAAA';
  static readonly TEXT_TERTIARY_LIGHT = '#999999';
  static readonly TEXT_TERTIARY_DARK = '#888888';
  
  // 边框颜色
  static readonly BORDER_LIGHT = '#E0E0E0';
  static readonly BORDER_DARK = '#333333';
  
  // 主色调
  static readonly PRIMARY_LIGHT = '#28bff1';
  static readonly PRIMARY_DARK = '#4fc3f7';
  
  // 标签栏颜色
  static readonly TAB_BAR_BACKGROUND_LIGHT = '#FFFFFF';
  static readonly TAB_BAR_BACKGROUND_DARK = '#1A1A1A';
  
  // 分割线颜色
  static readonly DIVIDER_LIGHT = '#F1F3F5';
  static readonly DIVIDER_DARK = '#2D2D2D';
}

/**
 * 主题管理器类
 */
export class ThemeManager {
  private static instance: ThemeManager;
  private currentTheme: string = THEME_LIGHT;
  private listeners: Array<(theme: string) => void> = [];
  
  // 私有构造函数
  private constructor() {}
  
  /**
   * 获取单例实例
   */
  public static getInstance(): ThemeManager {
    if (!ThemeManager.instance) {
      ThemeManager.instance = new ThemeManager();
    }
    return ThemeManager.instance;
  }
  
  /**
   * 初始化主题管理器
   */
  public async init(context: Context): Promise<void> {
    Log.info(TAG, '初始化主题管理器');
    PreferencesUtils.createPreferences(context);
    
    try {
      const savedTheme = await PreferencesUtils.getPreferences(THEME_PREF_KEY) as string;
      if (savedTheme && (savedTheme === THEME_LIGHT || savedTheme === THEME_DARK)) {
        this.currentTheme = savedTheme;
        Log.info(TAG, `从本地存储加载主题: ${this.currentTheme}`);
      } else {
        // 默认使用日间模式
        this.currentTheme = THEME_LIGHT;
        await this.saveThemeToStorage();
        Log.info(TAG, '使用默认主题: 日间模式');
      }
    } catch (error) {
      Log.error(TAG, `加载主题设置失败: ${error}`);
      this.currentTheme = THEME_LIGHT;
    }
  }
  
  /**
   * 获取当前主题
   */
  public getCurrentTheme(): string {
    return this.currentTheme;
  }
  
  /**
   * 判断是否为夜间模式
   */
  public isDarkMode(): boolean {
    return this.currentTheme === THEME_DARK;
  }
  
  /**
   * 切换主题
   */
  public async toggleTheme(): Promise<void> {
    const newTheme = this.currentTheme === THEME_LIGHT ? THEME_DARK : THEME_LIGHT;
    await this.setTheme(newTheme);
  }
  
  /**
   * 设置主题
   */
  public async setTheme(theme: string): Promise<void> {
    if (theme !== THEME_LIGHT && theme !== THEME_DARK) {
      Log.error(TAG, `无效的主题: ${theme}`);
      return;
    }
    
    if (this.currentTheme !== theme) {
      this.currentTheme = theme;
      await this.saveThemeToStorage();
      this.notifyListeners();
      Log.info(TAG, `主题已切换为: ${theme}`);
    }
  }
  
  /**
   * 保存主题到本地存储
   */
  private async saveThemeToStorage(): Promise<void> {
    try {
      PreferencesUtils.savePreferences(THEME_PREF_KEY, this.currentTheme);
    } catch (error) {
      Log.error(TAG, `保存主题设置失败: ${error}`);
    }
  }
  
  /**
   * 注册主题变化监听器
   */
  public addThemeChangeListener(listener: (theme: string) => void): void {
    if (!this.listeners.includes(listener)) {
      this.listeners.push(listener);
    }
  }
  
  /**
   * 移除主题变化监听器
   */
  public removeThemeChangeListener(listener: (theme: string) => void): void {
    const index = this.listeners.indexOf(listener);
    if (index > -1) {
      this.listeners.splice(index, 1);
    }
  }
  
  /**
   * 通知所有监听器主题已变化
   */
  private notifyListeners(): void {
    this.listeners.forEach(listener => {
      try {
        listener(this.currentTheme);
      } catch (error) {
        Log.error(TAG, `通知监听器失败: ${error}`);
      }
    });
  }
  
  /**
   * 根据当前主题获取颜色
   */
  public getColor(lightColor: string, darkColor: string): string {
    return this.isDarkMode() ? darkColor : lightColor;
  }
  
  /**
   * 获取背景色
   */
  public getBackgroundColor(): string {
    return this.getColor(ThemeColors.BACKGROUND_LIGHT, ThemeColors.BACKGROUND_DARK);
  }
  
  /**
   * 获取卡片背景色
   */
  public getCardBackgroundColor(): string {
    return this.getColor(ThemeColors.CARD_BACKGROUND_LIGHT, ThemeColors.CARD_BACKGROUND_DARK);
  }
  
  /**
   * 获取主要文字颜色
   */
  public getTextPrimaryColor(): string {
    return this.getColor(ThemeColors.TEXT_PRIMARY_LIGHT, ThemeColors.TEXT_PRIMARY_DARK);
  }
  
  /**
   * 获取次要文字颜色
   */
  public getTextSecondaryColor(): string {
    return this.getColor(ThemeColors.TEXT_SECONDARY_LIGHT, ThemeColors.TEXT_SECONDARY_DARK);
  }
  
  /**
   * 获取第三级文字颜色
   */
  public getTextTertiaryColor(): string {
    return this.getColor(ThemeColors.TEXT_TERTIARY_LIGHT, ThemeColors.TEXT_TERTIARY_DARK);
  }
  
  /**
   * 获取边框颜色
   */
  public getBorderColor(): string {
    return this.getColor(ThemeColors.BORDER_LIGHT, ThemeColors.BORDER_DARK);
  }
  
  /**
   * 获取主色调
   */
  public getPrimaryColor(): string {
    return this.getColor(ThemeColors.PRIMARY_LIGHT, ThemeColors.PRIMARY_DARK);
  }
  
  /**
   * 获取标签栏背景色
   */
  public getTabBarBackgroundColor(): string {
    return this.getColor(ThemeColors.TAB_BAR_BACKGROUND_LIGHT, ThemeColors.TAB_BAR_BACKGROUND_DARK);
  }
  
  /**
   * 获取分割线颜色
   */
  public getDividerColor(): string {
    return this.getColor(ThemeColors.DIVIDER_LIGHT, ThemeColors.DIVIDER_DARK);
  }
}

// 导出单例实例
export default ThemeManager.getInstance();