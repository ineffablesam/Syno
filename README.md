<p align="center">
  <img src="https://i.ibb.co/qBV9ZbV/banner-min.png" alt="Banner-Syno"  height="290"/></p>
  <h1 align="center"><strong>Syno Flutter Summarizer App</strong></h1>
  <div align="center">
    <img src="https://i.ibb.co/QrHCr6T/supabase.png" alt="Syno Logo" width="200"  />
    <img src="https://i.ibb.co/Y01y0fc/flutter-logo.png" alt="Flutter Logo" width="200"/>
  
</div>
<br/>
<p align="center">
  <a href="https://syno.vercel.app/">Syno Demo Website</a>&nbsp;&nbsp;&nbsp;&nbsp;
  <a href="https://drive.google.com/file/d/1N3LdLFyIOFZJ4yzM2aPOWlGFbw7B2w-l/view?usp=sharing">Demo APK Download Link</a>
</p>

<br/>
<br/>

# 👾 Syno - AI Youtube Summarizer

🚀 Introducing **Syno**, the game-changing YouTube summarizer app! ✨ Designed using Flutter and backed by the powerful GPT-3.5-turbo API, Syno is here to transform the way you consume video content. Say goodbye to lengthy videos and hello to concise, accurate summaries that capture the essence of each video. Experience the future of video summarization with Syno🎉

**Built for Supabase's Flutter Hackathon 2023**

## 🛠️ Supercharged with

- Supabase
- Flutter
- Python
- ChatGPT API (GPT-3.5-turbo)

## 💚 Usage of Supabase

By storing the summary version in the Supabase database, we eliminate the need to repetitively fetch the entire summary for a given URL. Instead, we can quickly retrieve the saved version from the database, which significantly reduces processing time and improves the overall performance of our API.

## Short Demo Video 🎥

<a href="https://www.youtube.com/watch?v=fkdKw75G6i4">View Mobile Demo Video</a><br/><br/>
<a href="https://youtu.be/OnuYKlY2e7k">View Web Demo Video</a><br/><br/>
<br/>
## 🛠️ Mobile Demo
[![Watch the video](https://i.ibb.co/BfrqhLF/snap-min.png)](https://www.youtube.com/watch?v=fkdKw75G6i4)
<br/>
## 🛠️ Web Demo
[![Watch the video](https://i.ibb.co/yg15nvH/snap-min-2.png)](https://youtu.be/OnuYKlY2e7k)

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
 uvicorn main:app --reload
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

| Parameter      | Type     | Description                   |
| :------------- | :------- | :---------------------------- |
| `youtube_link` | `string` | **Required** I A youtube link |

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
