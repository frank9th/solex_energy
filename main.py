# The Cloud Functions for Firebase SDK to create Cloud Functions and set up triggers.
from firebase_functions import firestore_fn, https_fn

# The Firebase Admin SDK to access Cloud Firestore.
from firebase_admin import initialize_app, firestore, db 
import google.cloud.firestore
import google.generativeai as genai
from calculator import *
from locker import SecureData
#from google.generativeai import ChatSession
import os
import time as system_time


import datetime




app = initialize_app()





instruct = "You are a SOLEX energy assistance for consumers and energy experts. \nYour task is to analyze, design, calculate energy / system needs by asking users relevant question such as; \"What is your total energy?\", for those who don't know their energy needs, \nYou are to ask them to enter the appliances they want to power such as; Tv, fridge, Ac, etc, then use the information to calculate the energy need. ask them how many hours the system should be on, then calculate for the Ed(Daily Energy), \nsystem voltage, solar panels, battery capacity/ batteries, inverter, charge controller and other relevant components for solar installation. I have provided you with a list of tools for your calculations. proritize all tool especialy the; 'save_new_contact' tool, to send the user's information to support when any user provide their details in a chat. Make necessary adjustment to the tools and only apply them when necessary. Note; 'If a user is a customer, aviod providing technical calculations, do your calculation and summarize for the user the calculated result. If you encounter any error when applying a tool, ignore that tool and error and use any available knowledge to perform such calculations.' \nYou should also provide energy saving techniques where necessary in regards to the specific appliances. For users with high energy consuming appliance, \nYou should recommend an energy saving appliance in place of the high consuming one. if a charge controller calculation result seems too big, and not available in the market, recomend and calculate with a high voltage. \nBegin a conversation by introducing yourself and humbly request the user to identify themself’s as either a consumer, Installer etc. \nKeep the conversation restricted to energy context. If there is nothing else the user wants or have to asked. Request for contact, (email or whatsapp number) but first; ask if they need assistance with the solar installation. if yes, ask for contact and the user's name so we can reach them. tell an installer that we suply quality product for installation as we produce, maintain and distribute all solar products. for user who request our help(contact), tell them to send a WhatsApp mesage to us via meklint support number on. +234 704 135 4452. for a user who starts the conversation without a greeting, continue with the request. only providing summary of your calculations and only provide formulars on when requested. avaoid displaying calculations as much as possible most especialy when chating with a customer, always ask for location to get the aqurate PSH of the user and also provide the battery sizing i.e number of batteries for the required system voltage. keep your respose at 150 words max and keep it interactive with the user. Always make a bold list for the main solar componets calculated for."



generation_config = {
  "temperature": 0.94,
  "top_p": 0.96,
  "top_k": 64,
  "max_output_tokens": 2048,
  "response_mime_type": "text/plain",

}

def save_new_contact(email:str = '', phone:str = '', name:str='', content:str=''):
    """send the user's contact so they can be reached together with the summary of the conversation.
            Args:
                email: user's provided emaail if any .
                phone: user's phone number in international starndard. 
                name: user's provided name. 
                content: summary of the user's needs as discussed. include any relevant information based on the chat history. 
    """
    try:
        ref = db.reference('contact/')
        # Get all child references under the current path
        if email != '' or phone != '':
            children_refs = ref.get()
            if children_refs is not None:
                # Check if data exists based on the "name" field
                for child_ref, child_data in children_refs.items():
                    if child_data.get('phone') == phone or child_ref.get('email') == email:
                        ref.child(child_ref).update({'content':content})
                     
                    return
            # No existing data found, save with push
            push_ref = ref.push()
            data = {'email':email, 'phone':phone, 'name':name, 'content':content}
            push_ref.set(data)
    except Exception as e:
        pass
      
      
  

def start_chat(user_message, history):
    key = os.environ.get('GOOGLE_GEM_KEY')
    genai.configure(api_key=key)
    tools = {
    "save_new_contact":save_new_contact,
    "calculate_Total_Power": calculate_Total_Power,
    "dailyEnergy": dailyEnergy,
    "calculate_system_voltage": calculate_system_voltage,
    "calculate_Battery_capacity":calculate_Battery_capacity,
    "calculate_batery_Size":calculate_batery_Size,
    "calculatePConnet":calculatePConnet,
    "calculateSconnet":calculateSconnet,
    "calculatePvModelPW":calculatePvModelPW,
    "calculatePvNumbers":calculatePvNumbers,
    "calculateChargeControl":calculateChargeControl,
    "calculateInverter":calculateInverter,
    "calculate_pv_parale_connection":calculate_pv_parale_connection,
    "calculatePvSconnet":calculatePvSconnet
    }

    gemini_client = genai.GenerativeModel(
      model_name="gemini-1.5-pro",
      generation_config=generation_config,
      # safety_settings = Adjust safety settings
      # See https://ai.google.dev/gemini-api/docs/safety-settings
      tools=tools.values(),
      system_instruction=instruct,

    )
    chat =gemini_client.start_chat(history=history,enable_automatic_function_calling=True)
    #ChatSession(history=history, enable_automatic_function_calling=True, model=gemini_client)
    response = chat.send_message(user_message)
    return chat, response



@firestore_fn.on_document_written(document="chats/{deviceId}/{messageCollectionId}/{messageId}")
def makeairesponse(event: firestore_fn.Event[firestore_fn.DocumentSnapshot | None]) -> None:
    t = datetime.datetime.now()
    d = datetime.datetime.now()
    time = t.strftime("%X")
    date = d.strftime('%Y-%m-%d')

    deviceId = event.params["deviceId"]
    messageCollection = event.params["messageCollectionId"]
    chunks = []
    text_chunks = []
    image_chunks = []
    full_ai_response = ""
    chat_history = []
    history_bank = []
    if event.data is None:
        return
    try:
        value = event.data.after
        if value is None:
            return 
        data = value.to_dict()
        original = data['user']
    except KeyError:
        # No "original" field, so do nothing.
        return

    new_value = event.data.after.to_dict()
    if 'Ai' in new_value.keys():
        return
      # append new history data 
    history_bank.append({'role': 'user', 'parts': original, 'date': date, 'time': time})
    upper = original.upper()
    #// write response here 


          
    hist = get_chat_history(deviceId, messageCollection)
    chat, response = start_chat(original, history=hist)

    rawData = {
    'deviceId':deviceId,
    'messageCollection':messageCollection,
    'history':hist, 
    'text':original
    }

    try:

        for chunk in response:  # Assuming response has parts
            if chunk.text:
                chunks.append(chunk.text.encode('utf-8').decode('utf-8')) 
                ai_response_chunk = '\n'.join(chunks)
                full_ai_response += ai_response_chunk
                value.reference.update({"Ai": ai_response_chunk})
                system_time.sleep(0.1)
            else:
                # Handle non-text parts or missing text property
                print(f"Skipping non-text chunk: {chunk}")
    except Exception as e:
        pass
        # Handle the case where the response doesn't contain any parts
        print(f"Error: in response {e}")

    history_bank.append({'role':'model', 'parts':full_ai_response})


    update_chat_history(deviceId, messageCollection, history_bank)
    return 



def get_chat_history(collect_id, section_id):
    history = []
    try:
        ref = db.reference(f'chat_history/{collect_id}')
        data = ref.child(f'{section_id}').get()
        if not data:
            pass 
        else:
            try:
                for a in data:
                    try:
                        manual_history = {"role": f"{a['role']}","parts": [f"{a['parts']}",],}
                        history.append(manual_history)
                    except Exception as e:
                        pass
            except Exception as e:
                pass
    except Exception as e:
        pass
    return history


    
def update_chat_history(chat_id, chat_section_id, chat_history):
    ref = db.reference(f'chat_history/{chat_id}/{chat_section_id}')
    existing_list = ref.get()
    # create empty list if no data 
    if existing_list is None:
        existing_list = []

    # Append new data items to list 
    existing_list.extend(chat_history)
    ref.set(existing_list)
    '''
    for item in chat_history:
        ref.push(item)
    '''




