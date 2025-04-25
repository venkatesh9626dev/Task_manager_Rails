class Tasks::CommentsController < ApplicationController
    
  def create
    @task = Task.find(params[:task_id])
    @comment = @task.comments.new(comment_params)
    @comment.team_member = @current_user.team_members.find_by(team_id: @task.team_id)

    if @comment.save
      set_instance_variable(self, status_message: "Success", message: "Comment created successfully")
      render "tasks/comment/create", status: :created
    else
      set_instance_variable(self, status_message: "Error", message: "Failed to create comment")
      render "shared/error_response", status: :unprocessable_entity
    end
  end

  def update
    @comment = Comment.find(params[:id])
    if @comment.update(comment_params)
      set_instance_variable(self, status_message: "Success", message: "Comment updated successfully")
      render "tasks/comment/update", status: :ok
    else
      set_instance_variable(self, status_message: "Error", message: "Failed to update comment")
      render "shared/error_response", status: :unprocessable_entity
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.destroy
      set_instance_variable(self, status_message: "Success", message: "Comment deleted successfully")
      render "tasks/comment/destroy", status: :ok
    else
      set_instance_variable(self, status_message: "Error", message: "Failed to delete comment")
      render "shared/error_response", status: :unprocessable_entity

    end
  end
  
  def show
    @task = Task.find(params[:task_id])
    @comments = @task.comments

    if @comments.empty?
      set_instance_variable(self, status_message: "Success", message: "No comments exist for this task")
      render "tasks/comment/show", status: :ok
    else
      set_instance_variable(self, status_message: "Success", message: "Fetched all comments for task successfully")
      render "tasks/comment/show", status: :ok
    end
  end

  def comment_params
    params.require(:comment).permit(:body)
  end


end