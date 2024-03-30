# 애플페이 가맹점 위치 제공 서비스 


2023년 1학기 캡스톤 디자인 프로젝트 (2023.03 ~ 2023.06)



## 팀원 소개 
<table style="text-align:center;">
  <tr>
    <th>이상민</th>
    <th>이승훈</th>
    <th>박수련</th>
    <th>정경인</th>	
  </tr>
  <tr>
    <td>팀장, 기획 및 데이터 처리</td>
    <td>프로젝트 초기 세팅 및 iOS 개발</td>
    <td>firestore 데이터 연동 및 UI 개발</td>
    <td>UI 디자인 및 UI 개발</td>	
  </tr>
  <tr>
    <td>2017110922</td>
    <td>2017112197</td>
    <td>2019112132</td>
    <td>2023130002</td>	
  </tr>
  <tr>
    <td>경제학과</td>
    <td>정보통신공학과</td>
    <td>정보통신공학과</td>
    <td>정보통신공학과</td>
  </tr>
  
</table>

<br>
  

## 기술스택
<div style="display:flex; flex-direction:column;">
  <div style="flex-direction:column; width:50%; ">
    <h3 style="marin:0px;">Environment</h3>
    <div style="display:flex;">
      <img style="margin-right:5px;" 		src="https://img.shields.io/badge/android studio-3DDC84.svg?style=for-the-badge&logo=androidstudio&logoColor=white" />
    <img style="margin-right:5px;" src="https://img.shields.io/badge/xcode-147EFB.svg?style=for-the-badge&logo=xcode&logoColor=white" />
    <img style="margin-right:5px;" src="https://img.shields.io/badge/git-691A99.svg?style=for-the-badge&logo=git&logoColor=white" />
    </div>
  </div>
  <h3>Development</h3>
  <div style="display:flex;">
    <img style="margin-right:5px;" src="https://img.shields.io/badge/flutter-02569B.svg?style=for-the-badge&logo=flutter&logoColor=white" />
    <img style="margin-right:5px;" src="https://img.shields.io/badge/dart-0175C2.svg?style=for-the-badge&logo=dart&logoColor=white" />
    <img style="margin-right:5px;" src="https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=white" />
    <img style="margin-right:5px;" src="https://img.shields.io/badge/google cloud-4285F4.svg?style=for-the-badge&logo=googlecloud&logoColor=white" />
    <img style="margin-right:5px;" src="https://img.shields.io/badge/google maps-4285F4.svg?style=for-the-badge&logo=googlemaps&logoColor=white" />
  </div>
  <h3>Communication</h3>  
  <div style="display:flex;">
    <img style="margin-right:5px;" src="https://img.shields.io/badge/Notion-F3F3F3.svg?style=for-the-badge&logo=notion&logoColor=black" />
    <img style="margin-right:5px;" src="https://img.shields.io/badge/github-181717.svg?style=for-the-badge&logo=github&logoColor=white" />
  </div>
</div>

<br>

## 프로젝트 소개
2023년 3월부터 한국에 애플페이가 도입되면서 애플페이 가맹점 정보를 제공하여 사용자의 불편함을 줄이고자 프로젝트를 기획하게 되었다. 현재 위치에 따른 애플페이 사용가능 가맹점의 위치 정보를 제공하며 해당 매장에 대한 리뷰를 남길 수 있다. 

<br>

## 주요 기능

### 위치 찾기
사용자의 위치를 엑세스하여 500m 이내에 위치하는 애플페이 사용가능 매장을 지도에서 확인할 수 있다. 원하는 위치로 지도를 이동시켜 화면 중심 위치를 기준으로 500m 이내 매장도 확인 가능하다. 
카테고리에 따라 원하는 가맹점의 업종을 필터링하여 볼 수 있다. 
<br>
<img style="height:500px; margin-top:20px;"
     src="https://velog.velcdn.com/images/tnfus916/post/ac928bcc-e3d7-4ee1-9f28-f77d64200734/image.png" />
     
<br>

### 로그인
커뮤니티 페이지 사용을 위한 사용자의 정보를 저장하기 위해 로그인을 필요로 했다. 사용자의 편의를 위해 소셜 로그인을 사용했다. 
<br>
<img style="height:500px; margin-top:20px;"
     src="https://velog.velcdn.com/images/tnfus916/post/73d5f75c-6332-4712-bda1-583b9011831b/image.png" />


<br>

### 커뮤니티
소상공인이 운영하는 가맹점의 애플페이 사용가능 여부를 공유할 수 있으며 매장에 대한 리뷰를 남길 수 있다. 소상공인과 사용자간의 소통의 장을 마련하여 다른 사용자들에게 유익한 정보를 제공하는 효과를 기대할 수 있다.
<br>
<div style="display:flex; justify-content:center; margin-top:20px;"
  <img style="height:500px; margin-right:20px;"
     src="https://velog.velcdn.com/images/tnfus916/post/b9cf1497-31f8-4678-9d73-f9de2bc28711/image.png" />
  <img style="height:500px;"
     src="https://velog.velcdn.com/images/tnfus916/post/15b07bad-af9c-43ce-afa5-0c334106c4a8/image.png" />
</div>

<br>

## 코드 및 브런치 구성
 - main 브런치
    - 웹과 안드로이드 앱을 실행하는 브런치
- lsh-ios
    - ios앱을 실행하는 브런치
   
- 파일의 경로
    - lib 파일 → main.dart
        - 애플리케이션 실행 시 시작하는  파일
    - lib 파일 → src 파일 → googleMap.dart
        - 구글맵 및 시작화면 파일
    - lib 파일 → mypage 파일
        - 마이페이지를 위한 코드 파일들이 위치
    - lib 파일 → community 파일
        - 커뮤니티 페이지들을 위한 코드 파일들이 위치

<br>

## 회고
1. 애플페이가 가능한 매장에 대한 API가 없었기 때문에 일일이 공공 데이터를 전처리한 점이 아쉽다. 
2. 구글 맵 페이지의 마커와 커뮤니티 페이지 간의 유기적 연결성이 부족하다.
3. 데이터 fetching 속도를 개선할 필요가 있다. 
