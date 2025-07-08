#Social media Analytics

Create database Social_media_db ; 
Use Social_media_db ; 

Create table users (
User_id int primary key,
Username varchar(50),
First_name varchar(50),
email varchar(100),
join_date date,
country varchar(20)
);

Select * from users ; 

Create table posts(
Post_id int primary key,
User_id int,
Content varchar(200),
Location varchar(50),
foreign key (user_id) references users(user_id)
);


drop table posts ; 

Select * from posts ; 

Create table likes (
like_id int primary key,
user_id int,
post_id int,
liked_at date,
foreign key (user_id) references users(user_id),
foreign key (post_id) references posts(post_id)
);

Select * from likes ; 

Create table comments (
Comment_id int primary key,
Post_id int,
User_id int,
Comments varchar(200),
Commented_at date,
foreign key (post_id) references posts(post_id),
foreign key (user_id) references users(user_id)
);

Select * from comments ; 

Create table followers (
follower_id int primary key,
User_id int,
following_id int,
followed_at date,
foreign key (user_id) references users(user_id)
);


drop table followers ; 


Select * from followers ; 


Create table hastags (
hastags_id int primary key,
hastags varchar(50)
);

Drop table hastags; 

Select * from hastags ; 

# Which post has received the most likes?

SELECT 
    posts.post_id, COUNT(like_id) AS total_likes
FROM
    posts
        JOIN
    likes ON likes.post_id = posts.post_id
GROUP BY posts.post_id
ORDER BY total_likes DESC
LIMIT 1; 

# Which users have posted the most content?
SELECT 
    users.username, COUNT(post_id) AS total_post
FROM
    users
        JOIN
    posts ON users.user_id = posts.user_id
GROUP BY users.Username
ORDER BY total_post DESC;

# Find the top 5 most active commenters.
SELECT 
    users.username, COUNT(comment_id) AS total_comments
FROM
    users
        JOIN
    comments ON users.user_id = comments.user_id
GROUP BY users.username
ORDER BY total_comments DESC
LIMIT 5;
 
 
 #Which user posted a specific post (e.g., post_id = 21)?
 
SELECT 
    users.username, content, posts.post_id
FROM
    users
        JOIN
    posts ON users.user_id = posts.user_id
WHERE
    post_id = 21; 
    
# Get the number of likes and comments each post has.

SELECT 
    posts.post_id,
    COUNT(comments.Comment_id) AS total_comments,
    COUNT(likes.like_id) AS total_likes
FROM
    posts
        JOIN
    likes ON posts.Post_id = like_id
        JOIN
    comments ON posts.post_id = comments.post_id
GROUP BY posts.Post_id
ORDER BY total_comments , total_likes DESC; 

# Top 10 users with the most followers

Select Users.username , count( followers.follower_id ) as highest_followers from users
join followers 
on followers.user_id = users.user_id 
group by users.username
order by highest_followers desc 
limit 10 ; 

# Find users who have never received any likes on any of their posts.

SELECT 
    users.username, users.user_id
FROM
    users
        JOIN
    likes ON likes.user_id = users.user_id
GROUP BY users.username , users.user_id
HAVING COUNT(likes.like_id) = 0;

# List users who follow more than 50 people.
SELECT 
    users.username, COUNT(following_id) AS following_count
FROM
    users
        JOIN
    followers ON users.user_id = followers.user_id
GROUP BY users.username
HAVING following_count > 50; 

# We create a view with the above tables.
CREATE VIEW view_post_likes AS
    SELECT 
        users.username,
        users.email,
        posts.post_id,
        posts.content,
        COUNT(likes.like_id)
    FROM
        users
            JOIN
        posts ON users.user_id = posts.user_id
            JOIN
        likes ON posts.post_id = likes.post_id
    GROUP BY users.username , users.email , posts.post_id , posts.content; 

Select  * from view_post_likes ; 

# Who are the top 5 most active users (based on combined posts + comments)?

SELECT 
    users.username,
    COUNT(posts.post_id) AS total_posts,
    COUNT(comments.comment_id) AS total_comments
FROM
    users
        JOIN
    posts ON users.user_id = posts.user_id
        JOIN
    comments ON posts.post_id = comments.post_id
GROUP BY users.username
LIMIT 5;

# find the average number of comments per post per user.


SELECT users.user_id, AVG(total_comments.comment_count) AS avg_comment_count
FROM (
    SELECT users.user_id, posts.post_id, COUNT(comments.comment_id) AS comment_count
    FROM users
    JOIN posts ON posts.user_id = users.user_id
    JOIN comments ON posts.post_id = comments.post_id
    GROUP BY users.user_id, posts.post_id
) AS total_comments
JOIN users ON users.user_id = total_comments.user_id
GROUP BY users.user_id;


# Which user follows the most people?

SELECT 
    Users.username, COUNT(following_id)
FROM
    users
        JOIN
    followers ON users.user_id = followers.user_id
GROUP BY users.username; 


#Who received the most comments on their posts?

SELECT 
    posts.user_id, COUNT(comments.comment_id) AS total_comments
FROM
    posts
        JOIN
    comments ON posts.post_id = comments.post_id
GROUP BY posts.user_id
ORDER BY total_comments DESC
LIMIT 10;

 # What is the average number of likes per user?
 
SELECT 
    users.username, AVG(likes.like_id) AS avg_likes
FROM
    users
        JOIN
    likes ON users.user_id = likes.user_id
GROUP BY users.username; 
 
 







