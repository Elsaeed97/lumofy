import React, { useState, useEffect } from 'react';
import './CourseList.css';

const CourseList = () => {
    const [courses, setCourses] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const [currentPage, setCurrentPage] = useState(1);
    const [totalCount, setTotalCount] = useState(0);

    const formatDate = (dateString) => {
        const options = { 
            year: 'numeric', 
            month: 'long', 
            day: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
        };
        return new Date(dateString).toLocaleDateString('en-US', options);
    };

    useEffect(() => {
        fetchCourses();
    }, [currentPage]);

    const fetchCourses = async () => {
        try {
            setLoading(true);
            // we can save the url in a variable and use it here Also we will need to handle Authentication to access the API
            const response = await fetch(`http://127.0.0.1:8000/api/courses/?page=${currentPage}`); 
            if (!response.ok) {
                throw new Error('Something went wrong');
            }
            const data = await response.json();
            setCourses(data.results);
            setTotalCount(data.count);
            setLoading(false);
        } catch (err) {
            setError('Failed to fetch courses');
            setLoading(false);
        }
    };

    if (loading) {
        return <div className="loading">Loading...</div>;
    }

    if (error) {
        return <div className="error">{error}</div>;
    }

    return (
        <div className="course-list-container">
            <h2>Available Courses</h2>
            <div className="course-grid">
                {courses.map(course => (
                    <div key={course.id} className="course-card">
                        <h3>{course.title}</h3>
                        <div className="course-details">
                            <p><strong>Teacher:</strong> {course.teacher}</p>
                            <p><strong>Description:</strong> {course.description}</p>
                            <p><strong>Lessons:</strong> {course.number_of_lessons}</p>
                            <div className="time-details">
                                <p><strong>Created:</strong> {formatDate(course.created_at)}</p>
                                <p><strong>Last Updated:</strong> {formatDate(course.updated_at)}</p>
                            </div>
                        </div>
                    </div>
                ))}
            </div>
            
            <div className="pagination">
                <button 
                    onClick={() => setCurrentPage(prev => prev - 1)} 
                    disabled={!courses.previous}
                    className="pagination-button"
                >
                    Previous
                </button>
                <span className="page-info">
                    Showing {courses.length} of {totalCount} courses
                </span>
                <button 
                    onClick={() => setCurrentPage(prev => prev + 1)} 
                    disabled={!courses.next}
                    className="pagination-button"
                >
                    Next
                </button>
            </div>
        </div>
    );
};

export default CourseList;