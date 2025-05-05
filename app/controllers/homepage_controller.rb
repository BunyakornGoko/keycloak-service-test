class HomepageController < ApplicationController
  def index
    # Mock data for professor's courses
    @courses = [
      {
        code: "CS101",
        name: "Introduction to Computer Science",
        students: 42,
        schedule: "Mon/Wed/Fri 10:00 AM",
        room: "Engineering 305",
        pending_tasks: 3,
        ungraded_assignments: 12,
        color: "#3b82f6" # blue
      },
      {
        code: "CS210",
        name: "Data Structures & Algorithms",
        students: 35,
        schedule: "Tue/Thu 1:30 PM",
        room: "Engineering 201",
        pending_tasks: 0,
        ungraded_assignments: 5,
        color: "#10b981" # green
      },
      {
        code: "CS350",
        name: "Database Systems",
        students: 28,
        schedule: "Mon/Wed 3:00 PM",
        room: "Engineering 105",
        pending_tasks: 1,
        ungraded_assignments: 0,
        color: "#8b5cf6" # purple
      },
      {
        code: "CS401",
        name: "Advanced Web Development",
        students: 22,
        schedule: "Tue/Thu 9:30 AM",
        room: "Engineering 302",
        pending_tasks: 2,
        ungraded_assignments: 7,
        color: "#ec4899" # pink
      }
    ]

    # Mock data for upcoming deadlines
    @upcoming_deadlines = [
      {
        date: "May 15",
        title: "Final Project Submission",
        course_code: "CS101",
        description: "Students will submit their final projects for Introduction to Computer Science.",
        course_color: "#3b82f6"
      },
      {
        date: "May 18",
        title: "Midterm Exam",
        course_code: "CS210",
        description: "Midterm examination covering Chapters 5-8.",
        course_color: "#10b981"
      },
      {
        date: "May 20",
        title: "Database Design Assignment Due",
        course_code: "CS350",
        description: "Students must submit their normalized database designs.",
        course_color: "#8b5cf6"
      },
      {
        date: "May 25",
        title: "Guest Lecture",
        course_code: "CS401",
        description: "Industry expert presentation on modern web frameworks.",
        course_color: "#ec4899"
      }
    ]
  end
end 