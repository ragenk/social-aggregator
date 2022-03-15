# social-aggregator
SQL Nanodegree Program Project

## **Project Introduction: Udiddit, A Social News Aggregator**

Udiddit is a social news aggregator, content rating, and discussions website. On Udiddit, registered users are able to link to external content or post their own text content about various topics, ranging from common topics such as photography and food, to more arcane ones such as horse masks or birds with arms. In turn, other users can comment on these posts, and each user is allowed to cast a vote about each post, either in an up (like) or down (dislike) direction.

Unfortunately, due to some time constraints before the initial launch of the site, the data model stored in Postgres hasn’t been well thought out, and is starting to show its flaws. You’ve been brought in for two reasons: first, to make an assessment of the situation and take steps to fix all the issues with the current data model, and then, once successful, to improve the current system by making it more robust and adding some web analytics.

## **Instructions**

All your tasks are outlined in a single Google Docs document [here](https://docs.google.com/document/d/1eQ3jsuU55Vyu6iuKpIqqR0_cC8spVNwM-wyqwtLcGgQ/copy), *which you should make a copy from (do not request access)*. A Word version of this template has also been attached at the bottom of this page. To complete the project, you’ll have to make your own copy of this document to document your findings and steps. This document will constitute your final submission for the project.

You need to complete the following in the template:

- Part I: Investigate the existing schema
- Part II: Create the DDL for your new schema
- Part III: Migrate the provided data

## Part I: Investigate the existing schema

As a first step, investigate this schema and some of the sample data in the project’s SQL workspace. Then, in your own words, outline three (3) specific things that could be improved about this schema. Don’t hesitate to outline more if you want to stand out!

## Part II: Create the DDL for your new schema

Having done this initial investigation and assessment, your next goal is to dive deep into the heart of the problem and create a new schema for Udiddit. Your new schema should at least reflect fixes to the shortcomings you pointed to in the previous exercise. To help you create the new schema, a few guidelines are provided to you:

1. Guideline #1: here is a list of features and specifications that Udiddit needs in order to support its website and administrative interface:  
    **a.** Allow new users to register:  
        i. Each username has to be unique  
        ii. Usernames can be composed of at most 25 characters  
        iii. Usernames can’t be empty  
        iv. We won’t worry about user passwords for this project  
    **b.** Allow registered users to create new topics:  
        i. Topic names have to be unique.  
        ii. The topic’s name is at most 30 characters  
        iii. The topic’s name can’t be empty  
        iv. Topics can have an optional description of at most 500 characters.  
    **c.** Allow registered users to create new posts on existing topics:  
        i. Posts have a required title of at most 100 characters  
        ii. The title of a post can’t be empty.  
        iii. Posts should contain either a URL or a text content, **but not both**.  
        iv. If a topic gets deleted, all the posts associated with it should be automatically deleted too.  
        v. If the user who created the post gets deleted, then the post will remain, but it will become dissociated from that user.  
    **d.** Allow registered users to comment on existing posts:  
        i. A comment’s text content can’t be empty.  
        ii. Contrary to the current linear comments, the new structure should allow comment threads at arbitrary levels.  
        iii. If a post gets deleted, all comments associated with it should be automatically deleted too.  
        iv. If the user who created the comment gets deleted, then the comment will remain, but it will become dissociated from that user.  
        v. If a comment gets deleted, then all its descendants in the thread structure should be automatically deleted too.  
    **e.** Make sure that a given user can only vote once on a given post:  
        i. Hint: you can store the (up/down) value of the vote as the values 1 and -1 respectively.  
        ii. If the user who cast a vote gets deleted, then all their votes will remain, but will become dissociated from the user.  
        iii. If a post gets deleted, then all the votes for that post should be automatically deleted too. 
        
2. Guideline #2: here is a list of queries that Udiddit needs in order to support its website and administrative interface. Note that you don’t need to produce the DQL for those queries: they are only provided to guide the design of your new database schema.  
    a. List all users who haven’t logged in in the last year.  
    b. List all users who haven’t created any post.  
    c. Find a user by their username.  
    d. List all topics that don’t have any posts.  
    e. Find a topic by its name.  
    f. List the latest 20 posts for a given topic.  
    g. List the latest 20 posts made by a given user.  
    h. Find all posts that link to a specific URL, for moderation purposes.  
    i. List all the top-level comments (those that don’t have a parent comment) for a given post.  
    j. List all the direct children of a parent comment.  
    k. List the latest 20 comments made by a given user.  
    l. Compute the score of a post, defined as the difference between the number of upvotes and the number of downvotes  
    
3. Guideline #3: you’ll need to use normalization, various constraints, as well as indexes in your new database schema. You should use named constraints and indexes to make your schema cleaner.  

4. Guideline #4: your new database schema will be composed of five (5) tables that should have an auto-incrementing id as their primary key.
