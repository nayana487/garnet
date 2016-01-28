class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update, :destroy]

  def index
    @courses = Course.all
  end

  def show
    authorize! :show, @course
  end

  def new
    @course = Course.new
    authorize! :new, @course
  end

  def edit
    authorize! :edit, @course
  end

  def create
    @course = Course.new(course_params)
    authorize! :create, @course
    if @course.save
      redirect_to @course, notice: 'Course was successfully created.'
    else
      render :new
    end
  end

  def update
    authorize! :update, @course
    if @course.update(course_params)
      redirect_to @course, notice: 'Course was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    authorize! :destroy, @course
    @course.destroy
    redirect_to courses_url, notice: 'Course was successfully destroyed.'
  end

  private
  def set_course
    @course = Course.find(params[:id])
  end

  def course_params
    params.require(:course).permit(:name, :short_name, :format)
  end
end
