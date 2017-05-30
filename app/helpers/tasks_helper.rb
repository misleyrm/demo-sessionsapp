module TasksHelper

  def add_deadline
    @task.update_attribute(:deadline, params[:datepicker])
    respond_to do |format|
      format.html {  redirect_to @list, notice: "Task completed" }
      format.js
    end
  end

end
