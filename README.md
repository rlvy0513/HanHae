# HanHae
> 한 해는 목표를 계획하고 성취도를 확인하며, 사용자에게 동기를 부여하기 위해 설계된 생산성 앱입니다.

<br>

## Features
### 한 달 단위의 목표 세우기
> 목표를 세우고 완료해보세요! 목표 완료율과 목표 시작일, 목표 완료일을 쉽게 확인할 수 있어요.

<img src="/Previews/1.gif" width="40%"></img>

### 목표를 리마인드 시켜드려요
> 목표 완료가 힘들다구요? 걱정마세요! 한 해에서 알림을 통해 목표를 리마인드 시켜드릴게요.

<img src="/Previews/2.gif" width="40%"></img>

### 한 해 동안 세운 목표은 한 눈에 볼 수 있어요
> 레이아웃 변경 버튼을 통해 한 해 동안 세운 목표를 한 눈에 확인할 수 있어요.

<img src="/Previews/3.gif" width="40%"></img>

### 다양한 설정이 가능해요
> 라이트 모드/다크 모드 설정, 언어 설정, 피드백 및 평점 남기기를 할 수 있어요.

<img src="/Previews/4.gif" width="40%"></img>


<br>

## Directory Structure
```
HanHae
  ├─ AppDelegate.swift
  ├─ Assets.xcassets
  │   ├─ AccentColor.colorset
  │   ├─ AppIcon.appiconset
  ├─ Localizable.xcstrings
  ├─ Models
  │   ├─ HHMonth+CoreDataClass.swift
  │   ├─ HHMonth+CoreDataProperties.swift
  │   ├─ HHYear+CoreDataClass.swift
  │   ├─ HHYear+CoreDataProperties.swift
  │   ├─ ToDo+CoreDataClass.swift
  │   └─ ToDo+CoreDataProperties.swift
  ├─ Resources
  │   ├─ Assets.xcassets
  │   │   ├─ AccentColor.colorset
  │   │   ├─ AppIcon.appiconset
  │   │   └─ EmptyViewImage.imageset
  │   ├─ Colors.xcassets
  │   └─ Fonts
  ├─ SceneDelegate.swift
  ├─ Services
  │   ├─ CoreDataInitializer.swift
  │   └─ CoreDataManager.swift
  ├─ Utilities
  │   ├─ Extensions
  │   │   ├─ Date+Extension.swift
  │   │   ├─ Notification+Extension.swift
  │   │   └─ UIFont+Extension.swift
  │   └─ Helpers
  │       └─ DeviceInfo.swift
  ├─ ViewModels
  │   ├─ Months
  │   │   └──MonthlyViewModel.swift
  │   ├─ SampleViewModel.swift
  │   ├─ Settings
  │   │   └─ SettingsViewModel.swift
  │   └─ Years
  │       └─ YearsViewModel.swift
  └─ Views
      ├─ Base.lproj
      ├─ HHBaseViewController.swift
      ├─ Months
      │   ├─ DetailViewController.swift
      │   ├─ MonthlyMottoViewController.swift
      │   ├─ MonthlyViewController.swift
      │   └─ ToDoListTableViewCell.swift
      ├─ Settings
      │   ├─ SettingDetailViewController.swift
      │   ├─ SettingsBaseViewController.swift
      │   └─ SettingsViewController.swift
      └─ Years
          ├─ MonthlyCell.swift
          ├─ YearHeaderView.swift
          └─ YearsViewController.swift
```


<br>

## Skills
### Architecture
* `MVVM`

### Tech Stack
* `SwiftUI`

### 개발 및 테스트 환경
* `XCode 16.1`
* `Swift 6.0.2`
* `iOS 17.6 +`


<br>

## Developers

| <img src="https://avatars.githubusercontent.com/u/103730885?v=4" width="120"> | <img src="https://avatars.githubusercontent.com/u/72730841?v=4" width="120"> |
|:--:|:--:|
| [**김기표**](https://github.com/rlvy0513) <br> 목표 관리 구현 <br> 알림 기능 | [**김성민**](https://github.com/marukim365) <br> 연월 데이터 관리 <br> 설정 및 번역 |


<br>

## License
Copyright KimBrothers. All rights reserved.     
Licensed under the [MIT](LICENSE) license.    
