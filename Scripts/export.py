import json
import uuid
import firebase_admin
from firebase_admin import credentials, firestore

# 🔑 Inicjalizacja Firestore
cred = credentials.Certificate("graph-2q2q-firebase-adminsdk-fbsvc-cf2500d5d7.json")
firebase_admin.initialize_app(cred)
db = firestore.client()

# 📄 Wczytaj komponenty z pliku JSON
with open("components.json", "r", encoding="utf-8") as file:
    components = json.load(file)

# 🚀 Wyślij każdy komponent do Firestore z UUID jako ID dokumentu
for component in components:
    doc_id = str(uuid.uuid4())
    doc_ref = db.collection("components.json").document(doc_id)
    doc_ref.set(component)
    print(f"✅ Uploaded: {component['name']} (ID: {doc_id})")