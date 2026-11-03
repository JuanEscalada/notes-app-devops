db = db.getSiblingDB("admin");
db.createUser({
  user: "notes_app",
  pwd: "notes_pass",
  roles: [{ role: "readWrite", db: "notes" }],
});
