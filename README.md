# Weather App
openweathermap 날씨 API를 이용한 날씨 앱
<img width="400" alt="" src="https://user-images.githubusercontent.com/29617557/130205013-403aeb8b-a945-4334-bab1-95f244ec667b.jpeg">

## 기능
현재 위치 정보에 기반하여
1. 현재 날씨
2. 가로 Scroll View 활용하여 1시간 간격 날씨, 습도 표시
3. 주간 날씨

## 구조
#### ViewController.swift
현재 날씨 표시 및 ```TemperatureViewController```, ```WeeklyViewController```를 표시하는 Container View 2개를 포함

#### TemperatureViewController.swift
시간대별 날씨를 가로 스크롤뷰를 이용하여 표시

#### WeeklyViewController.swift
주간예보 표시

#### Weather.swift
Openweathermap으로부터 받아온 JSON 데이터 중 사용할 데이터만 저장하기 위한 데이터 모델

#### ~~Property List.plist~~
For hiding API key


