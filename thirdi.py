import RPi.GPIO as GPIO
from time import sleep
import requests
import json
import picamera
from cloudinary import config
from cloudinary.uploader import upload
from gtts import gTTS
import subprocess

config(
  cloud_name = 'shannu',  
  api_key = '224535388936753',  
  api_secret = 'srOQhLEPtsWX4fMFbZ-oAKJWdxY'  
)

GPIO.setmode(GPIO.BCM)

GPIO.setup(23, GPIO.IN, pull_up_down = GPIO.PUD_UP)
GPIO.setup(24, GPIO.IN, pull_up_down = GPIO.PUD_UP)
GPIO.setup(25, GPIO.IN, pull_up_down = GPIO.PUD_UP)

def upload_files():
    print("--- Upload a local file")
    response = upload("image.jpg")
    url = response['url']
    print(url)
    return(url)

def speak(txt):
    tts = gTTS(txt)
    tts.save("hello.mp3")
    subprocess.Popen(['omxplayer','-o','hdmi','hello.mp3']).wait()
    
def obj_det():
    speak("Object Detection Activated")
    print("Object Detection Activated")
    cam = picamera.PiCamera()
    cam.capture('image.jpg')
    cam.close()
    img = upload_files()
    # img = "http://res.cloudinary.com/shannu/image/upload/v1555585593/bsyzetny3jogxocidp9p.png"
    img = "https://res.cloudinary.com/shannu/image/upload/v1555610950/index_i2uyed.jpg"
    headers = { 'Ocp-Apim-Subscription-Key' : 'fe26d0c41aa2482d915b690f7ce9a666' }
    api_url = 'https://westcentralus.api.cognitive.microsoft.com/vision/v2.0/describe?maxCandidates=1'
    response= requests.post(api_url,headers=headers,json={'url': img})
    res=response.json()
    print(res['description']['captions'][0]['text'])
    speak(res['description']['captions'][0]['text'])
    
def detect_faces(url):
    headers = { 'Ocp-Apim-Subscription-Key' : 'f5818a00bc3642938c75504f930b0bf1' }
    params = {
            'returnFaceId':'true',
            'returnFaceLandmarks':'false',
            'returnFaceAttributes':'age,gender',
    }
    face_api_url = 'https://westcentralus.api.cognitive.microsoft.com/face/v1.0/detect'
    image_url = url
    response= requests.post(face_api_url,params=params,headers=headers,json={'url':image_url})
    faces=response.json()
    if(len(faces)>0):
        retlist=[]
        id=faces[0]['faceId']
        att = faces[0]['faceAttributes']
        retlist.append(id)
        retlist.append(att)
        return(retlist)
    else:
        print('Please retake image.')
        speak('plese retake image')
        return('no id')

def verify_faces(id1,id2):
    headers = { 'Ocp-Apim-Subscription-Key' : 'f5818a00bc3642938c75504f930b0bf1' }
    face_api_url = 'https://westcentralus.api.cognitive.microsoft.com/face/v1.0/verify'
    response= requests.post(face_api_url,headers=headers,json={'faceId1':id1,'faceId2':id2})
    res=response.json()
    if(res['isIdentical']==True):
        return(True)
    else:
        return(False)

def kyf():
    speak("Know Your Friend Activated")
    print("Know Your Friend Activated")
    cam = picamera.PiCamera()
    cam.capture("image.jpg")
    cam.close()
    img = upload_files()
    friends= { 'anuroop': 'http://res.cloudinary.com/shannu/image/upload/v1533544913/WIN_20180806_14_11_01_Pro_gqqeec.jpg', 'pragnya': 'http://res.cloudinary.com/shannu/image/upload/v1533544769/WIN_20180806_14_08_25_Pro_qvfjmb.jpg'}
    img = 'http://res.cloudinary.com/shannu/image/upload/v1533624870/WIN_20180807_12_24_06_Pro_j1trjd.jpg'
    #img = 'http://res.cloudinary.com/shannu/image/upload/v1533624859/WIN_20180807_12_23_25_Pro_pabetq.jpg'
    new_face=detect_faces(img)
    if(len(new_face)!=0):
        id2=new_face[0]
        print("The person is a " + str(new_face[1]['age']) + " year old " + new_face[1]['gender'])
        speak("The person is a " + str(new_face[1]['age']) + " year old " + new_face[1]['gender'])
        c=0
        for key in friends:
            print('Checking your friends...')
            speak('Checking your friends database for resembelance')
            face=detect_faces(friends[key])
            id1=face[0]
            if(verify_faces(id1,id2) == True):
                print('It is your friend ' + key)
                speak('It is your friend ' + key)
                c+=1
                break

        if(c==0):
            print("Unknown person")
            speak("Unknown person")

def img2txt():
    speak("Image to Text Activated")
    print("Image to Text Activated")
    cam = picamera.PiCamera()
    cam.capture("image.jpg")
    cam.close()
    img = upload_files()
    # img = "http://res.cloudinary.com/shannu/image/upload/v1533627380/WIN_20180807_13_05_44_Pro_wyxa09.jpg"
    # img = "https://img.tesco.com/Groceries/pi/165/5031021741165/IDShot_540x540.jpg"
    img="https://res.cloudinary.com/shannu/image/upload/v1556694093/p_2_iodyts.jpg"
    headers = {'Ocp-Apim-Subscription-Key': "fe26d0c41aa2482d915b690f7ce9a666"}
    params  = {'mode': 'Handwritten'}
    data    = {'url': img}
    response = requests.post("https://westcentralus.api.cognitive.microsoft.com/vision/v2.0/recognizeText", headers=headers, params=params, json=data)
    response.raise_for_status()
    operation_url = response.headers["Operation-Location"]
    analysis = {}
    while "recognitionResult" not in analysis:
        response_final = requests.get(
            response.headers["Operation-Location"], headers=headers)
        analysis = response_final.json()
        print(analysis['recognitionResult']['lines'][0]['text'])
        speak(analysis['recognitionResult']['lines'][0]['text'])
        sleep(1)


while(True):
    btn1 = GPIO.input(23)
    btn2 = GPIO.input(24)
    btn3 = GPIO.input(25)
    if(btn1==False):
        obj_det()
    elif(btn2==False):
        kyf()
    elif(btn3==False):
        img2txt()
    else:
        print("Device Idle")
        sleep(5)