SELECT id, comment_text,user_id,photo_id,created_at, COUNT(*) AS count_duplicates 
FROM comments
GROUP BY id, comment_text,user_id,photo_id,created_at
HAVING COUNT(*) > 1

SELECT *
FROM comments
WHERE id IS NULL
   OR comment_text IS NULL
   OR user_id IS NULL
   OR photo_id IS NULL
   OR created_at IS NULL
   
SELECT follower_id, followee_id,created_at, count(*) as duplicate_count
from follows
group by follower_id, followee_id,created_at
having count(*) > 1;

SELECT * FROM follows
where follower_id is null
or followee_id is null
or created_at is null

SELECT user_id, photo_id,created_at, count(*) as duplicate_count
from likes
group by user_id, photo_id,created_at
having count(*) > 1

select * from likes 
where user_id is null
or photo_id is null
or created_at is null

select photo_id, tag_id, count(*) as duplicate_count
from photo_tags
group by photo_id, tag_id
having count(*) > 1

select * from photo_tags
where photo_id is null
      OR tag_id is null

select id,image_url,user_id,created_dat, count(*) as duplicate_count
from photos
group by id,image_url,user_id,created_dat
having count(*) > 1

select * from photos
where id is null
or image_url is null
or user_id is null
or created_dat is null

select id, tag_name, created_at,count(*) as duplicate_count
from tags
group by id, tag_name, created_at
having count(*) > 1

select * from tags
where id is null
or tag_name is null
or created_at is null 

select id, username, created_at, count(*) as  duplicate_count
from users
group by id, username, created_at
having count(*) > 1 

SELECT * FROM users 
where id is null
or username is null
or created_at is null


WITH n_posts_count as (
SELECT user_id, count(*) as post_count
from photos
group by user_id
)
SELECT COALESCE(post_count,0) as post_count,
	   COUNT(*) AS n_of_users
       from users u
       left join n_posts_count npc
       on u.id = npc.user_id
       group by COALESCE(post_count,0)
       order by post_count

              
WITH N_OF_LIKES AS (SELECT user_id , count(*) as no_of_likes
from likes 
group by user_id
)
SELECT COALESCE(no_of_likes,0) as Number_of_likes,
       COUNT(*) as no_of_users
       from users u
       left join N_OF_LIKES NOL
       on u.id = NOL.user_id
       GROUP BY COALESCE(no_of_likes,0)
       ORDER BY Number_of_likes
       
WITH comment_counts AS (
    SELECT user_id, COUNT(*) AS comment_count
    FROM comments
    GROUP BY user_id
) 
SELECT
    COALESCE(comment_count, 0) AS comment_count,
    COUNT(*) AS user_count
FROM users u
LEFT JOIN comment_counts c
    ON u.id = c.user_id
GROUP BY COALESCE(comment_count, 0)

WITH Tag_Counts as ( 
SELECT p.id as photo_id, 
       count(pt.tag_id) as C_OF_Tag 
	from photos p
    LEFT join photo_tags pt
    on p.id = pt.photo_id 
    group by p.id 
    )
SELECT AVG(C_OF_Tag) avg_tags_per_post
from Tag_Counts


WITH n_of_likes as (
SELECT photo_id, count(*) as n_of_like
from likes
group by photo_id
),
n_of_comments as (
SELECT photo_id, count(*) as n_of_comment
from comments
group by photo_id
),
photo_engagements as (
SELECT p.user_id,
       p.id,
       COALESCE(l.n_of_like,0) as n_of_like,
       COALESCE(c.n_of_comment,0) as n_of_comment,
       COALESCE(l.n_of_like,0) + COALESCE(c.n_of_comment,0)
       as engagement_score
       from photos p
       left join n_of_likes l 
       on p.id = l.photo_id
       left join n_of_comments c
       on p.id = c.photo_id
),
user_engagement as (
SELECT user_id, 
       SUM(engagement_score) as overall_engagement
       from photo_engagements 
       group by user_id
)
SELECT u.id,
       u.username,
       ue.overall_engagement,
	  RANK() over(order by ue.overall_engagement desc) as Rank_eng
      from user_engagement ue
      join users u
      on ue.user_id = u.id
      order by ue.overall_engagement desc
      
WITH no_of_followers as (
SELECT followee_id as user_id, count(*) as no_of_follower
from follows
group by followee_id 
),
no_of_followings as (
SELECT follower_id as user_id, count(*) as no_of_following
from follows
group by follower_id
),
All_counts as (
SELECT u.id,
	   u.username,
       COALESCE(fw.no_of_follower,0) as no_of_follower,
       COALESCE(fe.no_of_following,0) as no_of_following
       from users u
       left join no_of_followings fe
       on u.id = fe.user_id
       left join no_of_followers fw
       on u.id = fw.user_id
)
SELECT 
 * , RANK() over(order by no_of_follower desc) as highest_followers,
 RANK() over(order by no_of_following desc) as highest_following
 from All_counts
 order by highest_followers,highest_following

WITH n_of_likes as (
SELECT photo_id, count(*) as n_of_like
from likes 
group by photo_id
),
n_of_comments as (
SELECT photo_id, count(*) as n_of_comment
from comments
group by photo_id
),
photo_engagement as  (
SELECT p.user_id,
       p.id,
       COALESCE(l.n_of_like,0) as n_of_like,
       COALESCE(c.n_of_comment,0) as n_of_comment,
       COALESCE(l.n_of_like,0) + COALESCE(c.n_of_comment,0)
       as engagement 
       from photos p
       left join n_of_likes l
       on p.id = l.photo_id
       left join n_of_comments c
       on p.id = c.photo_id
)
SELECT u.id,
       u.username,
       avg(pe.engagement) as avg_engagement_per_post
       from users u
       left join photo_engagement pe
       on u.id = pe.user_id
       group by u.id, u.username
       order by avg_engagement_per_post desc

SELECT u.id, u.username 
from users u
left join likes l
on l.user_id = u.id
where l.user_id is null

WITH no_of_likes as (
SELECT photo_id, count(*) as no_of_like
from likes 
group by photo_id
),
no_of_comments as (
SELECT photo_id, count(*) as no_of_comment 
from comments
group by photo_id
),
photo_engagement as (
SELECT p.user_id,
       p.id,
       COALESCE(l.no_of_like,0) as no_of_like,
       COALESCE(c.no_of_comment,0) as no_of_comment,
       COALESCE(l.no_of_like,0) + COALESCE(c.no_of_comment,0)
       as engagement_score
       from photos p
       left join no_of_likes l
       on p.id = l.photo_id
       left join no_of_comments c
       on p.id = c.photo_id
),
tag_engagement_rate as (
SELECT t.id,
	   t.tag_name,
       COUNT(DISTINCT pt.photo_id) as no_of_photos,
       SUM(pe.engagement_score) as total_engagements,
      ROUND(SUM(pe.engagement_score) / COUNT(DISTINCT pt.photo_id),2)
       as engagement_rate
       from tags t
       join photo_tags pt
       on t.id = pt.tag_id
       join photo_engagement pe
       on pe.id = pt.photo_id 
	   group by t.id,t.tag_name
)
SELECT * FROM tag_engagement_rate
order by engagement_rate desc, total_engagements desc
limit 3;

WITH no_of_likes as (
SELECT photo_id, count(*) as no_of_like
from likes 
group by photo_id
),
no_of_comments as (
SELECT photo_id, count(*) as no_of_comment 
from comments
group by photo_id
),
no_of_photo_tags as ( 
SELECT photo_id, count(*) as no_of_photo_tag
from photo_tags
group by photo_id
),
engagement_scores as (
SELECT p.user_id,
       p.id,
       COALESCE(l.no_of_like,0) as no_of_like,
       COALESCE(c.no_of_comment,0) as no_of_comment,
       COALESCE(pt.no_of_photo_tag,0) as no_of_photo_tag,
       COALESCE(l.no_of_like,0) + COALESCE(c.no_of_comment,0) +
       COALESCE(pt.no_of_photo_tag,0)
       as engagement_score
       from photos p
       left join no_of_photo_tags pt
       on p.id = pt.photo_id
       left join no_of_likes l
       on p.id = l.photo_id
       left join no_of_comments c
       on p.id = c.photo_id
)
SELECT u.id,
	   u.username,
      COALESCE(sum(ES.no_of_like),0) as total_no_of_like,
       COALESCE(sum(ES.no_of_comment),0) as total_no_comment,
       COALESCE(sum(ES.no_of_photo_tag),0) as total_no_of_photo_tag,
       COALESCE(sum(ES.engagement_score),0) as total_engagement_score
       from users u
       left join engagement_scores ES
       on u.id = ES.user_id
       group by u.id, u.username
       order by u.id

WITH no_of_likes as (
SELECT photo_id, count(*) as no_of_like
from likes 
group by photo_id
),
no_of_comments as (
SELECT photo_id, count(*) as no_of_comment 
from comments
group by photo_id
),
no_of_photo_tags as ( 
SELECT photo_id, count(*) as no_of_photo_tag
from photo_tags
group by photo_id
),
engagement_scores as (
SELECT p.user_id,
       p.id,
       COALESCE(l.no_of_like,0) as no_of_like,
       COALESCE(c.no_of_comment,0) as no_of_comment,
       COALESCE(pt.no_of_photo_tag,0) as no_of_photo_tag,
       COALESCE(l.no_of_like,0) + COALESCE(c.no_of_comment,0) +
       COALESCE(pt.no_of_photo_tag,0)
       as engagement_score
       from photos p
       left join no_of_photo_tags pt
       on p.id = pt.photo_id
       left join no_of_likes l
       on p.id = l.photo_id
       left join no_of_comments c
       on p.id = c.photo_id
),
total_engagement_scores as (
SELECT u.id,
	   u.username,
      COALESCE(sum(ES.no_of_like),0) as total_no_of_like,
       COALESCE(sum(ES.no_of_comment),0) as total_no_comment,
       COALESCE(sum(ES.no_of_photo_tag),0) as total_no_of_photo_tag,
       COALESCE(sum(ES.engagement_score),0) as total_engagement_score
       from users u
       left join engagement_scores ES
       on u.id = ES.user_id
       group by u.id, u.username
       order by u.id 
)
SELECT *,
       RANK() over(order by total_engagement_score desc) as Rnk_total_engagement_scores 
       from total_engagement_scores

WITH likes_count as (
SELECT photo_id, 
       count(*) as no_of_like
       from likes
       group by photo_id
),
avg_like_hashtag as (
       SELECT t.tag_name,
       COALESCE(avg(l.no_of_like),0) as avg_of_likes
       from tags t
       join photo_tags pt
       on t.id = pt.tag_id
       join photos p
       on pt.photo_id = p.id
       left join likes_count l
       on p.id = l.photo_id
       group by t.tag_name
)
SELECT *
 FROM avg_like_hashtag alh
 where avg_of_likes = (
 SELECT MAX(avg_of_likes) 
 from avg_like_hashtag
 )

SELECT DISTINCT f1.follower_id
           from follows f1
            join follows f2
	   on f1.follower_id = f2.followee_id
	   and f1.followee_id = f2.follower_id
       where f1.created_at = f2.created_at

WITH no_of_likes as (
SELECT photo_id, count(*) as no_of_like
from likes 
group by photo_id
),
no_of_comments as (
SELECT photo_id, count(*) as no_of_comment 
from comments
group by photo_id
),
photo_engagement as (
SELECT p.user_id,
       p.id,
       COALESCE(l.no_of_like,0) as no_of_like,
       COALESCE(c.no_of_comment,0) as no_of_comment,
       COALESCE(l.no_of_like,0) + COALESCE(c.no_of_comment,0)
       as engagement_score
       from photos p
       left join no_of_likes l
       on p.id = l.photo_id
       left join no_of_comments c
       on p.id = c.photo_id
),
tag_engagement_rate as (
SELECT t.id,
	   t.tag_name,
       COUNT(DISTINCT pt.photo_id) as no_of_photos,
       SUM(pe.engagement_score) as total_engagements,
      ROUND(SUM(pe.engagement_score) / COUNT(DISTINCT pt.photo_id),2)
       as engagement_rate
       from tags t
       join photo_tags pt
       on t.id = pt.tag_id
       join photo_engagement pe
       on pe.id = pt.photo_id 
	   group by t.id,t.tag_name
)
SELECT * FROM tag_engagement_rate
where engagement_rate = (
SELECT MAX(engagement_rate) AS highest_engagement_rate
from tag_engagement_rate
ORDER BY engagement_rate desc
)

SELECT u.id, u.username,
       COUNT(DISTINCT l.photo_id) AS no_of_likes,
       COUNT(DISTINCT c.photo_id) AS no_of_comments,
       COUNT(DISTINCT pt.photo_id) AS no_of_photo_tags
FROM users u
LEFT JOIN likes l
    ON l.user_id = u.id
LEFT JOIN comments c
    ON c.user_id = u.id
LEFT JOIN photos p
    ON p.user_id = u.id
LEFT JOIN photo_tags pt
    ON pt.photo_id = p.id
WHERE l.user_id IS NULL
  AND c.user_id IS NULL
  AND pt.photo_id IS NULL
GROUP BY u.id, u.username;

WITH no_of_likes as (
SELECT photo_id, count(*) as no_of_like
from likes 
group by photo_id
),
no_of_comments as (
SELECT photo_id, count(*) as no_of_comment 
from comments
group by photo_id
),
photo_engagement as (
SELECT p.user_id,
       p.id,
       COALESCE(l.no_of_like,0) as no_of_like,
       COALESCE(c.no_of_comment,0) as no_of_comment,
       COALESCE(l.no_of_like,0) + COALESCE(c.no_of_comment,0)
       as engagement_score
       from photos p
       left join no_of_likes l
       on p.id = l.photo_id
       left join no_of_comments c
       on p.id = c.photo_id
),
user_engagement as (
 SELECT pe.user_id,
        COUNT(pe.id) as photo_count,
        SUM(pe.engagement_score) as total_engagement,
        SUM(pe.engagement_score) /  COUNT(pe.id) as avg_eng_per_post
        from photo_engagement pe
        group by pe.user_id
),
Follower_count as (
SELECT followee_id as user_id,
       COUNT(DISTINCT follower_id) as no_of_following
       from follows
       group by followee_id 
)
SELECT u.id,
	   u.username,
       COALESCE(ue.photo_count,0) AS photo_count,
	   COALESCE(ue.total_engagement,0) AS total_engagement,
       COALESCE(ue.avg_eng_per_post,0) AS avg_eng_per_post,
       COALESCE(fc.no_of_following,0) AS no_of_following,
       RANK() over(order by fc.no_of_following desc, ue.avg_eng_per_post desc)
       as Influencer_ranking
       from users u
       left join user_engagement ue
       on u.id = ue.user_id
       left join Follower_count fc
       on u.id = fc.user_id
        

 UPDATE User_Interactions
         SET Engagement_Type = 'Heart'
         WHERE Engagement_Type = 'Like' 

        
        
       










