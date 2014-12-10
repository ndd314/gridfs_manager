class FoldersController < ApplicationController
  def index
    @home_folder = home_folder
  end

  def show
    @current_folder ||= Folder.find(params[:id])
  end

  def new
    @parent_folder ||= Folder.find(params[:parent_folder_id]) if params[:parent_folder_id]
    @parent_folder ||= home_folder
    @folder = Folder.new(parent_folder: @parent_folder)
  end

  def create
    attributes = params[:folder].symbolize_keys
    parent_folder_id = attributes[:parent_folder_id] || home_folder.id
    attributes = attributes.merge(parent_folder_id: parent_folder_id)
    @folder = Folder.new(attributes)
    @folder.save!
    redirect_to action: 'show', id: parent_folder_id
  end
end
