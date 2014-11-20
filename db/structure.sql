CREATE TABLE "articles" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "title" varchar(255), "slug" varchar(255), "content" text, "public" boolean, "project_id" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "pictures" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "file_name" varchar(255), "path" varchar(255), "pictureable_id" integer, "pictureable_type" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "projects" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "title" varchar(255), "slug" varchar(255), "content" text, "public" boolean, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20141118211602');

INSERT INTO schema_migrations (version) VALUES ('20141118211627');

INSERT INTO schema_migrations (version) VALUES ('20141118211958');

INSERT INTO schema_migrations (version) VALUES ('20141120032916');

INSERT INTO schema_migrations (version) VALUES ('20141120044053');

