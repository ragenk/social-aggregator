-- Allow new users to register
CREATE TABLE users ( 
  id SERIAL PRIMARY KEY,
  username VARCHAR(25) NOT NULL, -- Usernames can be composed of at most 25 characters
  login TIMESTAMP,
  CONSTRAINT username_not_empty CHECK (LENGTH(TRIM(username )) > 0) -- Usernames cant be empty
);
CREATE UNIQUE INDEX unique_user ON users (LOWER(username)); -- Each username has to be unique
CREATE INDEX last_login ON users(login); -- Login index

-- Allow registered users to create new topics
CREATE TABLE topics ( 
  id SERIAL PRIMARY KEY,
  topic_name VARCHAR(30) UNIQUE NOT NULL, -- The topics name is at most 30 characters, have to be unique
  description VARCHAR(500), -- Topics can have an optional description of at most 500 characters
  CONSTRAINT topic_not_empty CHECK (LENGTH(TRIM(topic_name)) > 0) -- The topics name cant be empty
);
CREATE INDEX topic_index ON topics (topic_name VARCHAR_PATTERN_OPS); -- Find a topic by its name

-- Allow registered users to create new posts on existing topics
CREATE TABLE posts ( 
  id SERIAL PRIMARY KEY,
  title VARCHAR(100) NOT NULL, -- Posts have a required title of at most 100 characters
  url VARCHAR(2000) DEFAULT NULL,
  text_content text DEFAULT NULL,
  topic_id INT REFERENCES topics(id) ON DELETE CASCADE NOT NULL, -- If a topic gets deleted, cascade
  user_id INT REFERENCES users(id) ON DELETE SET NULL, -- If a user gets deleted, null
  post_date TIMESTAMP,
  CONSTRAINT url_or_text CHECK ((url IS NULL AND text_content IS NOT NULL) OR (url IS NOT NULL AND text_content IS NULL)),  -- Posts should contain either a URL or a text content, **but not both**
  CONSTRAINT title_not_empty CHECK (LENGTH(TRIM(title)) > 0) -- The title of a post cant be empty.
);
CREATE INDEX post_creator ON posts(user_id); -- Posts by a given user
CREATE INDEX latest_post ON posts(post_date); -- Posts by date
CREATE INDEX post_by_topic ON posts(topic_id); -- Posts by topic

-- Allow registered users to comment on existing posts:
-- Contrary to the current linear comments, the new structure should allow comment threads at arbitrary levels.
CREATE TABLE comments (
  id SERIAL PRIMARY KEY,
  content TEXT NOT NULL,
  user_id INT REFERENCES users(id) ON DELETE SET NULL, -- If the user who created the comment gets deleted, null.
  post_id INT REFERENCES posts(id) ON DELETE CASCADE NOT NULL, -- If a post gets deleted, cascade.  
  parent_comment_id INT REFERENCES comments(id) ON DELETE CASCADE, -- If a comment gets deleted, cascade thread, this field can contain NULL values.
  CONSTRAINT comment_not_empty CHECK (LENGTH(TRIM(content)) > 0) -- A comments text content cant be empty.
);
CREATE INDEX parent_comments ON comments(id) WHERE parent_comment_id = NULL; -- top-level comments
CREATE INDEX children_comments ON comments(parent_comment_id); -- direct children of a parent comment
CREATE INDEX comments_by_user ON comments(user_id); -- comments made by a given user

-- Votes
CREATE TABLE votes (
  id SERIAL PRIMARY KEY,
  post_id INT REFERENCES posts(id) ON DELETE CASCADE NOT NULL, -- If a post gets deleted, cascade.
  user_id INT REFERENCES posts(id) ON DELETE SET NULL, -- If the user who cast a vote gets deleted, null.
  vote INT CHECK (vote = 1 OR vote = -1),
  UNIQUE (post_id, user_id) -- Make sure that a given user can only vote once on a given post
);
CREATE INDEX score ON votes(vote); -- Score of a post