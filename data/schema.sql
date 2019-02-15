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

INSERT INTO projects (name, yarn, colors, weight, making_for, pattern, pattern_link, hook, date_added, project_status, notes) VALUES ('Blanket', 'Loops and Threads', 'blue, green', ' Worsted 8', 'Jaron', 'Head:
with rose color yarn
Magic Ring, chain 1 and make 10 SC in ring, join to first SC, chain 1
Round 2: 2 SC in each stitch around, join, chain 1 (20 SC)
Round 3: SC in each stitch around, join, chain 1 (20 SC)
Round 4: 2 SC in first stitch, SC in next, repeat around, join, chain 1 (30 SC)
Round 5: 2 SC in first stitch, SC in next 2, repeat around, join, chain 1 (40 SC)
Round 6: 2 SC in first stitch, SC in next 3, repeat around, join, chain 1 (50 SC)
Round 7: SC in each stitch around, join, chain 1 (50 SC)
Round 8: 2 SC in first stitch, SC in next 4, repeat around, join, chain 1 (60 SC)
Round 9-25: SC in each stitch aroumd, join, chain 1 (60 SC)
Round 26: SC Decrease, SC in next 4, repeat around, join, chain 1 (50 SC)
Round 27: SC in each stitch around, join, chain 1 (50 SC)
Round 28: SC Decrease, SC in next 3, repeat around, join, chain 1 (40 SC)
Round 29: SC in each stitch around, join, chain 1 (40 SC)
Round 30: SC Decrease, SC in next 2, repeat around, join, chain1 (30 SC)
Round 31: SC in each stitch around, join, chain 1 (30 SC)
Round 32: SC Decrease, SC in next, repeat around, join, chain 1 (20 SC)
Round 33: SC in each stitch around, join (20 SC)
Fasten off leaving long tail.
Stuff with polyfil and leave top open. Sew head onto body.', 'http://www.repeatcrafterme.com/2019/01/big-bernat-velvet-crochet-bear.html', '5.5mm', CURRENT_TIMESTAMP, 'Not Started', 'This is a test');