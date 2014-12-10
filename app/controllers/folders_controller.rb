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

    begin
      @folder = Folder.new(attributes)
      @folder.save!
      notice = 'Successfully created folder.'
    rescue StandardError => e
      alert = e.message
    end

    redirect_to action: 'show', id: parent_folder_id, notice: notice, alert: alert
  end

  def destroy
    @current_folder ||= Folder.find(params[:id])

    begin
      @current_folder.destroy
      redirect_to @current_folder.parent_folder, notice: 'Successfully deleted folder.'
    rescue StandardError => e
      redirect_to @current_folder, alert: e.message
    end
  end
end
