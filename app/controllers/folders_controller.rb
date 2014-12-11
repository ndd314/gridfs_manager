class FoldersController < ApplicationController
  def index
    @home_folder = home_folder
    redirect_to @home_folder
  end

  def show
    @current_folder ||= Folder.find(params[:id])

    authorize! :manage, @current_folder

    @image_files = @current_folder.files.any_of(name: /.*\.(png|bmp|jpg)$/i)
  end

  def new
    @parent_folder ||= Folder.find(params[:parent_folder_id]) if params[:parent_folder_id]
    @parent_folder ||= home_folder

    authorize! :manage, @parent_folder

    @folder = Folder.new(parent_folder: @parent_folder)
  end

  def create
    attributes = params[:folder].symbolize_keys
    parent_folder_id = attributes[:parent_folder_id] || home_folder.id
    attributes = attributes.merge(parent_folder_id: parent_folder_id)
    parent_folder = Folder.find parent_folder_id

    authorize! :manage, parent_folder

    begin
      @folder = Folder.new(attributes)
      @folder.save!
      redirect_to parent_folder, notice: "Successfully created new folder."
    rescue StandardError => e
      redirect_to parent_folder, alert: e.message
    end
  end

  def destroy
    @current_folder ||= Folder.find(params[:id])

    authorize! :manage, @current_folder

    begin
      @current_folder.destroy
      redirect_to @current_folder.parent_folder, notice: 'Successfully deleted folder.'
    rescue StandardError => e
      redirect_to @current_folder, alert: e.message
    end
  end
end
