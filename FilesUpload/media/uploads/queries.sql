INSERT INTO Students (first_name, last_name, email) VALUES
('Elsaeed', 'Ahmed', 'elsaeedahmed@email.com'),
('Ahmed', 'Mohammed', 'ahmedmohammedh@email.com'),
('Ahmed', 'Omar', 'omarahmed@email.com'),
('Ibrahim', 'Elhussieny', 'ibrahim95@email.com'),
('Ahmed', 'Aly', 'ahmedaly@email.com');

INSERT INTO Teachers (first_name, last_name, email) VALUES
('Ammar', 'Ahmed', 'testahmed12@email.com'),
('Omar', 'Mohammed', 'ahmedmohammedh12@email.com'),
('Saeed', 'Omar', 'omarahmed12@email.com'),
('Ibrahim', 'mohamed', 'ibrahim9512@email.com'),
('Aly', 'Ahmed', 'ahmedaly12@email.com');

INSERT INTO Courses (title, description, teacher_id, status, price) VALUES
('Python Programming', 'Learn Python from scratch', 1, 'published', 99.99),
('Web Development', 'Full-stack web development course', 2, 'published', 149.99),
('Data Science Basics', 'Introduction to Data Science', 1, 'published', 199.99),
('JavaScript Advanced', 'Advanced JavaScript concepts', 3, 'published', 129.99);

INSERT INTO Lessons (title, description, course_id, lesson_number, duration_minutes, content_type) VALUES
('Python Basics', 'Introduction to Python', 2, 1, 60, 'video'),
('Variables and Data Types', 'Understanding Python data types', 2, 2, 45, 'video'),
('Control Structures', 'If statements and loops', 2, 3, 90, 'video'),

('HTML Fundamentals', 'Basic HTML structure', 3, 1, 60, 'video'),
('CSS Styling', 'Styling web pages', 3, 2, 75, 'video'),
('JavaScript Basics', 'Introduction to JavaScript', 3, 3, 90, 'video'),

('Intro to Data Science', 'Overview of Data Science', 4, 1, 60, 'video'),
('Python for Data Science', 'Using Python in Data Science', 4, 2, 90, 'video'),
('Basic Statistics', 'Statistical concepts', 4, 3, 120, 'video'),

('Advanced Functions', 'Closures and Callbacks', 5, 1, 90, 'video'),
('Promises & Async', 'Asynchronous JavaScript', 5, 2, 120, 'video'),
('Design Patterns', 'JavaScript Patterns', 4, 3, 150, 'video');


INSERT INTO Enrollments (student_id, course_id, status, completion_percentage) VALUES
(1, 5, 'active', 66.67), 
(1, 2, 'active', 33.33), 
(2, 5, 'completed', 100.0),
(3, 3, 'active', 66.67),  
(4, 2, 'dropped', 33.33),   
(5, 4, 'active', 50.0),    
(2, 3, 'active', 25.0);

INSERT INTO Lesson_Completion (student_id, lesson_id, is_completed) VALUES
(1, 13, true),    
(1, 14, true),   
(1, 15, false),

(2, 13, true), 
(2, 14, true),
(2, 15, true),

(3, 17, true), 
(3, 18, true),
(3, 19, false),

(4, 14, true),  
(4, 15, false),
(4, 16, false);

SELECT 
    s.student_id,
    s.first_name,
    s.last_name,
    s.email,
    e.enrollment_date,
    e.status,
    e.completion_percentage
FROM 
    Students s
JOIN 
    Enrollments e ON s.student_id = e.student_id
WHERE 
    e.course_id = 5;

SELECT 
    t.teacher_id,
    t.first_name,
    t.last_name,
    c.course_id,
    c.title as course_name,
    c.status,
    c.price
FROM 
    Teachers t
JOIN 
    Courses c ON t.teacher_id = c.teacher_id
WHERE 
    t.teacher_id = 2
GROUP BY 
    t.teacher_id, t.first_name, t.last_name, c.course_id, c.title, c.status, c.price
ORDER BY 
    c.course_id;

SELECT 
    e.student_id,
    e.course_id,
    COUNT(l.lesson_id) as total_lessons,
    COUNT(CASE WHEN lc.is_completed = true THEN 1 END) as completed_lessons,
    ROUND(
        (COUNT(CASE WHEN lc.is_completed = true THEN 1 END)::DECIMAL / 
        COUNT(l.lesson_id)::DECIMAL * 100),
    2) as completion_percentage
FROM 
    Enrollments e
JOIN 
    Lessons l ON l.course_id = e.course_id
LEFT JOIN 
    Lesson_Completion lc ON lc.lesson_id = l.lesson_id 
    AND lc.student_id = e.student_id
GROUP BY 
    e.student_id, e.course_id
ORDER BY 
    e.student_id, e.course_id;
