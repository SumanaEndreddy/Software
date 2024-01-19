# Comaprable module provides comparison operators <, <=, >, >= to 
# compare instances of student objects.
class Student
  include Comparable
  attr :units # defines attributes for instances of student class

  # initialize is the constructor of student class. Called when a new instance of the 'Student'
  # class is created. Lines 11 - 18 set the instance variables of the 'Student' object to
  # the values provided ot the constructor

  def initialize(_id, _units, _num_crs, _prereq, _choices, alloted = 0,c_alloted = "None",_reson = "N/A")
    @studentID = _id
    @units = _units
    @num_courses = _num_crs
    @prereq = _prereq
    @choices = _choices
    @course_alloted = alloted.to_int
    @couses_Name_alloted = c_alloted
    @reson = _reson
  end

  # defines accessor methods for several instances of the 'Student' object to 
  # the values provided to the constructor
  attr_accessor :studentID, :units, :num_courses, :choices, :prereq, :alloted, :course_alloted,:couses_Name_alloted,:reson

  # Lines 32-42 create a string called details that contain information about
  # student object. It includes studentID, units, num_courses, prereq, choices,
  # and course_allocated instance variables. The 'prereq' and 'choices' instance variables are
  # are arrays, so they are converted to strings using the 'each' method to iterate over each
  # element and add it to the 'details' string. The resulting details is then printed to 
  # the console using puts
  def show
    details = ""
    details += "#{studentID} - #{units} -  #{num_courses} - "
    prereq.each do |digit|
      details += (digit + " ")
    end
    details += " - "
    choices.each do |digit|
      details += (digit + " ")
    end
    details += " - #{course_alloted}" + couses_Name_alloted
    puts "#{details}"
  end
end

# initialize is the constructor for 'course' class. Takes 5 parameters and assigns them to
# instance variables with the same name. The 'to_i' method is called to convert to integers
class Course
  def initialize(_c_name, _n_sects, _min_enrl, _max_enrl, _prereq)
    @course_name = _c_name
    @num_sections = _n_sects.to_i
    @min_enroll = _min_enrl.to_i
    @max_enroll = _max_enrl.to_i
    @prereq = _prereq
  end

  # show method prints out the details of the course object. First creates a string called
  # 'details' and initializes it to the value of the 'course_name', 'num_sections', 'min_enroll'
  # instance variables. It then iterates through the 'prereq' instance variable using the
  # 'each' method & adds each element to the 'details' string, seperated by space
  def show
    details = course_name + " #{num_sections}  #{min_enroll}  #{max_enroll} "
    prereq.each do |digit|
      details += (digit + " ")
    end
    puts "#{details}"
  end

  # includes attribute reader for each of the instance variables. This allows access to
  # to these variables from outside the class without allowing them to be modified
  attr_reader :course_name, :num_sections, :min_enroll, :max_enroll, :prereq
end

# Class 'FileReader' responsible for reading the content of a file.
# construtor is defined. Takes 1 argument, 'filename' and sets it to nil by default
# Inside the method, the 'filename' argument is assigned to the 'file' attribute of the
# object using 'self.file = filename'. Then a file handle is opened for the 'filename' 
# argument using 'File.open(filename)' & assigned to 'file_handle'
class FileReader
  def initialize(filename = nil)
    self.file = filename
    self.file_handle = File.open(filename)
  end

  attr_accessor :file # allowing it to read and modified outside of the class

  def read # empty method that will be overridden by a subclass
  end
 
  # keyword indicates that the methods following it are protected and can only be
  # called from within the object or its subclasses
  protected 

  # The attribute is marked as 'protected' so it can only be accessed from within the
  # object or its subclasses. This line defines an attribute accessor for the
  # 'file_handle' attribute of the 'FileReader' class allowing it to be read &
  # modified outside of the class.
  attr_accessor :file_handle
end

# FileWriter method provides methods for writing to a file.
# Opens file for writing using the 'File.open' method with the 'w' mode
class FileWriter
  def initialize(filename = nil)
    self.file = filename
    self.file_handle = File.open(filename,"w")
  end
  attr_accessor :file # creates getter & setter method for 'file' attribute
  # write method takes any number of arguments, concatenates them into a single string
  # seperated by commas, adds a new line character after the last comma, & writes the
  # resulting string to the file using 'file_handle.write' method
  def write(*txt_args)
    line = ""
    txt_args.each do |txt|
      line = line + txt.to_s
      line = line + ","
    end
    index = line.rindex(",")
    line = line[0...index] + "\n" + line[index + 1..-1]
    file_handle.write(line)
  end
  def write_line(txt) # writes a single line of a text passed as an argument to the file using 'file_handle.write' method
    file_handle.write(txt)
  end
  def close # closes the file
    file_handle.close()
  end
  protected # indicates that the file_handle attribute can only be accessed from within the class
  attr_accessor :file_handle
end

# defines a class 'StudentReader' that extends the 'FileReader' class. 
# Contains methods for reading and parsing data from a file of student information
# When new 'StrudentReader' object is created, it initilizes an emptry array 'students_ds' & calls
# the constructor of the superclass 'FileReader'
class StudentReader < FileReader
  def initialize(filename)
    self.students_ds = []
    super
    file = filename
  end
  # sorts 'students_ds' array in descending order based on the number of units each student
  # has taken
  def student_sort_by_units()
    sort_by_units = students_ds.sort_by { |student| -1 * student.units }
    students_ds = sort_by_units

    # students_ds.each do |item|
    #   item.show()
    # end
  end
  # method searches for a student object in the 'student_ds' array by studentID & returns the
  # matching object if it exists
  def get_student_obj(sdtId)
    students_ds.each do |item|
      if item.studentID == sdtId
        return item
      end
    end
  end
  # reads the data from the file, lin eby line, & calls 'parse_txt' methos to
  # convert each line of text into a 'Student' object. Also, 'student_ds' is an attribute
  # that holds 'Student' objects
  def read
    line_num = 0
    file_handle.each do |txt|
      line = txt.delete("\n")
      if line_num != 0
        student_obj = parse_txt(line)
        if student_obj != nil
          students_ds.push(student_obj)
        end
      end
      line_num += 1
    end
    self.student_sort_by_units()
  end
  # takes a comma-seperated line of text & converts it into a 'Student' object.
  # first removes any new line or carriage return characters from the string
  # splits the string into list of values using commas as the seperator, and 
  # uses these values to create a new' Student' object
  def parse_txt(txt)
    formated_txt = txt.delete("\n")
    formated_txt = txt.delete("\r")
    list = formated_txt.split(",")
    if list.length > 4
      obj3list = list[3].split(";")
      obj4list = list[4].split(";")
      return Student.new(list[0].to_i, list[1].to_i, list[2].to_i, obj3list, obj4list)
    else
      return nil
    end
  end

  attr_accessor :students_ds
end

# Class that inherits from 'FileReader'. 'Initilize' method calls the parent class 'FileReader's
# initialize method to create a new file object, and initlizes the instance varibale 'course_ds'
# as an empty array
class CourcesReader < FileReader
  def initialize(filename)
    self.course_ds = []
    super
    file = filename
  end
  # method takes a string '_c_name' as an argument $ searches for an object in the 'course_ds'
  # array that has a matching 'course_name' attribute. If the matching object is found, it is
  # returned; otherwise nil is returned
  def get_course_obj(_c_name)
    course_ds.each do |item|
      if item.course_name == _c_name
        return item
      end
    end
    return nil
  end
  # reads the file using the 'Filereader' parent class's 'read' method. It reads each line of
  # file, converts it into a 'Course' object using the 'parse_text' method, and adds it to the
  # 'course_ds' array
  def read
    line_num = 0
    file_handle.each do |txt|
      line = txt.delete("\n")
      if line_num != 0
        course_obj = parse_txt(line)
        if course_obj != nil
          course_ds.push(course_obj)
        end
      end
      line_num += 1
    end
    # course_ds.each do |obj|
    #   obj.show
    # end
  end
  # method takes a line of text from the file as an argument, formats it, & splits into an array of strings
  # It then creates and returns a new 'Course' object with attributes initialized using the array of objects
  def parse_txt(txt)
    formated_txt = txt.delete("\n")
    formated_txt = txt.delete("\r")
    list = formated_txt.split(",")
    return unless list.length > 4

    obj4list = list[4].split(";")
    obj4removedspae_list = Array.new
    obj4list.each do |item|
      obj4removedspae_list << (item.delete(" ").to_s)
    end
    Course.new(list[0].delete(" "), list[1], list[2], list[3], obj4list)
  end
  # creates getter and setter methods for the 'course_ds' attribute
  attr_accessor :course_ds
end

# ClassEnroll defines two nested data structures 'CourseStudents' and 'StudentsPerSections'
# has 2 instance varibales, @student_list, and @course, and 2 methods, 'add_stduent' and 
# 'set_course'

class ClassEnroll
  CourseStudents = Class.new do
    attr_accessor :stduent_list
    attr_accessor :course

    def initialize
      @stduent_list = Array.new
      @course = nil
    end

    def add_studnet(s)
      stduent_list << s
    end

    def set_course(c)
      @course = c
    end
  end

  StudentsPerSections = Struct.new(:section,:students,:has_to_cancel)
  CouseSections = Struct.new(:course,:sections)
  
  # Process method reads course and student data from input files provided as
  # arguments. It iterates through the student list, and for each student, it
  # ierates through their course choices. If a student's num of courses alloted
  # and the number of choices made by them is less than two, then their
  # prerequisites are checked for each course. If the prerequisites are met,
  # the course is alloted to the student
  
  def Process(course_file,student_file)
    # puts '---------------Course Details--------------------'
    course_mgr = CourcesReader.new(course_file)
    course_mgr.read()

    #puts '---------------Student Details--------------------'
    studnet_mgr = StudentReader.new(student_file)
    studnet_mgr.read()
    is_prereqs_satisfied = true
    course_student_map = [nil]
    studnet_mgr.students_ds.each do |student|
      student.choices.each do |choice|
        if (student.course_alloted < student.num_courses) && (student.course_alloted < 2)
          if choice != "None"
            _course = course_mgr.get_course_obj(choice)
            if _course != nil && _course.num_sections > 0
              _prereqs = _course.prereq
              _prereqs.each do |prereq_item|
                if prereq_item == "None"
                  is_prereqs_satisfied = true
                else
                  is_prereqs_satisfied = is_prereqs_satisfied && student.prereq.include?(prereq_item)
                end
              end
              # puts is_prereqs_satisfied
              if is_prereqs_satisfied
                is_course_cound = nil
                course_student_map.each do |item|
                  if item != nil && item.course != nil
                    if item.course.course_name == _course.course_name
                      is_course_cound = item
                    end
                  end
                end

                # is_prereqs_satisfied = true
                if is_course_cound == nil
                  newItem = CourseStudents.new
                  student.course_alloted += 1
                  newItem.set_course(_course)
                  newItem.add_studnet(student)
                  student.couses_Name_alloted << _course.course_name.to_s << ";"
                  course_student_map << newItem
                else
                  student.course_alloted += 1
                  is_course_cound.add_studnet(student)
                  _name = _course.course_name + ";"
                  student.couses_Name_alloted << _course.course_name.to_s << ";"
                 end
              else
                student.reson = "Prereq are not met"
              end
              is_prereqs_satisfied = true
            end
          end
        else
          if student.course_alloted > student.num_courses
            student.reson = "Allocated number of courses are more than requested "
          elsif student.course_alloted >= 2
            student.reson = "Requested courses are more than 2 "
          elsif student.num_courses==0
            student.reson = "Requested courses are zero "
          end
        end
      end
    end

    # Once all the students have been alloted courses, the students who have been
    # alloted courses for a given courses are sorted by whether they have chosen
    # "None" as their course choice. The 'course-student_map' array is then created 
    # to map each course with the students who have been alloted the course
    course_student_map.each do |course_students|
      if course_students != nil && course_students.stduent_list != nil
        course_students.stduent_list = course_students.stduent_list.sort_by { |student|
            student.choices.include?("None") ? 1: 0 }
      end
    end
    course_sections_students_map = Array.new() #  StudentsPerSections = Struct.new(:section,:students,:has_to_cancel)
                                                #CouseSections = Struct.new(:course,:sections)
    
    # The course_student_map array is iterated over, and if the nuber of students for a course is greater
    # than or equal to the minum enrollement and less than or equal to the maximum enrollment
    # sections are created for the course, and each section is filled with students. If the number of
    # students for a course is greater than the maximum enrollment, the extra students have to be 
    # cancelled or adjusted.
    course_student_map.each do |course_students|
      if course_students== nil
        next
      end
      max_students_require = course_students.course.num_sections * course_students.course.max_enroll
      students_length = course_students.stduent_list.length

      if students_length>= max_students_require
        students_per_sections_list = Array.new
        for a in 0..course_students.course.num_sections-1 do
          students = Array.new
          min_to_start = (a)*course_students.course.max_enroll
          max_end = min_to_start+course_students.course.max_enroll-1
          for index in min_to_start..max_end do
            students << course_students.stduent_list[index]
          end
          students_per_sections = StudentsPerSections.new(a+1,students,"Ok")
          students_per_sections_list << students_per_sections
        end
        course_sections_students_map << CouseSections.new(course_students.course,students_per_sections_list)

      elsif students_length>= course_students.course.min_enroll
        sections_required = 0
        studnets_required_per_section = 0
        students_has_to_adjusted = 0
        for a in course_students.course.min_enroll..course_students.course.max_enroll do
          num_students_per_course = students_length%a
          if num_students_per_course < course_students.course.min_enroll
            sections_required = (students_length/a)-1
            studnets_required_per_section = a-1

            if(studnets_required_per_section < course_students.course.max_enroll)
              students_has_to_adjusted = num_students_per_course
            else
              students_has_to_adjusted = "Cancel"
            end
            break
          end
        end
        students_per_sections_list = Array.new
        step = 0
        for a in 0..sections_required do
          students = Array.new
          min_to_start =0
          max_end = 0
          if students_has_to_adjusted > 0 && students_has_to_adjusted.is_a?(Integer)
            students_has_to_adjusted = students_has_to_adjusted-1
            step = step+1
          end
          min_to_start = a*studnets_required_per_section  + a >0 ? step :0
          max_end = min_to_start+studnets_required_per_section + a + a >0 ? step :0

          max_end = min_to_start+studnets_required_per_section
          for index in min_to_start..max_end do
            students << course_students.stduent_list[index]
          end
          students_per_sections = StudentsPerSections.new(a+1,students,"Ok")
          students_per_sections_list << students_per_sections
        end
        course_sections_students_map << CouseSections.new(course_students.course,students_per_sections_list)
        if !students_has_to_adjusted.is_a?(Integer)
          min_to_start = sections_required*studnets_required_per_section
          for index in min_to_start..students_length-1 do
            students << course_students.stduent_list[index]
          end
          students_per_sections = StudentsPerSections.new(sections_required+1,students,"Cancel")
          students_per_sections_list << students_per_sections
          course_sections_students_map << CouseSections.new(course_students.course,students_per_sections_list)
        end


      elsif students_length< course_students.course.min_enroll
        # cancel
        students = Array.new
        students_per_sections_list = Array.new
        for index in 0..students_length-1 do
          students << course_students.stduent_list[index]
        end
        students_per_sections = StudentsPerSections.new(1,students,"Cancel")
        students_per_sections_list << students_per_sections
        course_sections_students_map << CouseSections.new(course_students.course,students_per_sections_list)
      end
    end
  
  #-------------------Outputfile writing format 1 type---------------------------------------  
    
  # creates 3 'fileWriter' objects to write to three different outputs files. 

    file_writer_by_course = FileWriter.new("output_enrollment_by_course.csv")
    file_writer_by_student = FileWriter.new("output_enrollment_by_student.csv")
    file_writer_by_summery = FileWriter.new("output_enrollment_by_summary.txt")
    file_writer_by_course.write("Course-Num,Section-Num,Roster,Num-Enroll,Balance,Status")
   
  # iterates through the 'course_sections_students_map' which seems to be a map of 
  # 'CourseSectionStudents' objects, and for each 'CourseSectionsStudents' object, it
  # retrieves the course name and iterates through each section in the course. For
  # each section, it retrieves the list of students enrolled in the section, creates
  # a string of their studentIDs, and calculates enrollemnt balance(max enrollemnt - current enrollemnt)
   
    course_sections_students_map.each do |course_students|
      if course_students != nil && course_students.course != nil
        # puts "___________Start______________"
        course_name = course_students.course.course_name
        course_students.sections.each do |section|
          if section == nil
            next
          end
          students_ids = ""
          for index in 0..section.students.length do
            if section.students == nil || section.students[index] == nil
              next
            end
            studentid = section.students[index].studentID.to_s
            if index == (section.students.length-1)
              students_ids = students_ids + studentid
            else
              students_ids = students_ids + studentid +";"
            end
          end
          balace = course_students.course.max_enroll - section.students.length
          if students_ids.length == 0
            students_ids ="None"
          end

        # then, it writes row of data to the 'output_enrollemnt_by_course.csv' file using the
        # write() method of the 'FileWriter' object. The row contains the course name, section
        # number, roster, num of enrollments, balance, enrollment status
          file_writer_by_course.write(course_name,section.section,students_ids,section.students.length,balace,section.has_to_cancel)
          students_ids = "None"
        end
        # puts "___________END______________"
      end
    end
    file_writer_by_course.close()


#---------------------------Outputfile writing format 2 type-------------------------------
# The code writes the enrollmetn data for each student to a CSV file named 
# 'output_enrollment_by_student.csv'. The fields written to the file include 
# Student-id, course, num-req, and reason

    file_writer_by_student.write("Student-Id,Course,Num-Req,Reson")
   
# loops through each student in the student manager's list of students, and for each
# student, it extracts the courses they are enrolled in, the num of courses
# they are enrolled in. The extracted data is then written to the output file
# using the write method of the 'FileWriter' instance 
    studnet_mgr.students_ds.each do |student|
      if student == nil
        next
      end
      courses_names = student.couses_Name_alloted
      if courses_names != "None"
        courses_names = courses_names[0..-2]
        courses_names = courses_names.gsub("None", "")
      end
      file_writer_by_student.write(student.studentID,courses_names,student.num_courses,student.reson)
    end
    file_writer_by_student.close()


    #----------------------Outputfile 3 Summary----------------------------------
    # calculates the summary statistics and writing to them to a
    # a text file and to console. Iterates over the 'course_sections_students_map'
    # to count the total number of valid students and the number of course sections
    # that will run vs the number that may be cancelled
    total_Students_valid = 0
    number_of_sections_to_run =0
    number_of_section_that_may_cancel = 0
    course_sections_students_map.each do |course_students|
      if course_students != nil && course_students.course != nil

        course_name = course_students.course.course_name
        course_students.sections.each do |section|
          if section == nil
            next
          end
          students_ids = ""
          if section.has_to_cancel == "Ok"
            total_Students_valid +=section.students.length
            number_of_sections_to_run += 1
          else
            number_of_section_that_may_cancel+=1
          end
        end
      end
    end
    text = "Number of Students: " << total_Students_valid.to_s
    text <<"\n" << "Number of Course Sections: " << number_of_sections_to_run.to_s
    text <<"\n" << "Number of Course Sections may cancel  : " << number_of_section_that_may_cancel.to_s
    text <<"\n"
   
   # at the end of the loop, the summary message is constructed and
   # written to a file using 'file_writer_by_summary_line' and printed
   # to the console using puts
   
    file_writer_by_summery.write_line(text)
    puts "---------------Summary---------------"
    puts text
    puts "-------------------------------------"
    file_writer_by_summery.close()
  end

  def check_args(a)

      puts "Run app with course file followed by studentcsv files  \n ex: ruby app.rb course.csv students.csv"
      ARGV.each do |arg|
        puts "Argument: #{arg}"
      end
  end
end

# defines a method called main and creates a new instance of
# "Class Enroll" and assigns it variable enroll. 
# Checks whether the program is called with fewer than 2 arguments
# If the program is called with 2 or more args, process method is called
def main
  enroll = ClassEnroll.new
  if(ARGV.length < 2)
    enroll.check_args(ARGV)
  else
    enroll.Process(ARGV[0],ARGV[1])
  end
end

main
