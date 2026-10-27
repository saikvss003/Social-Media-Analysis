# 📊 Social Media Analytics - MYSQL

Analyzing an Instagram-style relational database to uncover user behavior, engagement patterns, and influencer opportunities : using MySQL.

Built as part of the Data Analytics, Engineering & Science program at Newton School.

---

# 🧩 Problem Statement :-

> How can we analyze user activity, engagement, and content data from a social media platform to derive actionable business insights?

· The project answers 23 business questions (13 objective + 10 subjective) covering activity distribution, engagement ranking, hashtag performance, influencer identification, and campaign strategy : using only SQL queries against a 7-table relational schema.

---

# 🗄️ Dataset :-

· A normalized, Instagram-style schema with 7 tables : users, photos, likes, comments, follows, tags, photo_tags.

| Metric | Value |
|---|---|
| Users | 100 |
| Photos posted | 257 |
| Likes | 8,782 |
| Comments | 7,488 |
| Follow relationships | 7,623 |
| Avg. tags per post | 1.95 |
| Duplicate / NULL records found | 0 |

· Every table was checked for duplicates and missing values before analysis - none were found, confirming a clean, referentially consistent dataset.

---

# 🛠️ Tools & Techniques :-

· MySQL.

· CTEs (Common Table Expressions)
· Window Functions (RANK() OVER()) 
· Multi-table Joins 
· Self-Joins 
· Aggregations 
· Correlated & Non-correlated Subqueries 
· COALESCE for null handling

---

# 🔍 Analysis Covered :- 

· **Data Quality Checks** - duplicate and NULL validation across all 7 tables
· **User Activity Distribution** - posts, likes, and comments per user, including fully inactive users
· **Engagement Ranking** - total and average engagement score per user via CTEs + RANK() OVER()
· **Follower/Following Analysis** - top users by followers, plus mutual-follow detection via self-join
· **Tag & Hashtag Analytics** - average tags per post, highest-engagement hashtags
· **User Segmentation** - Power Users, Influencer Tier, Casual Users, Inactive Users
· **Strategic Recommendations** - influencer outreach, re-engagement campaigns, hashtag-led ad strategy

---

# 💡 Key Insights :-

· **26 of 100 users (26%) have never posted** - the single largest opportunity for re-engagement campaigns.
· **Average engagement per post is a better influencer signal than raw totals.** Eveline95 has the highest total engagement score (749), but Donald.Fritsch    
    converts best on a per-post basis (65.33 avg/post).
· **A clear influencer tier exists**: the top 7 users each hold 77 followers - a highly competitive, identifiable segment for brand partnerships.
· **#delicious is the top-performing hashtag**, with a 65.27 engagement rate across 15 posts - food/lifestyle content drives the most interaction.
· **One power user posted 257 comments**  13× the platform average - while 23 users gave zero likes at all, showing a wide engagement gap across the user base.

---

# 📈 Business Recommendations :-

| Strategy | Action |
|---|---|
| **Influencer Campaign** | Target the top 7 users (77 followers each, avg engagement/post > 62) for sponsored posts and ambassador deals |
| **Re-engagement** | Push personalized incentives to the 26 zero-post users to drive their first post |
| **Hashtag-led Ads** | Anchor food/lifestyle campaigns on #delicious (65.27 engagement rate) and A/B test creatives per hashtag |

---

## 📎 Project Files :- 

| File | Description |
|---|---|
| [SQL Project](SQL%20Project.pptx) | All 23 SQL queries (data quality, engagement, ranking, segmentation) |
| [SQL project1](SQL%20Project.pptx) | Presentation deck with charts and findings |
| [sql final](./word%20sql%20final.docx) | Full written report - question, query, and answer for all 23 questions |

---

## 🙌 Reflection :-

This project pushed me beyond basic querying into multi-step CTEs, window functions, and self-joins and, more importantly, into translating raw engagement numbers into a usable business strategy (influencer targeting, segmentation, re-engagement). Built as part of my transition into data analytics.
