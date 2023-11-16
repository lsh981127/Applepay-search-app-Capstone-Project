# newcapstone

2023년 1학기 캡스톤 디자인(박은찬 교수님) 6조 프로젝트
- 제목 : 애플페이 가맹점 정보제공 서비스
- 팀원 : 2017110922 이상민, 2017112197 이승훈, 2019112132 박수련, 2023130002 정경인


 코드 및 브런치 구성
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

## 개발 배경
애플사가 제공하는 모바일 결제 서비스 애플 페이가 한국에서 서비스를 실시한다. 하지만 이를 사용하는데 많은 제약이 있다. 우선 사용처가 NFC(Near field Communication) 단말기를 갖추고, 애플 페이를 지원해야 한다. 하지만 현재 대한민국의 대부분의 매장은 마그네틱 보안전송(MST, Magnetic Secure Transmission)와 IC칩 결제방식을 사용하고 있어, NFC 단말기를 보유한 매장은 국내의 10%도 되지 않으며, NFC 단말기를 구매 하는 데는 약 20만원 정도 소비해야 한다. 삼성 페이는 이를 해결하기 위해 MST와 NFC 두 가지 방법이 모두 가능하도록 설계하여 현재 국내 사용자들은 삼성 페이를 불편함 없이 사용할 수 있다. 또한 당분간은 현대 카드만 애플페이를 지원하므로 애플페이의 출시가 매출의 증가로 이어지지 않을 것이라 생각하는 자영업자나 소상공인은 애플페이 환경을 구축하는데 적극적이지 않을 것이다. 이러한 이유로 당분간은 소수의 가게만이 애플페이를 지원할 것으로 예상되어 지도에 애플페이 가맹점을 표시하여 사용자의 정보 부족의 불편함을 줄여 애플페이 사용자 증가를 기대할 수 있고, 이는 가맹점의 증가로 이어질 가능성이 높아 애플페이의 상용화를 가속화시켜 궁극적으로는 가맹점을 지도로 찾지 않아도 되는 환경을 만드는 것이 본 조의 목표이다. 
애플페이는 실물 카드가 없어도 애플사의 제품으로 결제가 가능하다. 그러므로 카드를 가지고 있지 않을 때 유용하다. 만약 실물 카드를 소지하지 않았지만 급하게 무언가를 구매해야 하는 경우, 근처의 모든 가게에 가서 애플페이를 지원하는지 물어보기는 어렵다. 이 때 지도에 표시된 애플페이 가맹점을 보고 가장 가까운 가맹점을 지도의 지시를 보고 찾아갈 수 있어 애플페이가 상용화가 되기 전 까지 사용자가 불편함을 최대한으로 느끼지 않도록 한다.

## 메인페이지
### 웹화면
![image](https://github.com/lsh981127/Applepay-search-app-Capstone-Project/assets/83868210/8af9fa26-91f9-4002-b277-caac909b5ea2)
<br />
현위치 주변의 가맹점의 위치를 카테고리별로 확인할 수 있음

![image](https://github.com/lsh981127/Applepay-search-app-Capstone-Project/assets/83868210/840845e7-28c7-46dd-a078-1e6680703dca)
<br />
카테고리 버튼을 통해 원하는 항목의 가맹점들만 필터링할 수 있음

### iOS화면
![image](https://github.com/lsh981127/Applepay-search-app-Capstone-Project/assets/83868210/c5cc0481-570e-4576-8354-01a681ffb98f)

## 구글 로그인
![image](https://github.com/lsh981127/Applepay-search-app-Capstone-Project/assets/83868210/0c315fdb-10d2-48cc-9cec-603d29d4ed2e)

## 커뮤니티
![image](https://github.com/lsh981127/Applepay-search-app-Capstone-Project/assets/83868210/74cc9f83-7f4c-403a-8cd2-7f591313c68a)
![image](https://github.com/lsh981127/Applepay-search-app-Capstone-Project/assets/83868210/8e4beb89-2beb-4f79-b510-e11036732e3c)
<br />
애플페이 가맹점들에 대한 이용후기를 공유할 수 있는 커뮤니티 공간을 제공함 


