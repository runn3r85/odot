class Api::TodoItemsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :find_todo_list

  def create
    item = @todo_list.todo_items.new(item_params)
    if list.save
      render status: 200, json: {
        message: "Successfully created Todo Item.",
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
    item = @todo_list.todo_items.find(params[:id])
    if item.update_attribues(item_params)
      render status: 200, json: {
        message: "Successfully Updated.",
        todo_list: list
      }.to_json
    else
      render status: 422, json: {
        message: "Sorry, that todo item could not be updated.",
        errors: list.errors
      }.to_json
    end
  end

  def destroy
    item = @todo_list.todo_items.find(params[:id])
    if list.destroy
      render status: 200, json: {
        message: "Successfully deleted Todo Item."
      }.to_json
    else
      render status: 500, json: {
        message: "Sorry, something went wrong.",
        errors: list.errors
      }.to_json
    end
  end

  private
  def item_params
    params.require("todo_item").permit("content")
  end

  def find_todo_list
    @todo_list = TodoList.find(params[:todo_list_id])
  end
end