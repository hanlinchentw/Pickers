# Pickers

![image](https://github.com/hanlinchentw/Pickers/blob/main/picker%20demo%20gif%26image/Demo2.gif) 

<!-- TABLE OF CONTENTS -->
<details open="open">
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgements">Acknowledgements</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->
## About The Project
Picker使用YELP API 搜尋使用者附近的餐廳，並且以卡片、清單或是地圖的方式呈現，使用者可以選擇或儲存餐廳，餐廳選擇後會呈現在轉盤上，轉盤可以幫助使用者隨機決定幾任餐點。


### Built With

POP (Protocol oriented Programming) / MVVM

網路層以及資料儲存組成：
* [Moya](https://github.com/Moya/Moya)
---  網路層由MOYA組成，MOYA是基於Alamofire的抽象層，使用的目的是為了方便管理不同的Endpoint以及各項功能如base url, method, params, header。
* [Core Data](https://developer.apple.com/documentation/coredata)
--- 使用Core Data 處理餐廳的選擇、儲存等操作，並且加入Observer觀察Entity Change，並更新每一個頁面的資訊。
* [Firebase](https://firebase.google.com)
--- 使用者可以使用email註冊並登入，後台管理使用Firebase/Auth。

其他UI：
* [MBProgressHUD](https://github.com/jdg/MBProgressHUD)
--- Loading data 時使用，簡單方便！
* [imageSlideShow](https://github.com/zvonicek/ImageSlideshow)
--- 可左右滑動的圖片牆，此乃基於Alamofire的套件，可以根據image url載入圖片。
* [LuckyWheel](https://github.com/AhmedNasserSh/iOSLuckyWheel)
--- 使用UIBezierPath刻出的轉盤



<!-- GETTING STARTED -->
## Getting Started

### Installation

1. Clone the repo
   ```sh
   git clone https://github.com/hanlinchentw/Picker.git
   ```
2. Enter pod install in terminal
   ```Swift
   sh
   pod install
   ```
   
<!-- Usage -->
## Usage
1. 主頁呈現 分成卡片與地圖方式呈現
### 卡片 &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&nbsp;地圖
![image](https://github.com/hanlinchentw/Pickers/blob/main/picker%20demo%20gif%26image/LIST.gif) 
![image](https://github.com/hanlinchentw/Pickers/blob/main/picker%20demo%20gif%26image/Map.gif) 

2. . 餐廳選取後可以透過轉盤取出今天的餐點！

![image](https://github.com/hanlinchentw/Pickers/blob/main/picker%20demo%20gif%26image/spin.gif) 

3. 轉盤上的餐廳們可以用儲存起來，下次不用再選一次

![image](https://github.com/hanlinchentw/Pickers/blob/main/picker%20demo%20gif%26image/savedList.gif)

4. 附近沒有的餐廳，也可以使用搜尋功能

![image](https://github.com/hanlinchentw/Pickers/blob/main/picker%20demo%20gif%26image/Search.gif)

5. 儲存最愛的餐廳

![image](https://github.com/hanlinchentw/Pickers/blob/main/picker%20demo%20gif%26image/Favorite.gif)

<!-- CONTACT -->
## Contact

### iOS Developer
陳翰霖 Chen, Han-Lin - [Linkedin](https://www.linkedin.com/in/han-lin-chen-07b635200/) - s3876531@gmail.com
### UI/UX Designer
侯凱馨 Hou, Kai-Hsin - [Linkedin](https://www.linkedin.com/in/han-lin-chen-07b635200/) - 12326casey@gmail.com

Project Link: [Picker](https://github.com/hanlinchentw/Picker)

<!-- ACKNOWLEDGEMENTS -->
## Acknowledgements
* [Yelp fusion](https://www.yelp.com/developers/documentation/v3)
* [Moya](https://github.com/Moya/Moya)
* [LuckyWheel](https://github.com/AhmedNasserSh/iOSLuckyWheel)
* [MBProgressHUD](https://github.com/jdg/MBProgressHUD)
* [imageSlideShow](https://github.com/zvonicek/ImageSlideshow)
