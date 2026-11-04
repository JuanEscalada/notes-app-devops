const adminDb = db.getSiblingDB("admin");

const username = process.env.MONGO_APP_USERNAME;
const password = process.env.MONGO_APP_PASSWORD;

if (!username || !password) {
  throw new Error("Faltan credenciales del usuario de aplicación");
}

adminDb.createUser({
  user: username,
  pwd: password,
  roles: [
    { role: "readWrite", db: "notes" }
  ]
});