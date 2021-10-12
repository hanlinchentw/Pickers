# Pickers

![image](https://github.com/hanlinchentw/Picker/blob/master/demo.gif) 

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
  Picker主要是幫助使用者決定要吃什麼的app，使用YELP提供的的business search API，搜尋附近的餐廳，呈現給使用者，使用者可以將餐廳加入選單中，至多選擇八家。 想要的餐廳名字會呈現在轉盤上，轉盤是透過UIBezier畫出來的，將餐廳名字旋轉角度後放在轉盤上，按下中心的START鍵後，轉盤就會幫你選出今天的餐點！


### Built With

網路層以及資料儲存組成：
* Moya
* Core Data
* Firebase

其他UI：
* MBProgressHUD
* ImageSlideshow
* LuckyWheel


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
![image](https://github.com/hanlinchentw/Picker/blob/master/main.png) 
![image](https://github.com/hanlinchentw/Picker/blob/master/main_map.png) 

2. 卡片右上角可以選取餐廳，將餐廳加入轉盤中，至多選擇8間餐廳。

![image](https://github.com/hanlinchentw/Picker/blob/master/addRestaurant.png) 

3. 餐廳選取後可以透過轉盤取出今天的餐點！

![image](https://github.com/hanlinchentw/Picker/blob/master/action_result.gif) 

4. 轉盤上的餐廳們可以用儲存起來，下次不用再選一次

![image](https://github.com/hanlinchentw/Picker/blob/master/list.png)

5. 附近沒有的餐廳，也可以使用搜尋功能

![image](https://github.com/hanlinchentw/Picker/blob/master/search.png)
![image](https://github.com/hanlinchentw/Picker/blob/master/search_result.png)

6. 儲存最愛的餐廳

![image](https://github.com/hanlinchentw/Picker/blob/master/favorite.png)

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
