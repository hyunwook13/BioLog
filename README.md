
# 📚 BioLog — 문학 속 인물을 기억하는 가장 스마트한 방법

> **"Never lose track of characters again."**  
> BioLog는 인물 중심으로 독서 경험을 향상시키는 iOS 앱입니다.  
> 복잡한 등장인물, 얽힌 관계, 장대한 시리즈도 BioLog와 함께라면 문제없습니다.

<p align="center">
  <img src="https://img.shields.io/badge/iOS-15.0+-blue?style=for-the-badge&logo=apple">
  <img src="https://img.shields.io/badge/Swift-5-orange?style=for-the-badge&logo=swift">
  <img src="https://img.shields.io/badge/RxSwift-enabled-green?style=for-the-badge">
</p>


## ✨ 주요 기능

- 🧠 **인물 중심 독서 기록**  
  각 등장인물의 성격, 배경, 변화 과정을 한눈에 기록하고 추적할 수 있어요.

- 🧩 **관계도 자동 구성**  
  인물 간 상호작용을 기반으로 관계도를 시각화해주는 기능.

- 📚 **책 별 / 시리즈 별 분류**  
  여러 책의 인물을 한 계정에서 나눠서 관리 가능.

- 💾 **오프라인 저장 + 클라우드 연동**  
  CoreData 기반 저장 + 로그인 기능으로 확장 중.


## 🛠️ 기술 스택

| 분야             | 사용 기술 |
|------------------|-----------|
| UI               | `SwiftUI`, `SnapKit` (UIKit 베이스) |
| 아키텍처         | Clean Architecture, MVVM-C |
| 반응형 프로그래밍 | `RxSwift`, `RxCocoa`, `RxDataSources` |
| 영속성           | `CoreData` |
| 테스트           | `XCTest`, `XCUITest` |


## 🚀 프로젝트 구조
```
📦 BioLog
     └─ Source
          ├─ Applications
          ├─ Data
          ├─ Domain
          ├─ Infrastructure/Network
          └─ Presentation
     └─ Test
