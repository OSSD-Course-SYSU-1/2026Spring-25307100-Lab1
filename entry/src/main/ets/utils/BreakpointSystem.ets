/**
 * @author: ArmyQin
 * @date: 2026/06/22
 * @description: 响应式布局断点系统，用于监听窗口尺寸变化并管理断点状态
 * @version: 1.0
 */

import { display, window } from '@kit.ArkUI';
import { Log } from './logutil';

const TAG = '[BreakpointSystem]';

/**
 * 断点类型定义
 */
export enum BreakpointType {
  XS = 'xs', // 超小屏 (0-320vp)
  SM = 'sm', // 小屏 (320-600vp) - 手机竖屏
  MD = 'md', // 中屏 (600-840vp) - 平板竖屏/折叠屏
  LG = 'lg', // 大屏 (840-1440vp) - 平板横屏/PC
  XL = 'xl'  // 超大屏 (1440vp+) - 大屏设备
}

/**
 * 断点常量定义
 */
export class BreakpointConstants {
  // 断点阈值 (单位: vp)
  static readonly BREAKPOINT_XS: number = 0;
  static readonly BREAKPOINT_SM: number = 320;
  static readonly BREAKPOINT_MD: number = 600;
  static readonly BREAKPOINT_LG: number = 840;
  static readonly BREAKPOINT_XL: number = 1440;

  // 断点值数组
  static readonly BREAKPOINT_VALUES: number[] = [
    BreakpointConstants.BREAKPOINT_SM,
    BreakpointConstants.BREAKPOINT_MD,
    BreakpointConstants.BREAKPOINT_LG,
    BreakpointConstants.BREAKPOINT_XL
  ];

  // 断点名称数组
  static readonly BREAKPOINT_NAMES: string[] = [
    BreakpointType.SM,
    BreakpointType.MD,
    BreakpointType.LG,
    BreakpointType.XL
  ];

  // AppStorage 存储键名
  static readonly CURRENT_BREAKPOINT_KEY = 'currentBreakpoint';
  static readonly WINDOW_WIDTH_KEY = 'windowWidth';
  static readonly WINDOW_HEIGHT_KEY = 'windowHeight';
}

/**
 * 断点系统管理器
 */
export class BreakpointSystem {
  private static instance: BreakpointSystem;
  private windowObj: window.Window | null = null;
  private uiContext: UIContext | null = null;
  private windowSizeChangeCallback: ((size: window.Size) => void) | null = null;

  // 私有构造函数
  private constructor() {}

  /**
   * 获取单例实例
   */
  public static getInstance(): BreakpointSystem {
    if (!BreakpointSystem.instance) {
      BreakpointSystem.instance = new BreakpointSystem();
    }
    return BreakpointSystem.instance;
  }

  /**
   * 注册断点监听
   * @param windowClass 窗口对象
   */
  public register(windowClass: window.Window): void {
    try {
      this.windowObj = windowClass;
      this.uiContext = windowClass.getUIContext();
      
      // 获取初始窗口尺寸并计算断点
      const windowProperties = windowClass.getWindowProperties();
      const initialWidth = this.uiContext.px2vp(windowProperties.windowRect.width);
      const initialHeight = this.uiContext.px2vp(windowProperties.windowRect.height);
      const initialBreakpoint = this.calculateBreakpoint(initialWidth);
      
      // 保存初始状态到 AppStorage
      AppStorage.setOrCreate<number>(BreakpointConstants.WINDOW_WIDTH_KEY, initialWidth);
      AppStorage.setOrCreate<number>(BreakpointConstants.WINDOW_HEIGHT_KEY, initialHeight);
      AppStorage.setOrCreate<string>(BreakpointConstants.CURRENT_BREAKPOINT_KEY, initialBreakpoint);
      
      Log.info(TAG, `初始断点: ${initialBreakpoint}, 窗口尺寸: ${initialWidth}x${initialHeight}vp`);
      
      // 监听窗口尺寸变化
      this.windowSizeChangeCallback = (size: window.Size) => {
        if (this.uiContext) {
          const newWidth = this.uiContext.px2vp(size.width);
          const newHeight = this.uiContext.px2vp(size.height);
          const newBreakpoint = this.calculateBreakpoint(newWidth);
          
          // 更新 AppStorage 中的状态
          AppStorage.setOrCreate<number>(BreakpointConstants.WINDOW_WIDTH_KEY, newWidth);
          AppStorage.setOrCreate<number>(BreakpointConstants.WINDOW_HEIGHT_KEY, newHeight);
          
          const currentBreakpoint = AppStorage.get<string>(BreakpointConstants.CURRENT_BREAKPOINT_KEY);
          if (currentBreakpoint !== newBreakpoint) {
            AppStorage.setOrCreate<string>(BreakpointConstants.CURRENT_BREAKPOINT_KEY, newBreakpoint);
            Log.info(TAG, `断点变化: ${currentBreakpoint} -> ${newBreakpoint}, 窗口尺寸: ${newWidth}x${newHeight}vp`);
          }
        }
      };
      
      windowClass.on('windowSizeChange', this.windowSizeChangeCallback);
      Log.info(TAG, '窗口尺寸变化监听器已注册');
      
    } catch (err) {
      Log.error(TAG, `注册断点监听失败: ${JSON.stringify(err)}`);
    }
  }

  /**
   * 注销断点监听
   */
  public unregister(): void {
    if (this.windowObj && this.windowSizeChangeCallback) {
      try {
        this.windowObj.off('windowSizeChange', this.windowSizeChangeCallback);
        this.windowSizeChangeCallback = null;
        Log.info(TAG, '窗口尺寸变化监听器已注销');
      } catch (err) {
        Log.error(TAG, `注销断点监听失败: ${JSON.stringify(err)}`);
      }
    }
  }

  /**
   * 根据窗口宽度计算断点
   * @param widthVp 窗口宽度 (vp)
   * @returns 断点类型
   */
  private calculateBreakpoint(widthVp: number): string {
    if (widthVp < BreakpointConstants.BREAKPOINT_SM) {
      return BreakpointType.XS;
    } else if (widthVp < BreakpointConstants.BREAKPOINT_MD) {
      return BreakpointType.SM;
    } else if (widthVp < BreakpointConstants.BREAKPOINT_LG) {
      return BreakpointType.MD;
    } else if (widthVp < BreakpointConstants.BREAKPOINT_XL) {
      return BreakpointType.LG;
    } else {
      return BreakpointType.XL;
    }
  }

  /**
   * 获取当前断点
   * @returns 当前断点类型
   */
  public getCurrentBreakpoint(): string {
    return AppStorage.get<string>(BreakpointConstants.CURRENT_BREAKPOINT_KEY) || BreakpointType.SM;
  }

  /**
   * 获取当前窗口宽度 (vp)
   * @returns 窗口宽度
   */
  public getWindowWidth(): number {
    return AppStorage.get<number>(BreakpointConstants.WINDOW_WIDTH_KEY) || 360;
  }

  /**
   * 获取当前窗口高度 (vp)
   * @returns 窗口高度
   */
  public getWindowHeight(): number {
    return AppStorage.get<number>(BreakpointConstants.WINDOW_HEIGHT_KEY) || 780;
  }

  /**
   * 判断是否为小屏设备 (手机)
   */
  public isSmallScreen(): boolean {
    const breakpoint = this.getCurrentBreakpoint();
    return breakpoint === BreakpointType.XS || breakpoint === BreakpointType.SM;
  }

  /**
   * 判断是否为中屏设备 (平板/折叠屏)
   */
  public isMediumScreen(): boolean {
    return this.getCurrentBreakpoint() === BreakpointType.MD;
  }

  /**
   * 判断是否为大屏设备 (平板横屏/PC)
   */
  public isLargeScreen(): boolean {
    const breakpoint = this.getCurrentBreakpoint();
    return breakpoint === BreakpointType.LG || breakpoint === BreakpointType.XL;
  }

  /**
   * 判断是否为超大屏设备
   */
  public isXLargeScreen(): boolean {
    return this.getCurrentBreakpoint() === BreakpointType.XL;
  }

  /**
   * 根据断点获取对应的栅格列数
   */
  public getGridColumns(): number {
    const breakpoint = this.getCurrentBreakpoint();
    switch (breakpoint) {
      case BreakpointType.XS:
      case BreakpointType.SM:
        return 4; // 手机: 4列
      case BreakpointType.MD:
        return 8; // 平板竖屏/折叠屏: 8列
      case BreakpointType.LG:
      case BreakpointType.XL:
        return 12; // 平板横屏/PC: 12列
      default:
        return 4;
    }
  }

  /**
   * 根据断点获取对应的间距
   */
  public getSpacing(): number {
    const breakpoint = this.getCurrentBreakpoint();
    switch (breakpoint) {
      case BreakpointType.XS:
        return 8;
      case BreakpointType.SM:
        return 12;
      case BreakpointType.MD:
        return 16;
      case BreakpointType.LG:
        return 20;
      case BreakpointType.XL:
        return 24;
      default:
        return 12;
    }
  }

  /**
   * 根据断点获取对应的字体大小
   */
  public getFontSize(baseSize: number): number {
    const breakpoint = this.getCurrentBreakpoint();
    switch (breakpoint) {
      case BreakpointType.XS:
        return baseSize * 0.9;
      case BreakpointType.SM:
        return baseSize;
      case BreakpointType.MD:
        return baseSize * 1.1;
      case BreakpointType.LG:
        return baseSize * 1.2;
      case BreakpointType.XL:
        return baseSize * 1.3;
      default:
        return baseSize;
    }
  }
}

// 导出单例实例
export default BreakpointSystem.getInstance();