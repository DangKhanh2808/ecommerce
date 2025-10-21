import { initializeApp, cert } from "firebase-admin/app";
import { getFirestore } from "firebase-admin/firestore";
import serviceAccount from "../../../serviceAccountKey.json"; // file tải từ Firebase Console

initializeApp({
  credential: cert(serviceAccount as any),
});

export const firestoreDB = getFirestore();
