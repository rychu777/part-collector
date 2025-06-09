import os
import json
import firebase_admin
from firebase_admin import credentials, firestore

# Inicjalizacja Firebase
cred = credentials.Certificate("graph-2q2q-firebase-adminsdk-fbsvc-858d6c38c2.json")
firebase_admin.initialize_app(cred)
db = firestore.client()

# Folder z konfiguracjami
folder_path = "configurations"

# Iteracja po wszystkich plikach JSON w folderze
for filename in os.listdir(folder_path):
    if filename.endswith(".json"):
        file_path = os.path.join(folder_path, filename)
        with open(file_path, "r", encoding="utf-8") as f:
            data = json.load(f)

        # Nazwa dokumentu = nazwa pliku bez .json
        doc_name = os.path.splitext(filename)[0]

        # Zapisz do kolekcji "configurations" w Firestore
        doc_ref = db.collection("configurations").document(doc_name)
        doc_ref.set({"components": data})

        print(f"✅ Wgrano: {doc_name}")
