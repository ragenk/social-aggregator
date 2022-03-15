-- Inserting data into the users table
INSERT INTO users (username)
  WITH all_usernames AS (
	SELECT username FROM bad_posts
  UNION
  SELECT username FROM bad_comments
  UNION
  SELECT DISTINCT regexp_split_to_table(upvotes, ',') AS username FROM bad_posts
  UNION
  SELECT DISTINCT regexp_split_to_table(downvotes, ',') AS username FROM bad_posts
  )
  SELECT DISTINCT username
  FROM all_usernames;

-- Inserting data into the topics table
INSERT INTO topics (topic_name)
  SELECT DISTINCT topic FROM bad_posts;

-- Inserting data into the posts table
INSERT INTO posts (title, topic_id, user_id, url, text_content)
  SELECT LEFT(bp.title, 100), t.id, u.id, bp.url, bp.text_content
  FROM bad_posts bp
  JOIN users u
  ON u.username = bp.username
  JOIN topics t
  ON t.topic_name = bp.topic;

-- Inserting data into the comments table
INSERT INTO comments (content, user_id, post_id)
  SELECT bc.text_content, u.id, p.id
  FROM bad_comments bc
  JOIN users u
  ON u.username = bc.username
  JOIN posts p
  ON p.id = bc.post_id;

-- Inserting data into the votes table
-- Upvote
INSERT INTO votes (post_id, user_id, vote)
  WITH upvote AS (
    SELECT id, regexp_split_to_table(upvotes, ',') AS username FROM bad_posts
  )
  SELECT p.id, u.id, 1
  FROM upvote uv
  JOIN users u
  ON u.username = uv.username
  JOIN posts p
  ON p.id = uv.id;

-- Downvote
INSERT INTO votes (post_id, user_id, vote)
  WITH downvote AS (
    SELECT id, regexp_split_to_table(downvotes, ',') AS username FROM bad_posts
  )
  SELECT p.id, u.id, -1
  FROM downvote dv
  JOIN users u
  ON u.username = dv.username
  JOIN posts p
  ON p.id = dv.id;
