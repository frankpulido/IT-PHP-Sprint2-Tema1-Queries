USE youtube;

INSERT INTO users (username, user_password, birthdate, sex, country_residence, postalcode) VALUES
('john_doe', 'password123', '1990-05-15', 'M', 'ES', '28001'),
('jane_smith', 'password456', '1992-11-22', 'F', 'PO', '11000'),
('bob_ross', 'happycloud', '1985-08-10', 'M', 'IT', '00100');

INSERT INTO channels (id_user_creates_channel, channel_description) VALUES
(1, 'John Doe\'s Tech Reviews'),
(2, 'Jane Smith\'s Vlog Adventures'),
(3, 'Bob Ross Art Channel');

INSERT INTO user_subscribes_channel (id_channel, id_user_subscribes) VALUES
(1, 2), -- Jane subscribes to John’s channel
(2, 1), -- John subscribes to Jane’s channel
(3, 1); -- John subscribes to Bob’s channel

INSERT INTO videos (video_title, video_description, video_size, video_file, video_length, video_face_img_file, id_user_uploads) VALUES
('How to Build a PC', 'John Doe\'s PC Building Guide', 500, 'pc_build.mp4', '00:15:30', 'pc_build_thumb.jpg', 1),
('Vlog #1 - My Day in Lisbon', 'Jane Smith explores Lisbon', 300, 'vlog_lisbon.mp4', '00:05:45', 'vlog_lisbon_thumb.jpg', 2),
('Painting a Happy Tree', 'Bob Ross teaches you how to paint', 600, 'happy_tree.mp4', '00:20:00', 'happy_tree_thumb.jpg', 3);

INSERT INTO labels (label_name, id_video) VALUES
('Tech', 1),
('Travel', 2),
('Art', 3);

INSERT INTO playlists (id_user_creates_playlist, playlist_name) VALUES
(1, 'Tech Tutorials'),
(2, 'Travel Vlogs'),
(3, 'Painting Lessons');

INSERT INTO userplaylistscontents (id_playlist, id_video) VALUES
(1, 1), -- John adds his video to his Tech Tutorials playlist
(2, 2), -- Jane adds her video to her Travel Vlogs playlist
(3, 3); -- Bob adds his video to his Painting Lessons playlist

INSERT INTO user_subscribes_playlist (id_playlist, id_user_subscribes) VALUES
(1, 2), -- Jane subscribes to John's Tech Tutorials playlist
(2, 1); -- John subscribes to Jane's Travel Vlogs playlist

INSERT INTO videos_performance (id_video, id_user_interacts, user_plays, user_likes, user_comments_video) VALUES
(1, 2, 50, 'like', 'Great tutorial, very helpful!'),
(2, 1, 30, 'like', 'Lovely vlog, keep it up!'),
(3, 1, 40, NULL, NULL); -- No comment from John on Bob's video

INSERT INTO comments_performance (user_comments_video, id_user_rates_comment, user_rates_comment) VALUES
('Great tutorial, very helpful!', 1, 'like'), -- John rates Jane's comment on his video positively
('Lovely vlog, keep it up!', 2, 'like'); -- Jane rates John's comment on her video positively
