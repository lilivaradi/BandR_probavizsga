-- phpMyAdmin SQL Dump
-- version 5.1.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Feb 22, 2026 at 09:24 PM
-- Server version: 5.7.24
-- PHP Version: 8.3.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `bandr_uj`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddLike` (IN `p_post_id` INT, IN `p_user_id` INT)   BEGIN
    IF NOT EXISTS (
        SELECT 1 
        FROM post_likes 
        WHERE post_id = p_post_id 
          AND user_id = p_user_id
    ) THEN
        INSERT INTO post_likes (post_id, user_id)
        VALUES (p_post_id, p_user_id);
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `AddPost` (IN `p_band_id` INT, IN `p_title` VARCHAR(200), IN `p_content` TEXT)   BEGIN
    INSERT INTO Posts (band_id, title, content)
    VALUES (p_band_id, p_title, p_content);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `AddSample` (IN `p_band_id` INT, IN `p_title` VARCHAR(200), IN `p_file_url` TEXT)   BEGIN
    INSERT INTO Samples (band_id, title, file_url)
    VALUES (p_band_id, p_title, p_file_url);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `CountLikes` (IN `p_post_id` INT)   BEGIN
    SELECT COUNT(*) AS total_likes
    FROM post_likes
    WHERE post_id = p_post_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `CreateBand` (IN `p_name` VARCHAR(100), IN `p_description` TEXT, IN `p_created_by` INT)   BEGIN
    INSERT INTO Bands (name, description, created_by)
    VALUES (p_name, p_description, p_created_by);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `CreateProfile` (IN `p_user_id` INT, IN `p_bio` TEXT, IN `p_instruments` TEXT, IN `p_fav_genres` TEXT, IN `p_location` VARCHAR(100))   BEGIN
    INSERT INTO Profiles (
        user_id, bio, instruments, fav_genres, location,
        looking_for_band, looking_for_fans
    ) VALUES (
        p_user_id, p_bio, p_instruments, p_fav_genres, p_location
    );
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `CreateUser` (IN `p_username` VARCHAR(50), IN `p_email` VARCHAR(100), IN `p_password_hash` VARCHAR(200))   BEGIN
    INSERT INTO Users (username, email, password_hash)
    VALUES (p_username, p_email, p_password_hash);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAllBand` ()   BEGIN
    SELECT * FROM Bands;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAllPosts` ()   BEGIN
    SELECT * FROM posts;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAllUsers` ()   BEGIN
    SELECT * FROM Users;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetBandById` (IN `p_band_id` INT)   BEGIN
    SELECT * FROM Bands WHERE band_id = p_band_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetInbox` (IN `p_user_id` INT)   BEGIN
    SELECT message_id, sender_id, content, sent
    FROM Messages
    WHERE receiver_id = p_user_id
    ORDER BY sent DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetMessageById` (IN `p_message_id` INT)   BEGIN
    SELECT message_id, sender_id, receiver_id, content, sent
    FROM Messages
    WHERE message_id = p_message_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetMessagesBetweenUsers` (IN `p_user1_id` INT, IN `p_user2_id` INT)   BEGIN
    SELECT message_id, sender_id, receiver_id, content, sent
    FROM Messages
    WHERE (sender_id = p_user1_id AND receiver_id = p_user2_id)
       OR (sender_id = p_user2_id AND receiver_id = p_user1_id)
    ORDER BY sent ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetPostById` (IN `p_post_id` INT)   BEGIN
    SELECT post_id, band_id, title, content, created
    FROM Posts
    WHERE post_id = p_post_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetPostLikes` (IN `p_post_id` INT)   BEGIN
    SELECT user_id, created
    FROM post_likes
    WHERE post_id = p_post_id
    ORDER BY created DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetPostsByBand` (IN `p_band_id` INT)   BEGIN
    SELECT post_id, title, content, created
    FROM Posts
    WHERE band_id = p_band_id
    ORDER BY created DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetProfileByUser` (IN `p_user_id` INT)   BEGIN
    SELECT *
    FROM Profiles
    WHERE user_id = p_user_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetSampleById` (IN `p_sample_id` INT)   BEGIN
    SELECT sample_id, band_id, title, file_url, uploaded
    FROM Samples
    WHERE sample_id = p_sample_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetSamplesByBand` (IN `p_band_id` INT)   BEGIN
    SELECT sample_id, title, file_url, uploaded
    FROM Samples
    WHERE band_id = p_band_id
    ORDER BY uploaded DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetSavedPostsByUser` (IN `p_user_id` INT)   BEGIN
    SELECT
        p.post_id,
        p.title,
        p.content,
        p.status,
        p.created_at,
        s.saved_at
    FROM saved_posts s
    JOIN posts p ON s.post_id = p.post_id
    WHERE s.user_id = p_user_id
    ORDER BY s.saved_at DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetUserById` (IN `p_user_id` INT)   BEGIN
    SELECT * FROM Users WHERE user_id = p_user_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `HardDeleteBand` (IN `p_band_id` INT)   BEGIN
    DELETE FROM Band WHERE band_id = p_band_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `HardDeleteMessage` (IN `p_message_id` INT)   BEGIN
    DELETE FROM Messages
    WHERE message_id = p_message_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `HardDeletePost` (IN `p_post_id` INT)   BEGIN
    DELETE FROM Posts
    WHERE post_id = p_post_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `HardDeleteProfile` (IN `p_user_id` INT)   BEGIN
    DELETE FROM Profiles
    WHERE user_id = p_user_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `HardDeleteSample` (IN `p_sample_id` INT)   BEGIN
    DELETE FROM Samples
    WHERE sample_id = p_sample_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `HardDeleteUser` (IN `p_user_id` INT)   BEGIN
    DELETE FROM Users WHERE user_id = p_user_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `HasLiked` (IN `p_post_id` INT, IN `p_user_id` INT)   BEGIN
    SELECT 
        CASE 
            WHEN EXISTS (
                SELECT 1 
                FROM post_likes 
                WHERE post_id = p_post_id 
                  AND user_id = p_user_id
            ) THEN 1
            ELSE 0
        END AS has_liked;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `IsPostSaved` (IN `p_user_id` INT, IN `p_post_id` INT)   BEGIN
    SELECT EXISTS (
        SELECT 1
        FROM saved_posts
        WHERE user_id = p_user_id
          AND post_id = p_post_id
    ) AS is_saved;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `RemoveLike` (IN `p_post_id` INT, IN `p_user_id` INT)   BEGIN
    DELETE FROM post_likes
    WHERE post_id = p_post_id
      AND user_id = p_user_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SavePost` (IN `p_user_id` INT, IN `p_post_id` INT)   BEGIN
    INSERT IGNORE INTO saved_posts (user_id, post_id)
    VALUES (p_user_id, p_post_id);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SendMessage` (IN `p_sender_id` INT, IN `p_receiver_id` INT, IN `p_content` TEXT)   BEGIN
    INSERT INTO Messages (sender_id, receiver_id, content)
    VALUES (p_sender_id, p_receiver_id, p_content);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SoftDeleteAdmin` (IN `p_admin_id` INT(11))   BEGIN
    UPDATE admins
    SET 
        is_deleted = 1,
        deleted_at = NOW()
    WHERE id = p_admin_id
      AND is_deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SoftDeleteAdminbandactions` (IN `p_id` INT(11))   BEGIN
    UPDATE admin_band_actions
    SET 
        is_deleted = 1,
        deleted_at = NOW()
    WHERE id = p_id
      AND is_deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SoftDeleteAdminuseractions` (IN `p_id` INT(11))   BEGIN
    UPDATE admin_user_actions
    SET 
        is_deleted = 1,
        deleted_at = NOW()
    WHERE id = p_id
      AND is_deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SoftDeleteBands` (IN `p_band_id` INT(11))   BEGIN
    UPDATE bands
    SET 
        is_deleted = 1,
        deleted_at = NOW()
    WHERE id = p_band_id
      AND is_deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SoftDeleteMessages` (IN `p_message_id` INT(11))   BEGIN
    UPDATE messages
    SET 
        is_deleted = 1,
        deleted_at = NOW()
    WHERE id = p_message_id
      AND is_deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SoftDeletePostLikes` (IN `p_like_id` INT(11))   BEGIN
    UPDATE post_likes
    SET 
        is_deleted = 1,
        deleted_at = NOW()
    WHERE id = p_like_id
      AND is_deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SoftDeletePostModeration` (IN `p_id` INT(11))   BEGIN
    UPDATE post_moderation
    SET 
        is_deleted = 1,
        deleted_at = NOW()
    WHERE id = p_id
      AND is_deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SoftDeletePosts` (IN `p_post_id` INT(11))   BEGIN
    UPDATE posts
    SET 
        is_deleted = 1,
        deleted_at = NOW()
    WHERE id = p_post_id
      AND is_deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SoftDeleteSample` (IN `p_sample_id` INT(11))   BEGIN
    UPDATE samples
    SET 
        is_deleted = 1,
        deleted_at = NOW()
    WHERE id = p_sample_id
      AND is_deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SoftDeleteSavedPosts` (IN `p_save_id` INT(11))   BEGIN
    UPDATE saved_posts
    SET 
        is_deleted = 1,
        deleted_at = NOW()
    WHERE id = p_save_id
      AND is_deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SoftDeleteUser` (IN `p_user_id` INT(11))   BEGIN
    UPDATE users
    SET 
        is_deleted = 1,
        deleted_at = NOW()
    WHERE id = p_user_id
      AND is_deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_activate_user` (IN `p_admin_id` INT, IN `p_user_id` INT)   BEGIN
    UPDATE users
    SET is_active = TRUE
    WHERE id = p_user_id;

    INSERT INTO admin_user_actions (admin_id, user_id, action)
    VALUES (p_admin_id, p_user_id, 'activate');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_create_admin` (IN `p_username` VARCHAR(100), IN `p_email` VARCHAR(150), IN `p_password_hash` VARCHAR(255))   BEGIN
    INSERT INTO admins (username, email, password_hash)
    VALUES (p_username, p_email, p_password_hash);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_dashboard_summary` ()   BEGIN
    SELECT
        (SELECT COUNT(*) FROM users) AS total_users,
        (SELECT COUNT(*) FROM bands) AS total_bands,
        (SELECT COUNT(*) FROM posts) AS total_posts,
        (SELECT COUNT(*) FROM messages) AS total_messages,
        (SELECT COUNT(*) FROM post_likes) AS total_likes,
        (SELECT COUNT(*) FROM samples) AS total_samples;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_login_user` (IN `p_username` VARCHAR(50), IN `p_password_hash` VARCHAR(200))   BEGIN
    DECLARE v_user_id INT;

    SELECT user_id INTO v_user_id
    FROM users
    WHERE username = p_username
      AND password_hash = p_password_hash
      AND is_active = 1
    LIMIT 1;

    IF v_user_id IS NOT NULL THEN
        SELECT 
            'SUCCESS' AS status,
            user_id,
            username,
            email,
            created
        FROM users
        WHERE user_id = v_user_id;
    ELSE
        SELECT 'INVALID_CREDENTIALS' AS status;
    END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_moderate_post` (IN `p_admin_id` INT, IN `p_post_id` INT, IN `p_status` VARCHAR(20), IN `p_reason` TEXT)   BEGIN
    INSERT INTO post_moderation (post_id, admin_id, status, reason)
    VALUES (p_post_id, p_admin_id, p_status, p_reason);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_suspend_user` (IN `p_admin_id` INT, IN `p_user_id` INT, IN `p_reason` TEXT)   BEGIN
    UPDATE users
    SET is_active = FALSE
    WHERE id = p_user_id;

    INSERT INTO admin_user_actions (admin_id, user_id, action, reason)
    VALUES (p_admin_id, p_user_id, 'suspend', p_reason);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_admin_status` (IN `p_admin_id` INT, IN `p_is_active` BOOLEAN)   BEGIN
    UPDATE admins
    SET is_active = p_is_active
    WHERE id = p_admin_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ToggleLike` (IN `p_post_id` INT, IN `p_user_id` INT)   BEGIN
    IF EXISTS (
        SELECT 1 
        FROM post_likes 
        WHERE post_id = p_post_id 
          AND user_id = p_user_id
    ) THEN
        DELETE FROM post_likes
        WHERE post_id = p_post_id
          AND user_id = p_user_id;
    ELSE
        INSERT INTO post_likes (post_id, user_id)
        VALUES (p_post_id, p_user_id);
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ToggleSavePost` (IN `p_user_id` INT, IN `p_post_id` INT)   BEGIN
    IF EXISTS (
        SELECT 1 FROM saved_posts
        WHERE user_id = p_user_id
          AND post_id = p_post_id
    ) THEN
        DELETE FROM saved_posts
        WHERE user_id = p_user_id
          AND post_id = p_post_id;
    ELSE
        INSERT INTO saved_posts (user_id, post_id)
        VALUES (p_user_id, p_post_id);
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UnsavePost` (IN `p_user_id` INT, IN `p_post_id` INT)   BEGIN
    DELETE FROM saved_posts
    WHERE user_id = p_user_id
      AND post_id = p_post_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateBand` (IN `p_band_id` INT, IN `p_name` VARCHAR(100), IN `p_description` TEXT, IN `p_created_by` INT)   BEGIN
    UPDATE Bands
    SET name = p_name,
        description = p_description,
        created_by = p_created_by
    WHERE band_id = p_band_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdatePost` (IN `p_post_id` INT, IN `p_title` VARCHAR(200), IN `p_content` TEXT)   BEGIN
    UPDATE Posts
    SET title = p_title,
        content = p_content
    WHERE post_id = p_post_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateProfile` (IN `p_user_id` INT, IN `p_bio` TEXT, IN `p_instruments` TEXT, IN `p_fav_genres` TEXT, IN `p_location` VARCHAR(100))   BEGIN
    UPDATE Profiles
    SET
        bio = p_bio,
        instruments = p_instruments,
        fav_genres = p_fav_genres,
        location = p_location
    WHERE user_id = p_user_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateSample` (IN `p_sample_id` INT, IN `p_title` VARCHAR(200), IN `p_file_url` TEXT)   BEGIN
    UPDATE Samples
    SET title = p_title,
        file_url = p_file_url
    WHERE sample_id = p_sample_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateUser` (IN `p_user_id` INT, IN `p_username` VARCHAR(50), IN `p_email` VARCHAR(100), IN `p_password_hash` TEXT, IN `p_user_type` ENUM('fan','artist'))   BEGIN
    UPDATE Users
    SET username = p_username,
        email = p_email,
        password_hash = p_password_hash,
        user_type = p_user_type
    WHERE user_id = p_user_id;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `admins`
--

CREATE TABLE `admins` (
  `id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_login` timestamp NULL DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `admin_band_actions`
--

CREATE TABLE `admin_band_actions` (
  `id` int(11) NOT NULL,
  `admin_id` int(11) NOT NULL,
  `band_id` int(11) NOT NULL,
  `action` enum('suspend','delete') NOT NULL,
  `reason` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `admin_user_actions`
--

CREATE TABLE `admin_user_actions` (
  `id` int(11) NOT NULL,
  `admin_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `action` enum('suspend','activate','delete') NOT NULL,
  `reason` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `bands`
--

CREATE TABLE `bands` (
  `band_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text,
  `created_by` int(11) DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `bands`
--

INSERT INTO `bands` (`band_id`, `name`, `description`, `created_by`, `created`, `is_deleted`, `deleted_at`) VALUES
(1, '52imultán', 'jó banda', 1, '2025-09-12 08:33:19', 0, NULL),
(2, 'nagyon jó banda', 'ja', 1, '2025-09-26 13:35:26', 0, NULL),
(3, 'asdfgh', 'asdfghjkl', 2, '2026-01-26 10:31:43', 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `messages`
--

CREATE TABLE `messages` (
  `message_id` int(11) NOT NULL,
  `sender_id` int(11) DEFAULT NULL,
  `receiver_id` int(11) DEFAULT NULL,
  `content` text,
  `sent` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `messages`
--

INSERT INTO `messages` (`message_id`, `sender_id`, `receiver_id`, `content`, `sent`, `is_deleted`, `deleted_at`) VALUES
(1, 2, 1, 'hali', '2025-09-26 07:59:42', 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `posts`
--

CREATE TABLE `posts` (
  `post_id` int(11) NOT NULL,
  `band_id` int(11) DEFAULT NULL,
  `title` varchar(200) DEFAULT NULL,
  `content` text,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `image_url` varchar(200) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `posts`
--

INSERT INTO `posts` (`post_id`, `band_id`, `title`, `content`, `created`, `image_url`, `is_deleted`, `deleted_at`) VALUES
(1, 1, 'Konert Pécsen!', 'Már megint', '2025-09-26 08:07:57', NULL, 0, NULL),
(2, 2, 'történés', 'asdfghjk', '2026-01-26 09:57:32', NULL, 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `post_likes`
--

CREATE TABLE `post_likes` (
  `like_id` int(11) NOT NULL,
  `post_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `post_likes`
--

INSERT INTO `post_likes` (`like_id`, `post_id`, `user_id`, `created`, `is_deleted`, `deleted_at`) VALUES
(1, 2, NULL, '2026-01-26 09:58:33', 0, NULL),
(2, 2, NULL, '2026-01-26 09:59:31', 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `post_moderation`
--

CREATE TABLE `post_moderation` (
  `id` int(11) NOT NULL,
  `post_id` int(11) NOT NULL,
  `admin_id` int(11) NOT NULL,
  `status` enum('approved','rejected','flagged') DEFAULT 'approved',
  `reason` text,
  `moderated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `profiles`
--

CREATE TABLE `profiles` (
  `user_id` int(11) NOT NULL,
  `bio` text,
  `instruments` text,
  `fav_genres` text,
  `location` varchar(100) DEFAULT NULL,
  `age` int(100) DEFAULT NULL,
  `experience_years` int(90) DEFAULT NULL,
  `availability` varchar(200) NOT NULL,
  `preferred_role` varchar(100) NOT NULL,
  `influences` varchar(200) NOT NULL,
  `equipment` varchar(200) NOT NULL,
  `pfp_url` varchar(200) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `profiles`
--

INSERT INTO `profiles` (`user_id`, `bio`, `instruments`, `fav_genres`, `location`, `age`, `experience_years`, `availability`, `preferred_role`, `influences`, `equipment`, `pfp_url`, `is_deleted`, `deleted_at`) VALUES
(1, 'amina', NULL, 'k-pop', 'Beremend', NULL, NULL, '', '', '', '', NULL, 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `samples`
--

CREATE TABLE `samples` (
  `sample_id` int(11) NOT NULL,
  `band_id` int(11) DEFAULT NULL,
  `title` varchar(200) DEFAULT NULL,
  `file_url` text,
  `uploaded` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `samples`
--

INSERT INTO `samples` (`sample_id`, `band_id`, `title`, `file_url`, `uploaded`, `is_deleted`, `deleted_at`) VALUES
(1, 2, 'asdfg', 'nemtudom', '2026-01-20 09:06:45', 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `saved_posts`
--

CREATE TABLE `saved_posts` (
  `save_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `post_id` int(11) NOT NULL,
  `saved_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `password_hash` varchar(200) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `username`, `email`, `created`, `password_hash`, `is_active`, `is_deleted`, `deleted_at`) VALUES
(1, 'Amina', 'torokamina@gmail.com', '2025-09-12 08:18:57', '', 1, 0, NULL),
(2, 'Boti', 'example@gmail.com', '2025-09-26 07:46:14', '', 1, 0, NULL),
(3, 'Józsibácsi', 'józsibácsi@gmail.com', '2026-02-22 17:29:56', '$2a$12$a7q4J955A/8ybYF.0MZ8FulDlePK.9DXKuVqhAJNUuHJlr2ZIPSTC', 1, 0, NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `admin_band_actions`
--
ALTER TABLE `admin_band_actions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `admin_id` (`admin_id`),
  ADD KEY `band_id` (`band_id`);

--
-- Indexes for table `admin_user_actions`
--
ALTER TABLE `admin_user_actions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `admin_id` (`admin_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `bands`
--
ALTER TABLE `bands`
  ADD PRIMARY KEY (`band_id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD KEY `created_by` (`created_by`);

--
-- Indexes for table `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`message_id`),
  ADD KEY `sender_id` (`sender_id`),
  ADD KEY `receiver_id` (`receiver_id`);

--
-- Indexes for table `posts`
--
ALTER TABLE `posts`
  ADD PRIMARY KEY (`post_id`),
  ADD KEY `band_id` (`band_id`);

--
-- Indexes for table `post_likes`
--
ALTER TABLE `post_likes`
  ADD PRIMARY KEY (`like_id`),
  ADD KEY `post_id` (`post_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `post_moderation`
--
ALTER TABLE `post_moderation`
  ADD PRIMARY KEY (`id`),
  ADD KEY `post_id` (`post_id`),
  ADD KEY `admin_id` (`admin_id`);

--
-- Indexes for table `profiles`
--
ALTER TABLE `profiles`
  ADD PRIMARY KEY (`user_id`);

--
-- Indexes for table `samples`
--
ALTER TABLE `samples`
  ADD PRIMARY KEY (`sample_id`),
  ADD KEY `band_id` (`band_id`);

--
-- Indexes for table `saved_posts`
--
ALTER TABLE `saved_posts`
  ADD PRIMARY KEY (`save_id`),
  ADD UNIQUE KEY `user_id` (`user_id`),
  ADD KEY `post_id` (`post_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admins`
--
ALTER TABLE `admins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `admin_band_actions`
--
ALTER TABLE `admin_band_actions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `admin_user_actions`
--
ALTER TABLE `admin_user_actions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `bands`
--
ALTER TABLE `bands`
  MODIFY `band_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `messages`
--
ALTER TABLE `messages`
  MODIFY `message_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `posts`
--
ALTER TABLE `posts`
  MODIFY `post_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `post_likes`
--
ALTER TABLE `post_likes`
  MODIFY `like_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `post_moderation`
--
ALTER TABLE `post_moderation`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `samples`
--
ALTER TABLE `samples`
  MODIFY `sample_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `admin_band_actions`
--
ALTER TABLE `admin_band_actions`
  ADD CONSTRAINT `admin_id` FOREIGN KEY (`admin_id`) REFERENCES `admins` (`id`),
  ADD CONSTRAINT `band_id` FOREIGN KEY (`band_id`) REFERENCES `bands` (`band_id`);

--
-- Constraints for table `admin_user_actions`
--
ALTER TABLE `admin_user_actions`
  ADD CONSTRAINT `admin_id2` FOREIGN KEY (`admin_id`) REFERENCES `admins` (`id`),
  ADD CONSTRAINT `user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `bands`
--
ALTER TABLE `bands`
  ADD CONSTRAINT `bands_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `messages`
--
ALTER TABLE `messages`
  ADD CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`sender_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `messages_ibfk_2` FOREIGN KEY (`receiver_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `posts`
--
ALTER TABLE `posts`
  ADD CONSTRAINT `posts_ibfk_1` FOREIGN KEY (`band_id`) REFERENCES `bands` (`band_id`);

--
-- Constraints for table `post_likes`
--
ALTER TABLE `post_likes`
  ADD CONSTRAINT `post_likes_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `postid` FOREIGN KEY (`post_id`) REFERENCES `posts` (`post_id`);

--
-- Constraints for table `post_moderation`
--
ALTER TABLE `post_moderation`
  ADD CONSTRAINT `admin_id3` FOREIGN KEY (`admin_id`) REFERENCES `admins` (`id`),
  ADD CONSTRAINT `post_id2` FOREIGN KEY (`post_id`) REFERENCES `posts` (`post_id`);

--
-- Constraints for table `profiles`
--
ALTER TABLE `profiles`
  ADD CONSTRAINT `profiles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `samples`
--
ALTER TABLE `samples`
  ADD CONSTRAINT `samples_ibfk_1` FOREIGN KEY (`band_id`) REFERENCES `bands` (`band_id`);

--
-- Constraints for table `saved_posts`
--
ALTER TABLE `saved_posts`
  ADD CONSTRAINT `saved_posts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `saved_posts_ibfk_2` FOREIGN KEY (`post_id`) REFERENCES `posts` (`post_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
