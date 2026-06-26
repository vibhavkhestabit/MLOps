import os
import azure.cognitiveservices.speech as speechsdk

speech_key = os.getenv("SPEECH_KEY")
speech_region = os.getenv("SPEECH_REGION")

speech_config = speechsdk.SpeechConfig(
    subscription=speech_key,
    region=speech_region
)

audio_config = speechsdk.audio.AudioConfig(
    filename="data/sample-audio.wav"
)

recognizer = speechsdk.SpeechRecognizer(
    speech_config=speech_config,
    audio_config=audio_config
)

print("Transcribing...")

result = recognizer.recognize_once()

if result.reason == speechsdk.ResultReason.RecognizedSpeech:
    print("\n===== TRANSCRIPT =====\n")
    print(result.text)

elif result.reason == speechsdk.ResultReason.NoMatch:
    print("No speech recognized.")

elif result.reason == speechsdk.ResultReason.Canceled:
    details = result.cancellation_details
    print("Cancelled:", details.reason)
    print("Error:", details.error_details)