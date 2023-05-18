
![Logo](https://i.ibb.co/qBV9ZbV/banner-min.png)



# 👾 Syno - AI Youtube Summarizer

🚀 Introducing **Syno**, the game-changing YouTube summarizer app! ✨ Designed using Flutter and backed by the powerful GPT-3.5-turbo API, Syno is here to transform the way you consume video content. Say goodbye to lengthy videos and hello to concise, accurate summaries that capture the essence of each video. Experience the future of video summarization with Syno🎉


**Built for Supabase's Flutter Hackathon 2023**

<div align="left">
    <img src="https://i.ibb.co/QrHCr6T/supabase.png" alt="Syno Logo" width="200"  />
    <img src="https://i.ibb.co/Y01y0fc/flutter-logo.png" alt="Flutter Logo" width="200"/>
</div>

## 🛠️ Supercharged with 

- Supabase
- Flutter 
- Python
- ChatGPT API (GPT-3.5-turbo)

## 🛠️ Illustration

![Image](https://i.ibb.co/Bjcw0Lj/iphone-14-4-646683cdcc9e58a2416b6134.png)

![Image](https://i.ibb.co/Ph6bpZx/frame.png)


## How to setup **Syno** backend ?

1. Clone the repo

```bash
 git clone https://github.com/ineffablesam/Syno
```

2. First need to install the python dependencies prior running the server  

```bash
 cd server
```

```bash
 pip install -r requirements.txt
```

3. To run the server go to **server/** folder and then run

```bash
 python main.py
```

## How to setup **Syno** Flutter app ?

1. Install [Flutter](https://flutter.dev/docs/get-started/install) for your platform.
2. Clone this repository or download the source code.
3. Open a terminal window and navigate to the project directory.
4. Run `flutter pub get` to install dependencies.
5. Connect a device or emulator.
6. Run `flutter run` to start the app.

## Roadmap

- Refactor the whole Codebase 😅

- Add Supabase magic login

   ...




## API Reference

#### Get all items

```http
  POST /summary/
```
Json **POST** Body

| Parameter | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `youtube_link` | `string` | **Required** I  A youtube link |

#### JSON Body Example

```http
  {
    "youtube_link": "https://www.youtube.com/watch?v=QpBTM0GO6xI"
  }
```


Takes youtube link as paramater and returns the summary.

#### Response Example

```http
{
    "title": "string",
    "summary": "string",
    "introduction": "string",
    "bullet points": [
        "string",
        "string",
        "string",
        "string"
    ],
    "conclusion": "string"
}

```
## 🧑🏻‍💻 Team
 - [Samuel Philip](https://github.com/ineffablesam)



## 🔗 Social Links 
 - [Twitter](https://twitter.com/samuelP09301972)
 - [Instagram](https://www.instagram.com/ig_samuelsam/)
 - [Github](https://github.com/ineffablesam/)


