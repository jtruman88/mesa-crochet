CREATE TABLE projects (
  id serial PRIMARY KEY,
  name text NOT NULL,
  yarn text NOT NULL,
  colors text NOT NULL,
  weight text,
  making_for text NOT NULL,
  pattern text,
  pattern_link text,
  hook text,
  image text,
  date_added timestamp DEFAULT CURRENT_TIMESTAMP,
  project_status text NOT NULL,
  notes text
);