class Api::TodoListsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def index
    render json: TodoList.all
  end

  def show
    list = TodoList.find(params[:id])
    render json: list
  end

  def create
    list = TodoList.new(list_params)
    if list.save
      render status: 200, json: {
        message: "Successfully created Todo List.",
        todo_list: list
      }.to_json
    else
      render status: 422, json: {
        message: "Sorry, something went wrong.",
        errors: list.errors
      }.to_json
    end
  end

  def update
    list = TodoList.new(list_params)
    if list.update_attribues(list_params)
      render status: 200, json: {
        message: "Successfully Updated.",
        todo_list: list
      }.to_json
    else
      render status: 422, json: {
        message: "Sorry, that todo list could not be updated.",
        errors: list.errors
      }.to_json
    end
  end

  def destroy
    list = TodoList.find(params[:id])
    if list.destroy
      render status: 200, json: {
        message: "Successfully deleted Todo List."
      }.to_json
    else
      render status: 500, json: {
        message: "Sorry, something went wrong.",
        errors: list.errors
      }.to_json
    end
  end

  private
  def list_params
    params.require("todo_list").permit("title")
  end
end