
DROP DATABASE IF EXISTS youtube;
CREATE DATABASE youtube CHARACTER SET utf8mb4;

USE youtube;

CREATE TABLE users (
    id_user BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(25) UNIQUE NOT NULL,
    user_password VARCHAR(30) NOT NULL,
    birthdate DATE DEFAULT NULL,
    sex ENUM('M', 'F') DEFAULT NULL,
    country_residence ENUM('ES', 'F', 'IT', 'D', 'PO') NOT NULL,
    postalcode VARCHAR(12) DEFAULT NULL,
    user_signedup TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE channels (
    id_channel BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_user_creates_channel BIGINT UNSIGNED NOT NULL,
    FOREIGN KEY (id_user_creates_channel) REFERENCES users(id_user) ON DELETE CASCADE ON UPDATE CASCADE,
    channel_description VARCHAR(250) NOT NULL,
    channel_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE user_subscribes_channel (
    PRIMARY KEY (id_channel, id_user_subscribes),
    id_channel BIGINT UNSIGNED NOT NULL,
    FOREIGN KEY (id_channel) REFERENCES channels(id_channel) ON DELETE CASCADE ON UPDATE CASCADE,
    id_user_subscribes BIGINT UNSIGNED NOT NULL,
    FOREIGN KEY (id_user_subscribes) REFERENCES users(id_user) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE videos (
    id_video BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    video_title VARCHAR(60) NOT NULL,
    video_description VARCHAR(150) NOT NULL,
    video_size SMALLINT UNSIGNED NOT NULL,
    video_file VARCHAR(60) NOT NULL,
    video_length TIME NOT NULL,
    video_face_img_file VARCHAR(60) NOT NULL,
    video_privacy ENUM('public', 'private', 'hidden') NOT NULL DEFAULT 'public',
    -- video_labels SET() DEFAULT NULL,
    -- debo hacer una función que alimente el SET con todos los TAGS (labels) cada vez que se etiquete
    video_published DATETIME DEFAULT NOW(),
    id_user_uploads BIGINT UNSIGNED NOT NULL,
    FOREIGN KEY (id_user_uploads) REFERENCES users(id_user) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE labels (
    id_label BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    label_name VARCHAR(24) UNIQUE NOT NULL,
    id_video BIGINT UNSIGNED NOT NULL,
    FOREIGN KEY (id_video) REFERENCES videos(id_video) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE playlists (
    id_playlist INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_user_creates_playlist BIGINT UNSIGNED NOT NULL,
    FOREIGN KEY (id_user_creates_playlist) REFERENCES users(id_user) ON DELETE RESTRICT ON UPDATE CASCADE,
    playlist_name VARCHAR(60) NOT NULL,
    playlist_status ENUM('private', 'public') DEFAULT 'public' NOT NULL,
    playlist_created DATETIME DEFAULT NOW()
);

CREATE TABLE userplaylistscontents (
    PRIMARY KEY (id_playlist, id_video),
    id_playlist INT UNSIGNED NOT NULL,
    FOREIGN KEY (id_playlist) REFERENCES playlists(id_playlist) ON DELETE RESTRICT ON UPDATE CASCADE,
    id_video BIGINT UNSIGNED NOT NULL,
    FOREIGN KEY (id_video) REFERENCES videos(id_video) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE user_subscribes_playlist (
    PRIMARY KEY (id_playlist, id_user_subscribes),
    id_playlist INT UNSIGNED NOT NULL,
    FOREIGN KEY (id_playlist) REFERENCES playlists(id_playlist) ON DELETE CASCADE ON UPDATE CASCADE,
    id_user_subscribes BIGINT UNSIGNED NOT NULL,
    FOREIGN KEY (id_user_subscribes) REFERENCES users(id_user) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE videos_performance (
    PRIMARY KEY (id_video, id_user_interacts),
    id_video BIGINT UNSIGNED NOT NULL,
    FOREIGN KEY (id_video) REFERENCES videos(id_video) ON DELETE CASCADE ON UPDATE CASCADE,
    id_user_interacts BIGINT UNSIGNED NOT NULL,
    FOREIGN KEY (id_user_interacts) REFERENCES users(id_user) ON DELETE CASCADE ON UPDATE CASCADE,
    user_plays SMALLINT UNSIGNED NOT NULL,
    user_likes ENUM('like', 'dislike') DEFAULT NULL,
    user_comments_video VARCHAR(250) UNIQUE DEFAULT NULL
);

CREATE TABLE comments_performance (
    PRIMARY KEY (user_comments_video, id_user_rates_comment),
    user_comments_video VARCHAR(250) NOT NULL,
    FOREIGN KEY (user_comments_video) REFERENCES videos_performance(user_comments_video) ON DELETE CASCADE ON UPDATE CASCADE,
    id_user_rates_comment BIGINT UNSIGNED NOT NULL,
    FOREIGN KEY (id_user_rates_comment) REFERENCES users(id_user) ON DELETE CASCADE ON UPDATE CASCADE,
    user_rates_comment ENUM('like', 'dislike') NOT NULL
);

