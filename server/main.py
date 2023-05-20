import os
import re
from fastapi import FastAPI
from pydantic import BaseModel
from typing import Optional
import openai
from pytube import YouTube
from dotenv import load_dotenv


load_dotenv()

api_key = os.environ.get('API_KEY')

# Set OpenAI API key
openai.api_key = api_key

# Create FastAPI instance
app = FastAPI()

#[Models--`SummaryRequest` and `SummaryResponse`]
class SummaryRequest(BaseModel):
    youtube_link: str
    not_english: Optional[bool] = False

class SummaryResponse(BaseModel):
    summary: str
#[Routes]
@app.post("/summary/")
async def summarize_youtube_video(request: SummaryRequest):
    youtube_link = request.youtube_link
    print(youtube_link)
    not_english = request.not_english
    mp3_file = youtube_audio_downloader(youtube_link)
    transcript_file = transcribe(mp3_file, not_english)
    summary = summarize(transcript_file)
    os.remove(mp3_file)
    os.remove(transcript_file)
    return SummaryResponse(summary=summary)

#{Functions}
def youtube_audio_downloader(link):
    # Download audio from YouTube video
    yt = YouTube(link)
    audio = yt.streams.filter(only_audio=True).first()
    print('Downloading the audio stream....', end='')
    output_file = audio.download()
    if os.path.exists(output_file):
        print('Done!')
    else:
        print('Error downloading the file!')
        return False
    basename = os.path.basename(output_file)
    name, extension = os.path.splitext(basename)
    audio_file = f'{name}.mp3'
    audio_file = re.sub('Is+', '-', audio_file)
    os.rename(basename, audio_file)
    return audio_file

def transcribe(audio_file, not_english=False):
    # Transcribe audio file using OpenAI's API
    if not os.path.exists(audio_file):
        return False

    if not_english: # TRANSLATION
        print('Not in English so Starting translating into English...', end='')
        with open(audio_file, 'rb') as f:
            transcript = openai.Audio.translate("whisper-1", f)
    else: # TRANSCRIBING
        with open(audio_file, 'rb') as f:
            transcript = openai.Audio.transcribe("whisper-1", f)
    name, extension = os.path.splitext(audio_file)
    transcript_filename = f'transcript-{name}.txt'
    with open(transcript_filename, 'w') as f:
        f.write(transcript['text'])
    return transcript_filename

def summarize(transcript_file):
    # Generate summary of transcript using OpenAI's API
    if not os.path.exists(transcript_file):
        return False
    with open(transcript_file) as f:
        transcript = f.read()
    system_prompt = 'I want you to act as a Life Coach.'
    prompt = f'''Create a summary of the following text and return in properly formatted JSON ,the JSON object should have a 'title', 'summary', 'introduction', 'bullet points', and 'conclusion'. The 'title' key should contain a string that summarizes the article's main idea. The 'summary' key should contain a brief summary of the article. The 'introduction' key should contain a paragraph that provides an overview of the article's content. The 'bullet points' key should contain an array of strings that list the article's key points. The 'conclusion' key should contain a sentence that summarizes the article's main takeaways
    Text: {transcript}
    Add a title to the summary.
    Your summary should be informative and factual, covering the most important aspects of the topic.
    Follow your summary with an INTRODUCTION PARAGRAPH that gives an overview of the topic FOLLOWED by BULLET POINTS if possible AND end the summary with a CONCLUSION PHRASE.'''
    response = openai.ChatCompletion.create(
    model="gpt-3.5-turbo",
    max_tokens=2048,
    temperature=1,
    messages=[
        {"role": "system", "content": system_prompt},
        {"role": "user", "content": prompt}
    ]
    )
    r = response ["choices"][0]["message" ]["content"]
    print(r)
    return r


# uvicorn main:app --reload 