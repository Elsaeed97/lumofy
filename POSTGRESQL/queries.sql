--- Holds the task sql quereies ----
--- 1. Retrieve all students enrolled in a given course.
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
    JOIN Enrollments e ON s.student_id = e.student_id
WHERE
    e.course_id = 5;

--- 2. Get the progress of each student per course based on lesson completion.
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
    
--- 3. Retrieve the courses a teacher is assigned to.
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
    JOIN Courses c ON t.teacher_id = c.teacher_id
WHERE
    t.teacher_id = 2
GROUP BY
    t.teacher_id,
    t.first_name,
    t.last_name,
    c.course_id,
    c.title,
    c.status,
    c.price
ORDER BY
    c.course_id;